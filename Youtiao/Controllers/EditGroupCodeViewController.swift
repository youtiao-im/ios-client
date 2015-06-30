//
//  EditGroupCodeViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/25/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

protocol EditGroupCodeViewControllerDelegate {
  func editGroupCodeViewController(controller: EditGroupCodeViewController, didUpdateGroup group: Group)
  func editGroupCodeViewControllerDidCancel(controller: EditGroupCodeViewController)
}

class EditGroupCodeViewController: UITableViewController {

  @IBOutlet weak var groupCodeTextField: UITextField!

  var group: Group!
  var delegate: EditGroupCodeViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.groupCodeTextField.text = self.group.code
  }

  @IBAction func save(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.updateGroup(self.group, name: nil, code: self.groupCodeTextField.text,
      success: { (group: Group) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.delegate?.editGroupCodeViewController(self, didUpdateGroup: group)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let unprocessableEntityError = error as? UnprocessableEntityError {
          var errorMessage: String?
          switch unprocessableEntityError.reason! {
          case UnprocessableEntityErrorReason.Blank:
            errorMessage = "Group code cannot be blank."
          case UnprocessableEntityErrorReason.TooShort:
            errorMessage = "Group code is too short."
          case UnprocessableEntityErrorReason.TooLong:
            errorMessage = "Group code is too long."
          case UnprocessableEntityErrorReason.Taken:
            errorMessage = "Group code has already been taken."
          default:
            errorMessage = "Group code is invalid."
          }

          var alertView = UIAlertView(title: "Failed to Update Group Code", message: errorMessage, delegate: self, cancelButtonTitle: "OK")
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
    self.delegate?.editGroupCodeViewControllerDidCancel(self)
  }
}
