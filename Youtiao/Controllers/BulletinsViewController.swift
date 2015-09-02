import UIKit

class BulletinsViewController: UIViewController {
  @IBOutlet weak var bulletinsTableView: UITableView!

  private var bulletins: [Bulletin] = [Bulletin]()

  var warningAlertView: UIAlertView!
  var lastVisibleBeginCellIndexPath: NSIndexPath?

  var prototypeCell: BulletinSketchCell!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    let bulletinStetchCellNib = UINib(nibName: "BulletinSketchCell", bundle: nil)
    self.bulletinsTableView.registerNib(bulletinStetchCellNib, forCellReuseIdentifier: "BulletinSketchCell")

    if NSString(string: UIDevice.currentDevice().systemVersion).floatValue >= 8.0 {
      self.bulletinsTableView.rowHeight = UITableViewAutomaticDimension
      self.bulletinsTableView.estimatedRowHeight = 60.0
    }

    self.bulletinsTableView.tableFooterView = UIView()

    self.bulletinsTableView.ins_addPullToRefreshWithHeight(60.0, handler: { (scrollView: UIScrollView!) -> Void in
        self.loadBulletins()
      }
    )

    let pullToRefresh = INSDefaultPullToRefresh(frame: CGRect(x: 0, y: 0, width: 24, height: 24), backImage: nil, frontImage: UIImage(named: "loading-2"))
    self.bulletinsTableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
    self.bulletinsTableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)

    self.bulletinsTableView.ins_addInfinityScrollWithHeight(60.0, handler: { (scrollView: UIScrollView!) -> Void in
        self.loadMoreBulletins()
      }
    )

    let infinityIndicator = INSDefaultInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    self.bulletinsTableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)
    infinityIndicator.startAnimating()

    self.checkUserInfoForUpdatingAndLoadBulletins()

    let viewArray: NSArray = NSBundle.mainBundle().loadNibNamed("BulletinSketchCell", owner: self, options: nil)
    self.prototypeCell = viewArray.objectAtIndex(0) as! BulletinSketchCell

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleStampBulletinSuccessNotification:"), name: "stampBulletinSuccessNotification", object: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: "stampBulletinSuccessNotification", object: nil)
  }

  override func viewWillAppear(animated: Bool) {
    if let selectedIndexPath = self.bulletinsTableView.indexPathForSelectedRow() {
      self.bulletinsTableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
    }

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate?
    appDelegate?.setBulletinTabItemBadge(UIApplication.sharedApplication().applicationIconBadgeNumber)
    super.viewWillAppear(animated)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let bulletinViewController = segue.destinationViewController as? BulletinViewController {
      bulletinViewController.bulletin = self.bulletins[bulletinsTableView.indexPathForSelectedRow()!.section]
    } else if let newBulletinNavigationController = segue.destinationViewController as? UINavigationController {
      if let newBulletinViewController = newBulletinNavigationController.topViewController as? NewBulletinViewController {
        newBulletinViewController.delegate = self
      }
    }
  }

  func loadBulletins() {
    APIClient.sharedInstance.fetchBulletins(
      success: { (bulletins: [Bulletin]) -> Void in
        self.bulletinsTableView.ins_endPullToRefresh()
        self.bulletins = bulletins
        self.bulletinsTableView.reloadData()
        self.bulletinsTableView.ins_infiniteScrollBackgroundView.enabled = bulletins.count >= 25

        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if appDelegate != nil {
          appDelegate!.resetBulletinTabItemBadge()
          appDelegate!.resetApplicationIconBadge()
          appDelegate!.resetBadgeValueOnServer()
        }
      }, failure: { (error: NSError) -> Void in
        self.bulletinsTableView.ins_endPullToRefresh()
        ErrorsHelper.handleCommonErrors(error)
      }
    )
  }

  func loadMoreBulletins() {
    if let lastBulletin = self.bulletins.last {
      let lastVisibleBeginCell = self.bulletinsTableView.visibleCells()[0] as? UITableViewCell
      if lastVisibleBeginCell != nil
      {
        self.lastVisibleBeginCellIndexPath = self.bulletinsTableView.indexPathForCell(lastVisibleBeginCell!)
      }
      APIClient.sharedInstance.fetchBulletinsCreatedBeforeBulletin(lastBulletin,
        success: { (bulletins: [Bulletin]) -> Void in
          let currentSectionsCount = self.bulletins.count
          self.bulletins += bulletins
          self.bulletinsTableView.beginUpdates()
          for var i = 0; i < bulletins.count; ++i {
            self.bulletinsTableView.insertSections(NSIndexSet(index: currentSectionsCount + i), withRowAnimation: UITableViewRowAnimation.Top)
          }
          self.bulletinsTableView.endUpdates()
          self.bulletinsTableView.scrollToRowAtIndexPath(self.lastVisibleBeginCellIndexPath!, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
          self.bulletinsTableView.ins_endInfinityScrollWithStoppingContentOffset(true)
          self.bulletinsTableView.ins_infiniteScrollBackgroundView.enabled = bulletins.count >= 25
          }, failure: { (error: NSError) -> Void in
            self.bulletinsTableView.ins_endInfinityScroll()
            ErrorsHelper.handleCommonErrors(error)
          }
        )
     }
  }
  
  func handleStampBulletinSuccessNotification(notification: NSNotification) {
    let userInfo = notification.userInfo as! [String: AnyObject]
    let originalBulletinObject = userInfo["originalBulletin"] as! Bulletin
    let newBulletinObject = userInfo["newBulletin"] as! Bulletin
    for var i = 0; i < self.bulletins.count; i++ {
      let bulletinItem = self.bulletins[i]
      if bulletinItem.id == originalBulletinObject.id {
        self.bulletins[i] = newBulletinObject
        break
      }
    }
    self.bulletinsTableView.reloadData()
  }

  func displayErrorMessageWithTitle(title: String, message: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }

  // MARK: - Private Methods
  private func updateCellViaCheckButtonTapped(indexpath: NSIndexPath) {
    let cell = tableView(self.bulletinsTableView, cellForRowAtIndexPath: indexpath) as! BulletinCell
    cell.tappedCheckButton()
  }

  private func updateCellViaCrossButtonTapped(indexpath: NSIndexPath) {
    let cell = tableView(self.bulletinsTableView, cellForRowAtIndexPath: indexpath) as! BulletinCell
    cell.tappedCrossButton()
  }

}

// MARK: - UITableViewDataSource
extension BulletinsViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.bulletins.count
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BulletinSketchCell") as! BulletinSketchCell
    let bulletin = self.bulletins[indexPath.section]

    cell.groupNameLabel.text = bulletin.group?.name
    let postTime = bulletin.createdAt?.doubleValue
    let postTimeString = TimeHelper.formattedTime(postTime!)
    var ownerName = bulletin.createdBy?.name
    if ownerName == nil {
      ownerName = NSLocalizedString("Unknown user", comment:"Unknown user")
    }
    cell.timeLabel.text = postTimeString
    var textContent = bulletin.text
    var prefixText = ownerName! + ": "
    textContent = prefixText + textContent!
    var mutableAttributedString = NSMutableAttributedString(string: textContent!)
    mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: prefixText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
    mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSRange(location: 0, length: prefixText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
    cell.textContentSketchLabel.attributedText = mutableAttributedString

    if bulletin.currentStamp != nil {
      cell.readFlagImageView.image = nil
    } else {
      var image = UIImage(named: "circle")
      image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
      cell.readFlagImageView.tintColor = BRAND_COLOR
      cell.readFlagImageView.image = image
    }
    return cell
  }
}

// MARK: - UITableViewDelegate
extension BulletinsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier("BulletinSelectionSegue", sender: self)
  }

  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.separatorInset = UIEdgeInsetsZero
    if NSString(string: UIDevice.currentDevice().systemVersion).floatValue >= 8.0 {
      cell.preservesSuperviewLayoutMargins = false
      cell.layoutMargins = UIEdgeInsetsZero
    }
  }

  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0
    } else {
      return 0.0
    }
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let stringText = self.bulletins[indexPath.section].text
    self.prototypeCell.textContentSketchLabel.preferredMaxLayoutWidth = self.view.bounds.size.width - 29
    let bulletin = self.bulletins[indexPath.section] as Bulletin
    var ownerName = bulletin.createdBy?.name
    if ownerName == nil {
      ownerName = NSLocalizedString("Unknown user", comment: "Unknown user")
    }
    var textContent = bulletin.text
    var prefixText = ownerName! + ":"
    textContent = prefixText + textContent!
    var mutableAttributedString = NSMutableAttributedString(string: textContent!)
    mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: prefixText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
    mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSRange(location:0, length: prefixText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
    self.prototypeCell.textContentSketchLabel.attributedText = mutableAttributedString
    self.prototypeCell.setNeedsLayout()
    self.prototypeCell.layoutIfNeeded()
    let size = self.prototypeCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize) as CGSize
    return size.height + 1.0
  }

  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60.0
  }

  func scrollViewDidScroll(scrollView: UIScrollView) {
    if scrollView == self.bulletinsTableView {
      let sectionHeaderheight: CGFloat = 0.0
      if (scrollView.contentOffset.y <= sectionHeaderheight) && (scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
      } else if scrollView.contentOffset.y >= sectionHeaderheight {
        scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderheight, left: 0, bottom: 0, right: 0)
      }
    }
  }
}

// MARK: - NewBulletinViewControllerDelegate
extension BulletinsViewController: NewBulletinViewControllerDelegate {
  func newBulletinViewController(controller: NewBulletinViewController, didCreateBulletin bulletin: Bulletin) {
    self.dismissViewControllerAnimated(true, completion: nil)
    bulletins.insert(bulletin, atIndex: 0)
    bulletinsTableView.beginUpdates()
    bulletinsTableView.insertSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Middle)
    bulletinsTableView.endUpdates()
    bulletinsTableView.reloadRowsAtIndexPaths(bulletinsTableView.indexPathsForVisibleRows()!, withRowAnimation: UITableViewRowAnimation.None)
    self.bulletinsTableView.ins_beginPullToRefresh()
  }

  func newBulletinViewControllerDidCancel(controller: NewBulletinViewController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

extension BulletinsViewController {
  func checkUserInfoForUpdatingAndLoadBulletins() {
    let userInfoDict = NSUserDefaults.standardUserDefaults().valueForKey("user") as? [String: AnyObject]
    if userInfoDict == nil {
      self.loadAndUpdateUserInfo()
    } else {
      self.bulletinsTableView.ins_beginPullToRefresh()
    }
  }
  func loadAndUpdateUserInfo() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.fetchCurrentUser(success: { (user: User) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let userInfoDict = MTLJSONAdapter.JSONDictionaryFromModel(user, error: nil)
        if userInfoDict != nil {
          NSUserDefaults.standardUserDefaults().setObject(userInfoDict, forKey: "user")
          NSUserDefaults.standardUserDefaults().synchronize()
        }
        self.bulletinsTableView.ins_beginPullToRefresh()
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if error is ForbiddenError || error is NotFoundError || error is UnprocessableEntityError {
          var errMsg = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessageWithTitle(NSLocalizedString("Warning", comment: "Warning"), message: errMsg)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }
}
