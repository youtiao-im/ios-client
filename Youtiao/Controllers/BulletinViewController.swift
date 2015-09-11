import Foundation

class BulletinViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var stampsTableView: UITableView!

  var bulletin: Bulletin!

  var stamps: [Stamp] = [Stamp]()
  var lastStamp: Stamp?

  var warningAlertView: UIAlertView!

  var prototypeCell: BulletinCell!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    let bulletinCellNib = UINib(nibName: "BulletinCell", bundle: nil)
    self.stampsTableView.registerNib(bulletinCellNib, forCellReuseIdentifier: "BulletinCell")
    let viewArray: NSArray = NSBundle.mainBundle().loadNibNamed("BulletinCell", owner: self, options: nil)
    self.prototypeCell = viewArray.objectAtIndex(0) as! BulletinCell

    if NSString(string: UIDevice.currentDevice().systemVersion).floatValue >= 8.0 {
      self.stampsTableView.rowHeight = UITableViewAutomaticDimension
      self.stampsTableView.estimatedRowHeight = 160.0
    }
    self.stampsTableView.tableFooterView = UIView()

    self.stampsTableView.ins_addInfinityScrollWithHeight(60.0,
      handler: { (scrollView: UIScrollView!) -> Void in
        self.loadMoreStamps()
    })

    let infinityIndicator = INSDefaultInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24.0, height: 24.0))
    self.stampsTableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)
    infinityIndicator.startAnimating()

    self.loadStamps()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleStampBulletinSuccessNotification:"), name: "stampBulletinSuccessNotification", object: nil)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.eyeBulletin()
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: "stampBulletinSuccessNotification", object: nil)
  }

  func loadStamps() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.fetchStampsForBulletin(bulletin,
      success: { (stamps: [Stamp]) -> Void in
        self.lastStamp = stamps.last
        self.handleLoadStampsSuccess(stamps)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.stampsTableView.ins_infiniteScrollBackgroundView.enabled = stamps.count >= 25
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if error is ForbiddenError || error is NotFoundError {
          var errMsg = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errMessage: errMsg)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func loadMoreStamps() {
    if let lastStamp = lastStamp {
      APIClient.sharedInstance.fetchStampsForBulletin(bulletin, createdBeforeStamp: lastStamp,
        success: { (stamps: [Stamp]) -> Void in
          if stamps.count > 0 {
            self.lastStamp = stamps.last
            self.handleLoadStampsSuccess(stamps)
          }
          self.stampsTableView.ins_infiniteScrollBackgroundView.endInfiniteScrollingWithStoppingContentOffset(true)
          self.stampsTableView.ins_infiniteScrollBackgroundView.enabled = stamps.count >= 25
        }, failure: { (error: NSError) -> Void in
          self.stampsTableView.ins_endInfinityScroll()
          if error is ForbiddenError || error is NotFoundError {
            var errMsg = ErrorsHelper.errorMessageForError(error)
            self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errMessage: errMsg)
          } else {
            ErrorsHelper.handleCommonErrors(error)
          }
        }
      )
    }
  }

  private func handleLoadStampsSuccess(stamps: [Stamp]) -> Void {
    if self.stamps.count > 0 {
      let firstStampItem = self.stamps[0]
      let firstStampId = firstStampItem.id
      for var i = 0; i < stamps.count; i++ {
        let oneStampItem = stamps[i]
        if oneStampItem.id != firstStampId {
          self.stamps.append(oneStampItem)
        }
      }
    } else {
      self.stamps += stamps
    }
    self.stampsTableView.reloadData()
  }

  func checkBulletin(sender: UIButton!) {
    APIClient.sharedInstance.stampBulletin(self.bulletin, withSymbol: "check", success: { (bulletin: Bulletin) -> Void in
        let originalBulletinObject: Bulletin = self.bulletin
        self.bulletin = bulletin
        let userInfo = ["originalBulletin": originalBulletinObject, "newBulletin": bulletin]
        NSNotificationCenter.defaultCenter().postNotificationName("stampBulletinSuccessNotification", object: nil, userInfo: userInfo)
      }, failure: { (error: NSError) -> Void in
        var errorMessage: String
        if error is ForbiddenError || error is NotFoundError {
          errorMessage = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errMessage: errorMessage)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func crossBulletin(sender: UIButton!) {
    APIClient.sharedInstance.stampBulletin(self.bulletin, withSymbol: "cross", success: { (bulletin: Bulletin) -> Void in
        let originalBulletinObject: Bulletin = self.bulletin
        self.bulletin = bulletin
        let userInfo = ["originalBulletin": originalBulletinObject, "newBulletin": bulletin]
        NSNotificationCenter.defaultCenter().postNotificationName("stampBulletinSuccessNotification", object: nil, userInfo: userInfo)
      }, failure:{ (error: NSError) -> Void in
        var errorMessage: String
        if error is ForbiddenError || error is NotFoundError {
          errorMessage = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warnig"), errMessage: errorMessage)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func eyeBulletin() {
    if self.bulletin.currentStamp != nil {
      return
    }
    APIClient.sharedInstance.stampBulletin(self.bulletin, withSymbol: "eye", success: { (bulletin: Bulletin) -> Void in
        let originalBulletinObject: Bulletin = self.bulletin
        self.bulletin = bulletin
        self.stampsTableView.reloadData()
        let userInfo = ["originalBulletin": originalBulletinObject, "newBulletin": bulletin]
        NSNotificationCenter.defaultCenter().postNotificationName("stampBulletinSuccessNotification", object: nil, userInfo: userInfo)
      }, failure: { (error: NSError) -> Void in
        var errorMessage: String
        if error is ForbiddenError || error is NotFoundError {
          errorMessage = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errMessage: errorMessage)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func handleStampBulletinSuccessNotification(notification: NSNotification) {
    let userInfo = notification.userInfo as! [String : AnyObject]
    let originalBulletinObject = userInfo["originalBulletin"] as! Bulletin
    let newBulletinObject = userInfo["newBulletin"] as! Bulletin
    if let newCurrentStamp = newBulletinObject.currentStamp {
      var foundStampIndex = -1
      for var i = 0; i < self.stamps.count; i++ {
        let stampItem = self.stamps[i]
        if stampItem.id == originalBulletinObject.currentStamp?.id {
          foundStampIndex = i
          self.stamps[i] = newCurrentStamp
          break
        }
      }
      if foundStampIndex >= 0 {
        self.stampsTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        self.stampsTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: foundStampIndex, inSection: 1)], withRowAnimation: UITableViewRowAnimation.None)
      } else {
        self.stamps.insert(newCurrentStamp, atIndex: 0)
        self.stampsTableView.beginUpdates()
        self.stampsTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        self.stampsTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Middle)
        self.stampsTableView.endUpdates()
      }
    }
  }

  func displayErrorMessage(title: String, errMessage: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errMessage, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }
}

// MARK: - UITableViewDataSource
extension BulletinViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else if section == 1 {
      return stamps.count
    }
    return 0
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    if indexPath.section == 0 {
      cell = tableView.dequeueReusableCellWithIdentifier("BulletinCell") as! BulletinCell
      let theCell: BulletinCell = cell as! BulletinCell
      theCell.groupNameLabel.text = self.bulletin.group?.name
      theCell.checksCountLabel.text = self.bulletin.checksCount?.stringValue
      theCell.crossesCountLabel.text = self.bulletin.crossesCount?.stringValue
      theCell.eyeCountLabel.text = self.bulletin.eyesCount?.stringValue
      var totalCountText: String
      if self.bulletin.checksCount != nil && self.bulletin.crossesCount != nil && self.bulletin.eyesCount != nil {
        let totalCount = self.bulletin.checksCount!.integerValue + self.bulletin.crossesCount!.integerValue + self.bulletin.eyesCount!.integerValue
        totalCountText = String(totalCount)
      } else {
        totalCountText = NSLocalizedString("Unknown", comment: "Unknown")
      }
      if self.bulletin.eyesCount != nil {
        theCell.eyeCountLabel.text = self.bulletin.eyesCount!.stringValue + "/" + totalCountText
      } else {
        theCell.eyeCountLabel.text = NSLocalizedString("Unknown", comment: "Unknown") + "/" + totalCountText
      }

      let postTime = self.bulletin.createdAt?.doubleValue
      let postTimeString = TimeHelper.formattedTime(postTime!)
      var ownerName = self.bulletin.createdBy?.name
      if ownerName == nil {
        ownerName = NSLocalizedString("Unknown name", comment: "Unknown user")
      }
      theCell.timeLabel.text = postTimeString
      var textContent = self.bulletin.text
      var prefixText = ownerName! + ": "
      textContent = prefixText + textContent!
      var mutableAttributedString = NSMutableAttributedString(string: textContent!)
      mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, count(prefixText)))
      mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSMakeRange(0, count(prefixText)))
      theCell.textContentLabel.attributedText = mutableAttributedString
      if self.bulletin.currentStamp != nil {
        switch self.bulletin.currentStamp!.symbol! {
          case "check":
            theCell.checked = true
            theCell.crossed = false
          case "cross":
            theCell.checked = false
            theCell.crossed = true
          default:
            break
        }
      } else {
        theCell.checked = false
        theCell.crossed = false
      }
      theCell.checkButton.addTarget(self, action: Selector("checkBulletin:"), forControlEvents: UIControlEvents.TouchUpInside)
      theCell.crossButton.addTarget(self, action: Selector("crossBulletin:"), forControlEvents: UIControlEvents.TouchUpInside)
      theCell.eyeButton.userInteractionEnabled = false
      return theCell
    } else if indexPath.section == 1 {
      cell = tableView.dequeueReusableCellWithIdentifier("stampCell") as? UITableViewCell
      if cell == nil {
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "stampCell")
      }
      let oneStamp = stamps[indexPath.row]
      if oneStamp.symbol == "check" {
        var image = UIImage(named: "check")
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell?.imageView?.image = image
        cell?.imageView?.tintColor = GREEN_COLOR
      } else if oneStamp.symbol == "cross" {
        var image = UIImage(named: "times")
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell?.imageView?.tintColor = RED_COLOR
        cell?.imageView?.image = image
      } else if oneStamp.symbol == "eye" {
        var image = UIImage(named: "eye")
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell?.imageView?.tintColor = YELLOW_COLOR
        cell?.imageView?.image = image
      }
      var stampCreatorName: String? = stamps[indexPath.row].createdBy?.name
      var stampCreatorId: String? = stamps[indexPath.row].createdBy?.id
      if stampCreatorId == nil {
        stampCreatorId = stamps[indexPath.row].createdById
      }
      if stampCreatorId == nil {
        stampCreatorName = NSLocalizedString("Unknown user", comment: "Unknown user")
      } else {
        let userDefaultsInfo = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
        let currentLoginUser = userDefaultsInfo["user"] as! [String:AnyObject]
        let currentLoginUserId = currentLoginUser["id"] as? String
        if currentLoginUserId != nil {
          if stampCreatorId == currentLoginUserId {
            stampCreatorName = NSLocalizedString("You", comment: "You")
          } else {
            if stampCreatorName == nil {
              stampCreatorName = NSLocalizedString("Unknown user", comment: "Unknown user")
            }
          }
        } else {
          if stampCreatorName == nil {
            stampCreatorName = NSLocalizedString("Unknown user", comment: "Unknown user")
          }
        }
      }
      cell?.textLabel?.text = stampCreatorName
      cell?.detailTextLabel?.font = UIFont.systemFontOfSize(13.0)
      if let stampTime = stamps[indexPath.row].createdAt {
        cell?.detailTextLabel?.text = TimeHelper.formattedTime(stampTime.doubleValue)
      }
    }
    return cell!
  }
}

extension BulletinViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    if NSString(string: UIDevice.currentDevice().systemVersion).floatValue >= 8.0 {
      cell.preservesSuperviewLayoutMargins = false
      cell.layoutMargins = UIEdgeInsetsZero
    }
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 {
      let stringText = self.bulletin.text
      self.prototypeCell.textContentLabel.preferredMaxLayoutWidth = self.view.bounds.size.width - 27
      var ownerName = self.bulletin.createdBy?.name
      if ownerName == nil {
        ownerName = NSLocalizedString("Unknown user", comment: "Unknown user")
      }
      var textContent = self.bulletin.text
      var prefixText = ownerName! + ": "
      textContent = prefixText + textContent!
      var mutableAttributedString = NSMutableAttributedString(string: textContent!)
      mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, count(prefixText)))
      mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSMakeRange(0, count(prefixText)))
      self.prototypeCell.textContentLabel.attributedText = mutableAttributedString
      self.prototypeCell.setNeedsLayout()
      self.prototypeCell.layoutIfNeeded()
      let size = self.prototypeCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize) as CGSize
      return size.height + 1.0
    } else if indexPath.section == 1 {
      return 44.0
    } else {
      return 0.0
    }
  }
}
