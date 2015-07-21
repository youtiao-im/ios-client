import Foundation

class GroupSettingsViewController: UITableViewController, EditGroupNameViewControllerDelegate, EditGroupCodeViewControllerDelegate {
  @IBOutlet weak var groupNameLabel: UILabel!
  @IBOutlet weak var groupCodeLabel: UILabel!
  @IBOutlet weak var groupMembershipsCountLabel: UILabel!

  var group: Group!

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
