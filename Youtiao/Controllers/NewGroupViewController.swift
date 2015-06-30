//
//  NewGroupViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/23/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

protocol NewGroupViewControllerDelegate {
  func newGroupViewController(controller: NewGroupViewController, didCreateGroup group: Group)
  func newGroupViewControllerDidCancel(controller: NewGroupViewController)
}

class NewGroupViewController: UITableViewController {

  @IBOutlet weak var nameTextField: UITextField!

  var delegate: NewGroupViewControllerDelegate?

  @IBAction func create(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.createGroupWithName(self.nameTextField.text, code: nil,
      success: { (group: Group) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.delegate?.newGroupViewController(self, didCreateGroup: group)
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

          var alertView = UIAlertView(title: "Failed to Createe Group", message: errorMessage, delegate: self, cancelButtonTitle: "OK")
          alertView.show()
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  @IBAction func cancel(sender: AnyObject) {
    self.delegate?.newGroupViewControllerDidCancel(self)
  }
}
