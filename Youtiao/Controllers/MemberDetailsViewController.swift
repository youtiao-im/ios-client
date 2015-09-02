import UIKit

class MemberDetailsViewController: UITableViewController {

  var membership: Membership?
  var groupOwner: User?

  var warningAlertView: UIAlertView?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func getCurrentUserId() -> String? {
    let currentUserDefaults = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
    let currentUserInfo = currentUserDefaults["user"] as? [String: AnyObject]
    let currentUserId = currentUserInfo?["id"] as! String?
    return currentUserId
  }

  func promoteAsAdmin() {
    if self.membership == nil {
      return
    }
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
    cell?.userInteractionEnabled = false
    cell?.textLabel?.textColor = UIColor.grayColor()
    APIClient.sharedInstance.promoteMembership(self.membership!, success: { (newMembership: Membership) -> Void in
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      let userInfoDict = ["originalMembership": self.membership!, "newMembership": newMembership]
      NSNotificationCenter.defaultCenter().postNotificationName("promoteMembershipSuccessNotification", object: nil, userInfo: userInfoDict)
      self.membership = newMembership
      let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
      cell?.textLabel?.text = NSLocalizedString("Demote as Member", comment: "Demote as Member")
      cell?.userInteractionEnabled = true
      cell?.textLabel?.textColor = UIColor.blackColor()
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        cell?.userInteractionEnabled = true
        cell?.textLabel?.textColor = UIColor.blackColor()
        if error is ForbiddenError || error is NotFoundError || error is UnprocessableEntityError {
          let errMsg = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func demoteAsMember() {
    if self.membership == nil {
      return
    }
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
    cell?.userInteractionEnabled = false
    cell?.textLabel?.textColor = UIColor.grayColor()
    APIClient.sharedInstance.demoteMembership(self.membership!, success: { (newMembership: Membership) -> Void in
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      let userInfoDict = ["originalMembership": self.membership!, "newMembership": newMembership]
      NSNotificationCenter.defaultCenter().postNotificationName("demoteMembershipSuccessNotification", object: nil, userInfo: userInfoDict)
      self.membership = newMembership
      let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
      cell?.textLabel?.text = NSLocalizedString("Promote as Admin", comment: "Promote as Admin")
      cell?.userInteractionEnabled = true
      cell?.textLabel?.textColor = UIColor.blackColor()
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        cell?.userInteractionEnabled = true
        cell?.textLabel?.textColor = UIColor.blackColor()
        if error is ForbiddenError || error is NotFoundError || error is UnprocessableEntityError {
          let errMsg = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func displayErrorMessage(title: String, errorMsg: String) {
    if  (warningAlertView?.visible != nil) {
      warningAlertView?.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView?.show()
  }

}

extension MemberDetailsViewController: UITableViewDataSource {
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    let currentUserId: String? = self.getCurrentUserId()
    if self.membership != nil {
      let role = self.membership?.role
      let groupOwnerId = self.groupOwner?.id
      let userIdFromMembership = self.membership?.userId
      if role != nil && currentUserId != nil && userIdFromMembership != nil {
        if currentUserId == groupOwnerId && currentUserId == userIdFromMembership {
          // self is group owner and view self info
          return 1
        } else if currentUserId == groupOwnerId && currentUserId != userIdFromMembership {
          // self is group owner and view other person's info
          return 2
        } else if currentUserId != groupOwnerId {
          // self is not group owner
          return 1
        }
      }
      return 0
    }
    return 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 2
    } else if section == 1 {
      return 1
    }
    return 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell? = nil
    if indexPath.section == 0 {
      cell = tableView.dequeueReusableCellWithIdentifier("memberInfoCell") as? UITableViewCell
      if cell == nil {
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "memberInfoCell")
      }
      if indexPath.row == 0 {
        var username = self.membership?.user?.name
        if username == nil {
          username = NSLocalizedString("Unknown user",comment:"Unknown user")
        }
        cell?.textLabel?.text = NSLocalizedString("Name", comment: "Name")
        cell?.detailTextLabel?.text = username
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
      } else if indexPath.row == 1 {
        var email = self.membership?.user?.email
        if email == nil {
          email = NSLocalizedString("Unknown", comment: "Unknown")
        }
        cell?.textLabel?.text = NSLocalizedString("Email", comment: "Email")
        cell?.detailTextLabel?.text = email
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
      }
    } else if indexPath.section == 1 {
      cell = tableView.dequeueReusableCellWithIdentifier("membershipManagementCell") as? UITableViewCell
      if cell == nil {
        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "membershipManagementCell")
        let role = self.membership?.role
        if role == "member" {
          cell?.textLabel?.text = NSLocalizedString("Promote as Admin", comment: "Promote as Admin")
        } else if role == "admin" {
          cell?.textLabel?.text = NSLocalizedString("Demote as Member", comment: "Demote as Member")
        }

        cell?.textLabel?.textAlignment = NSTextAlignment.Center
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
      }
    }
    return cell!
  }
}

extension MemberDetailsViewController: UITableViewDelegate {
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 20.0
    } else {
      return 10.0
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if indexPath.section == 1 {
      let role = self.membership?.role
      if role == "member" {
        self.promoteAsAdmin()
      } else if role == "admin" {
        self.demoteAsMember()
      } else {
      }
    }
  }
}
