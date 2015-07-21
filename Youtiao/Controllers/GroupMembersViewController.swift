import UIKit

class GroupMembersViewController: UIViewController {
  @IBOutlet weak var membersTableView: UITableView!

  var group: Group!
  private var memberships: [Membership] = [Membership]()

  var warningAlertView: UIAlertView!

  override func viewDidLoad() {
    super.viewDidLoad()

    membersTableView.tableFooterView = UIView()
    self.loadAllMemberships()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func loadAllMemberships() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.fetchGroupAllMemberships(group,
      success: { (memberships: [Membership]) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.handleFetchAllMembershipsSuccess(memberships)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if error is ForbiddenError || error is NotFoundError {
          let errMsg = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func handleFetchAllMembershipsSuccess(memberships: [Membership]) {
    self.memberships = memberships
    if self.memberships.count > 0 {
      self.membersTableView.beginUpdates()
      self.membersTableView.insertSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Top)
      self.membersTableView.endUpdates()
    }
  }

  func displayErrorMessage(title: String, errorMsg: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }
}

// MARK: - UITableViewDataSource
extension GroupMembersViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if self.memberships.count > 0 {
      return 1
    }
    return 0
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.memberships.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("groupMemberCell") as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "groupMemberCell")
    }
    var oneMembership: Membership?
    oneMembership = self.memberships[indexPath.row]
    var role: String?
    cell!.textLabel?.text = oneMembership?.user?.name
    role = oneMembership?.role
    if role == "owner" {
      cell!.detailTextLabel?.text = NSLocalizedString("owner", comment: "owner")
    } else if role == "admin" {
      cell!.detailTextLabel?.text = NSLocalizedString("admin", comment: "admin")
    } else {
      cell!.detailTextLabel?.text = NSLocalizedString("member", comment: "member")
    }
    cell!.detailTextLabel?.font = UIFont.systemFontOfSize(15.0)
    cell?.userInteractionEnabled = false
    return cell!
  }
}

// MARK: UITableViewDelegate
extension GroupMembersViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0.0
    }
    return 20.0
  }
}
