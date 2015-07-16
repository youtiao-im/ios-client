import UIKit

protocol GroupsViewControllerDelegate {
  func didSelectGroup(group: Group)
}

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, NewGroupViewControllerDelegate, JoinGroupViewControllerDelegate {
  @IBOutlet weak var groupsTableView: UITableView!

  var delegate: GroupsViewControllerDelegate?

  private var groups: [Group] = [Group]()

  var warningAlertView: UIAlertView!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    if self.navigationController?.presentingViewController != nil {
      self.navigationItem.rightBarButtonItem = nil
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Cancel"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelItemTapped:"))
    }

    self.groupsTableView.tableFooterView = UIView()

    self.groupsTableView.ins_addPullToRefreshWithHeight(60.0,
      handler: { (scrollView: UIScrollView!) -> Void in
        self.loadGroups()
      }
    )

    let pullToRefresh = INSDefaultPullToRefresh(frame: CGRectMake(0, 0, 24, 24), backImage: nil, frontImage: UIImage(named: "loading-2"))
    self.groupsTableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
    self.groupsTableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)

    self.groupsTableView.ins_beginPullToRefresh()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleUpdateGroupInfoSuccessNotification:"), name: "updateGroupInfoSuccessNotification", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleCreateGroupSuccessNotification:"), name: "createGroupSuccessNotification", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleJoinGroupSuccessNotification:"), name: "joinGroupSuccessNotification", object: nil)
  }

  override func viewWillAppear(animated: Bool) {
    if let selectedIndexPath = self.groupsTableView.indexPathForSelectedRow() {
      self.groupsTableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
    }

    super.viewWillAppear(animated)
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateGroupInfoSuccessNotification", object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: "createGroupSuccessNotification", object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: "joinGroupSuccessNotification", object: nil)
  }

  func cancelItemTapped(sender: AnyObject?) {
    if sender?.title == NSLocalizedString("Cancel", comment: "Cancel") {
      self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
  }

  func handleUpdateGroupInfoSuccessNotification(notification: NSNotification) {
    let userInfoDict = notification.userInfo as! [String : AnyObject]
    let newGroupInfo = userInfoDict["newGroupInfo"]as! Group
    for var i = 0; i < groups.count; ++i {
      let oneGroupInfo = groups[i]
      let groupIdFromOriInfo = oneGroupInfo.id
      let groupIdFromNewInfo = newGroupInfo.id
      if groupIdFromOriInfo == groupIdFromNewInfo {
        groups[i] = newGroupInfo
        self.groupsTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        break
      }
    }
  }

  func handleCreateGroupSuccessNotification(notification: NSNotification) {
    let userInfo = notification.userInfo as! [String : AnyObject]
    let newGroup = userInfo["newGroupInfo"] as! Group
    self.groups.append(newGroup)
    self.groupsTableView.beginUpdates()
    self.groupsTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.groups.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
    self.groupsTableView.endUpdates()
  }

  func handleJoinGroupSuccessNotification(notification: NSNotification) {
    let userInfo = notification.userInfo as! [String : AnyObject]
    let newGroup = userInfo["groupInfo"] as! Group
    self.groups.append(newGroup)
    self.groupsTableView.beginUpdates()
    self.groupsTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.groups.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
    self.groupsTableView.endUpdates()
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.groups.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell") as! UITableViewCell
    cell.textLabel?.text = self.groups[indexPath.row].name
    if self.navigationController?.presentingViewController != nil {
      let oneGroup = groups[indexPath.row]
      if (oneGroup.currentMembership?.role != "admin") && (oneGroup.currentMembership?.role != "owner") {
        cell.userInteractionEnabled = false
        cell.textLabel?.textColor = UIColor.grayColor()
      }
    } else {
      cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if self.navigationController?.presentingViewController != nil {
      self.delegate?.didSelectGroup(groups[indexPath.row])
      self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
  }

  @IBAction func addGroup(sender: AnyObject) {
    var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("Cancel", comment: "Cancel"), destructiveButtonTitle: nil, otherButtonTitles: NSLocalizedString("Create a Group", comment: "Create a Group"), NSLocalizedString("Join a Group", comment: "Join a Group"))
    actionSheet.showInView(self.view)
  }

  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    switch buttonIndex {
    case 1:
      self.performSegueWithIdentifier("NewGroupSegue", sender: self)
    case 2:
      self.performSegueWithIdentifier("JoinGroupSegue", sender: self)
    default:
      break
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let groupSettingsViewController = segue.destinationViewController as? GroupSettingsViewController {
      groupSettingsViewController.group = self.groups[groupsTableView.indexPathForSelectedRow()!.row]
    } else if let segueNavigationController = segue.destinationViewController as? UINavigationController {
      if let newGroupViewController = segueNavigationController.viewControllers[0] as? NewGroupViewController {
        newGroupViewController.delegate = self
      } else if let joinGroupViewController = segueNavigationController.viewControllers[0] as? JoinGroupViewController {
        joinGroupViewController.delegate = self
      }
    }
  }

  func newGroupViewController(controller: NewGroupViewController, didCreateGroup group: Group) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func newGroupViewControllerDidCancel(controller: NewGroupViewController) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func joinGroupViewController(controller: JoinGroupViewController, didJoinGroup group: Group) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func joinGroupViewControllerDidCancel(controller: JoinGroupViewController) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func loadGroups() {
    APIClient.sharedInstance.fetchGroups(
      success: { (groups: [Group]) -> Void in
        self.groups = groups
        self.groupsTableView.reloadData()
        self.groupsTableView.ins_endPullToRefresh()
      }, failure: { (error: NSError) -> Void in
        self.groupsTableView.ins_endPullToRefresh()
        if error is ForbiddenError || error is NotFoundError {
          var errorMsg = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errorMsg)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func displayErrorMessage(title: String, errorMsg: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }
}
