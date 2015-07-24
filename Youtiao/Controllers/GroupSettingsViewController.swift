import Foundation

class GroupSettingsViewController: UITableViewController, EditGroupNameViewControllerDelegate, EditGroupCodeViewControllerDelegate {
  @IBOutlet weak var groupNameLabel: UILabel!
  @IBOutlet weak var groupCodeLabel: UILabel!
  @IBOutlet weak var groupMembershipsCountLabel: UILabel!
  @IBOutlet weak var leaveGroupButton: UIButton!

  var group: Group!
  var warningAlertView: UIAlertView!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    self.groupNameLabel.text = self.group.name
    self.groupCodeLabel.text = self.group.code
    self.groupMembershipsCountLabel.text = self.group.membershipsCount?.stringValue

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleUpdateGroupInfoSuccessNotification:"), name: "updateGroupInfoSuccessNotification", object: nil)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if self.group.currentMembership?.role != "admin" && self.group.currentMembership?.role != "owner" {
      var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
      cell?.userInteractionEnabled = false
      cell?.accessoryType = UITableViewCellAccessoryType.None
      cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
      cell?.userInteractionEnabled = false
      cell?.accessoryType = UITableViewCellAccessoryType.None
    }

    if self.group.currentMembership?.role == "owner" {
      let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))
      self.leaveGroupButton.enabled = false
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let segueNagvigationController = segue.destinationViewController as? UINavigationController {
      if let editGroupNameViewController = segueNagvigationController.viewControllers[0] as? EditGroupNameViewController {
        editGroupNameViewController.group = self.group
        editGroupNameViewController.delegate = self
      } else if let editGroupCodeViewController = segueNagvigationController.viewControllers[0] as? EditGroupCodeViewController {
        editGroupCodeViewController.group = self.group
        editGroupCodeViewController.delegate = self
      }
    } else if let groupMembersViewController = segue.destinationViewController as? GroupMembersViewController {
      groupMembersViewController.group = self.group
    }
  }

  func handleUpdateGroupInfoSuccessNotification(notification: NSNotification) {
    let userInfo = notification.userInfo as! [String : AnyObject]
    let newGroup = userInfo["newGroupInfo"] as! Group
    let groupIdFromOriInfo = group.id
    let groupIdFromNewInfo = newGroup.id
    if groupIdFromOriInfo == groupIdFromNewInfo {
      group = newGroup
      self.groupNameLabel.text = newGroup.name
      self.groupCodeLabel.text = newGroup.code
      self.groupMembershipsCountLabel.text = newGroup.membershipsCount?.stringValue
    }
  }

  @IBAction func quitGroup() {
    let actionSheet:UIActionSheet = UIActionSheet(title: NSLocalizedString("Are you sure to quit and leave this group", comment: "Are you sure you want to quit and leave this group?"), delegate: self, cancelButtonTitle: NSLocalizedString("Cancel", comment: "Cancel"), destructiveButtonTitle: NSLocalizedString("Sure", comment: "Sure"))
    actionSheet.showInView(self.view)
  }

  func doLeaveGroupAction() {
//    if self.group.currentMembership?.role == "owner" {
//      let errMsg = NSLocalizedString("Administrator can not quit group", comment: "Administrator can not quit group")
//      self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
//      return
//    }
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.leaveGroup(self.group, success: { (dictionary) -> Void in
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      let groupInfoDict = ["group": self.group]
      NSNotificationCenter.defaultCenter().postNotificationName("leaveGroupSuccessNotification", object: nil, userInfo: groupInfoDict)
      self.navigationController?.popViewControllerAnimated(true)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if error is ForbiddenError {
          let errMsg = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateGroupInfoSuccessNotification", object: nil)
  }

  func editGroupNameViewController(controller: EditGroupNameViewController, didUpdateGroup group: Group) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func editGroupNameViewControllerDidCancel(controller: EditGroupNameViewController) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func editGroupCodeViewController(controller: EditGroupCodeViewController, didUpdateGroup group: Group) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func editGroupCodeViewControllerDidCancel(controller: EditGroupCodeViewController) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func displayErrorMessage(title: String, errorMsg: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }
}

extension GroupSettingsViewController: UITableViewDelegate {
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 20.0
    } else {
      return 10.0
    }
  }
}

extension GroupSettingsViewController: UIActionSheetDelegate {
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == actionSheet.destructiveButtonIndex {
      self.doLeaveGroupAction()
    }
  }
}
