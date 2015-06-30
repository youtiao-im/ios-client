//
//  GroupsViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/17/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, NewGroupViewControllerDelegate, JoinGroupViewControllerDelegate {

  @IBOutlet weak var groupsTableView: UITableView!

  private var groups: [Group] = [Group]()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    self.groupsTableView.tableFooterView = UIView()

    self.groupsTableView.ins_addPullToRefreshWithHeight(60.0,
      handler: { (scrollView: UIScrollView!) -> Void in
        self.loadGroups()
      }
    )

    let pullToRefresh = INSDefaultPullToRefresh(frame: CGRectMake(0, 0, 24, 24), backImage: UIImage(named: "first"), frontImage: UIImage(named: "second"))
    self.groupsTableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
    self.groupsTableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)

    self.groupsTableView.ins_beginPullToRefresh()
  }

  override func viewWillAppear(animated: Bool) {
    if let selectedIndexPath = self.groupsTableView.indexPathForSelectedRow() {
      self.groupsTableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
    }

    super.viewWillAppear(animated)
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.groups.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell") as! UITableViewCell
    cell.textLabel?.text = self.groups[indexPath.row].name
    return cell
  }

  @IBAction func addGroup(sender: AnyObject) {
    var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Create a Group", "Join a Group")
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
    if let groupViewContoller = segue.destinationViewController as? GroupBulletinsViewController {
      groupViewContoller.group = self.groups[groupsTableView.indexPathForSelectedRow()!.row]
    } else if let segueNagvigationController = segue.destinationViewController as? UINavigationController {
      if let newGroupViewController = segueNagvigationController.viewControllers[0] as? NewGroupViewController {
        newGroupViewController.delegate = self
      } else if let joinGroupViewController = segueNagvigationController.viewControllers[0] as? JoinGroupViewController {
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
        ErrorsHelper.handleCommonErrors(error)
      }
    )
  }
}
