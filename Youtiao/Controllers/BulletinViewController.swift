import Foundation

class BulletinViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var stampsTableView: UITableView!

  var bulletin: Bulletin!

  var stamps: [Stamp] = [Stamp]()
  var lastStamp: Stamp?

  var warningAlertView: UIAlertView!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    self.stampsTableView.rowHeight = UITableViewAutomaticDimension
    self.stampsTableView.estimatedRowHeight = 160.0
    self.stampsTableView.tableFooterView = UIView()

    self.stampsTableView.ins_addInfinityScrollWithHeight(60.0,
      handler: { (scrollView: UIScrollView!) -> Void in
        self.loadMoreStamps()
    })

    let infinityIndicator = INSDefaultInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24.0, height: 24.0))
    self.stampsTableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)
    infinityIndicator.startAnimating()

    self.loadStamps()
  }

  func loadStamps() {
    APIClient.sharedInstance.fetchStampsForBulletin(bulletin,
      success: { (stamps: [Stamp]) -> Void in
        self.lastStamp = stamps.last
        self.handleLoadStampsSuccess(stamps)
        self.stampsTableView.ins_infiniteScrollBackgroundView.enabled = stamps.count >= 25
      }, failure: { (error: NSError) -> Void in
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
    self.stamps += stamps
    self.stampsTableView.reloadData()
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
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stamps.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("stampCell") as? UITableViewCell
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
    }
    cell?.textLabel?.text = stamps[indexPath.row].createdBy?.name
    cell?.detailTextLabel?.font = UIFont.systemFontOfSize(13.0)
    if let stampTime = stamps[indexPath.row].createdAt {
      cell?.detailTextLabel?.text = TimeHelper.formattedTime(stampTime.doubleValue)
    }
    return cell!
  }
}

extension BulletinViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    cell.preservesSuperviewLayoutMargins = false
    cell.layoutMargins = UIEdgeInsetsZero
  }
}
