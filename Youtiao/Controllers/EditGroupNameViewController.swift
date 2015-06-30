//
//  EditGroupNameViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/25/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

protocol EditGroupNameViewControllerDelegate {
  func editGroupNameViewController(controller: EditGroupNameViewController, didUpdateGroup group: Group)
  func editGroupNameViewControllerDidCancel(controller: EditGroupNameViewController)
}

class EditGroupNameViewController: UITableViewController {

  @IBOutlet weak var groupNameTextField: UITextField!

  var group: Group!
  var delegate: EditGroupNameViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.groupNameTextField.text = self.group.name
  }

  @IBAction func save(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.updateGroup(self.group, name: self.groupNameTextField.text, code: nil,
      success: { (group: Group) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.delegate?.editGroupNameViewController(self, didUpdateGroup: group)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let unprocessableEntityError = error as? UnprocessableEntityError {
          var errorMessage: String?
          switch unprocessableEntityError.reason! {
          case UnprocessableEntityErrorReason.Blank:
            errorMessage = "Group name cannot be blank."
          case UnprocessableEntityErrorReason.TooShort:
            errorMessage = "Group name is too short."
          case UnprocessableEntityErrorReason.TooLong:
            errorMessage = "Group name is too long."
          default:
            errorMessage = "Group name is invalid."
          }

          var alertView = UIAlertView(title: "Failed to Update Group Name", message: errorMessage, delegate: self, cancelButtonTitle: "OK")
          alertView.show()
        } else if error is ForbiddenError {
          // TODO:
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  @IBAction func cancel(sender: AnyObject) {
    self.delegate?.editGroupNameViewControllerDidCancel(self)
  }
}
