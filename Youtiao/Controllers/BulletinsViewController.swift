import UIKit

class BulletinsViewController: UIViewController {
  @IBOutlet weak var bulletinsTableView: UITableView!

  private var bulletins: [Bulletin] = [Bulletin]()
  private var timer: NSTimer?

  var warningAlertView: UIAlertView!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    let bulletinCellNib = UINib(nibName: "BulletinCell", bundle: nil)
    self.bulletinsTableView.registerNib(bulletinCellNib, forCellReuseIdentifier: "BulletinCell")
    self.bulletinsTableView.rowHeight = UITableViewAutomaticDimension
    self.bulletinsTableView.estimatedRowHeight = 160.0

    self.bulletinsTableView.tableFooterView = UIView()

    self.bulletinsTableView.ins_addPullToRefreshWithHeight(60.0, handler: { (scrollView: UIScrollView!) -> Void in
        self.loadBulletins()
      }
    )

    let pullToRefresh = INSDefaultPullToRefresh(frame: CGRect(x: 0, y: 0, width: 24, height: 24), backImage: UIImage(named: "synchronize-4"), frontImage: UIImage(named: "synchronize-4"))
    self.bulletinsTableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
    self.bulletinsTableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)

    self.bulletinsTableView.ins_addInfinityScrollWithHeight(60.0, handler: { (scrollView: UIScrollView!) -> Void in
        self.loadMoreBulletins()
      }
    )

    let infinityIndicator = INSDefaultInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    self.bulletinsTableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)
    infinityIndicator.startAnimating()

    self.bulletinsTableView.ins_infiniteScrollBackgroundView.enabled = false

    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimeDisplay:"), userInfo: nil, repeats: true)

    var delayTime: dispatch_time_t
    delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(100 * NSEC_PER_MSEC))
    dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
      self.bulletinsTableView.ins_beginPullToRefresh()
    }
  }

  deinit {
    self.timer?.invalidate()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewWillAppear(animated: Bool) {
    if let selectedIndexPath = self.bulletinsTableView.indexPathForSelectedRow() {
      self.bulletinsTableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
    }

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
    self.bulletins.removeAll(keepCapacity: true)
    self.bulletinsTableView.reloadData()
    APIClient.sharedInstance.fetchBulletins(
      success: { (bulletins: [Bulletin]) -> Void in
        let currentSectionsCount = self.bulletins.count
        self.bulletins = bulletins
        self.bulletinsTableView.ins_endPullToRefresh()
        self.bulletinsTableView.beginUpdates()
        for var i = 0; i < bulletins.count; ++i {
          self.bulletinsTableView.insertSections(NSIndexSet(index: currentSectionsCount + i), withRowAnimation: UITableViewRowAnimation.Top)
        }
        self.bulletinsTableView.endUpdates()
        self.bulletinsTableView.ins_infiniteScrollBackgroundView.enabled = bulletins.count >= 25
      }, failure: { (error: NSError) -> Void in
        self.bulletinsTableView.ins_endPullToRefresh()
        ErrorsHelper.handleCommonErrors(error)
      }
    )
  }

  func loadMoreBulletins() {
    if let lastBulletin = self.bulletins.last {
      APIClient.sharedInstance.fetchBulletinsCreatedBeforeBulletin(lastBulletin,
        success: { (bulletins: [Bulletin]) -> Void in
          let currentSectionsCount = self.bulletins.count
          self.bulletins += bulletins
          self.bulletinsTableView.beginUpdates()
          for var i = 0; i < bulletins.count; ++i {
            self.bulletinsTableView.insertSections(NSIndexSet(index: currentSectionsCount + i), withRowAnimation: UITableViewRowAnimation.Top)
          }
          self.bulletinsTableView.endUpdates()
          self.bulletinsTableView.ins_endInfinityScrollWithStoppingContentOffset(true)
          self.bulletinsTableView.ins_infiniteScrollBackgroundView.enabled = bulletins.count >= 25
          }, failure: { (error: NSError) -> Void in
            self.bulletinsTableView.ins_endInfinityScroll()
            ErrorsHelper.handleCommonErrors(error)
          }
        )
    }
  }

  func checkBulletin(sender: UIButton!) {
    let bulletin = self.bulletins[sender.tag]
    APIClient.sharedInstance.stampBulletin(bulletin, withSymbol: "check",
      success: { (bulletin: Bulletin) -> Void in
        let row = sender.tag
        self.bulletins[row] = bulletin
        self.bulletinsTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: row)], withRowAnimation: UITableViewRowAnimation.Automatic)
      }, failure: { (error: NSError) -> Void in
        var errorMessage: String
        if error is ForbiddenError || error is NotFoundError {
          errorMessage = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessageWithTitle(NSLocalizedString("Warning", comment: "Warning"), message: errorMessage)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func crossBulletin(sender: UIButton) {
    let bulletin = self.bulletins[sender.tag]
    APIClient.sharedInstance.stampBulletin(bulletin, withSymbol: "cross",
      success: { (bulletin: Bulletin) -> Void in
        let row = sender.tag
        self.bulletins[row] = bulletin
        self.bulletinsTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: row)], withRowAnimation: UITableViewRowAnimation.Automatic)
      }, failure: { (error: NSError) -> Void in
        var errorMessage: String
        if error is ForbiddenError || error is NotFoundError {
          errorMessage = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessageWithTitle(NSLocalizedString("Warning", comment: "Warning"), message: errorMessage)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
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

  func updateTimeDisplay(timer: NSTimer) {
    for item in self.bulletinsTableView.visibleCells() {
      let oneCell = item as! BulletinCell
      let indexPath = self.bulletinsTableView.indexPathForCell(oneCell)
      let bulletin = self.bulletins[indexPath!.section]
      let postTime = bulletin.createdAt?.doubleValue
      let postTimeString = TimeHelper.formattedTime(postTime!)
      oneCell.timeLabel.text = postTimeString
    }
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
    let cell = tableView.dequeueReusableCellWithIdentifier("BulletinCell") as! BulletinCell
    let bulletin = self.bulletins[indexPath.section]

    cell.groupNameLabel.text = bulletin.group?.name
    cell.checksCountLabel.text = bulletin.checksCount?.stringValue
    cell.crossesCountLabel.text = bulletin.crossesCount?.stringValue
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
    cell.textContentLabel.attributedText = mutableAttributedString

    if bulletin.currentStamp != nil {
      switch bulletin.currentStamp!.symbol! {
        case "check":
          cell.checked = true
          cell.crossed = false
        case "cross":
          cell.checked = false
          cell.crossed = true
      default:
        break
      }
    } else {
      cell.checked = false
      cell.crossed = false
    }
    cell.checkButton.tag = indexPath.section
    cell.checkButton.addTarget(self, action: Selector("checkBulletin:"), forControlEvents: UIControlEvents.TouchUpInside)
    cell.crossButton.tag = indexPath.section
    cell.crossButton.addTarget(self, action: Selector("crossBulletin:"), forControlEvents: UIControlEvents.TouchUpInside)
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
    cell.preservesSuperviewLayoutMargins = false
    cell.layoutMargins = UIEdgeInsetsZero
  }

  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0
    } else {
      return 0.0
    }
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
  }

  func newBulletinViewControllerDidCancel(controller: NewBulletinViewController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
