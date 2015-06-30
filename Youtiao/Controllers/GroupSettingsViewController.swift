//
//  GroupSettingsViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/24/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

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
    }
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
