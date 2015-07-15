import UIKit

class GroupMembersViewController: UIViewController {
  @IBOutlet weak var membersTableView: UITableView!

  var group: Group!
  private var admins: [Membership] = [Membership]()
  private var members: [Membership] = [Membership]()

  var warningAlertView: UIAlertView!

  override func viewDidLoad() {
    super.viewDidLoad()

    membersTableView.tableFooterView = UIView()
    membersTableView.rowHeight = 54.0
    self.loadAllMemberships()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func loadAllMemberships() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.fetchGroupAllMemberships(group, success: { (memberships: [Membership]) -> Void in
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
    for oneMembership in memberships {
      let role = oneMembership.role
      if role == "admin" || role == "owner" {
        let currentAdminCount = admins.count
        admins.append(oneMembership)
      } else if role == "member" {
        let currentMembersCount = members.count
        members.append(oneMembership)
      }
    }
    if admins.count > 0 && members.count > 0 {
      self.membersTableView.beginUpdates()
      self.membersTableView.insertSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Top)
      self.membersTableView.insertSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Top)
      self.membersTableView.endUpdates()
    } else if admins.count > 0 && members.count <= 0 {
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
    if admins.count > 0 && members.count > 0 {
      return 2
    } else if admins.count > 0 && members.count <= 0 {
      return 1
    }
    return 0
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return admins.count
    case 1:
      return members.count
    default:
      return 0
    }
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("groupMemberCell") as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "groupMemberCell")
    }
    var oneMembership: Membership?
    if indexPath.section == 0 {
      oneMembership = admins[indexPath.row]
    } else if indexPath.section == 1 {
      oneMembership = members[indexPath.row]
    }
    cell!.textLabel?.text = oneMembership?.user?.name
    return cell!
  }

  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return NSLocalizedString("Administrators", comment: "Administrators")
    case 1:
      return NSLocalizedString("Members", comment: "Members")
    default:
      return nil
    }
  }
}

// MARK: UITableViewDelegate
extension GroupMembersViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
