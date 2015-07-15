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
  
  var warningAlertView: UIAlertView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.groupCodeTextField.text = self.group.code
  }

  @IBAction func save(sender: AnyObject) {
    self.groupCodeTextField.resignFirstResponder()
    if self.groupCodeTextField.text == group.code {
      self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
      return
    } else if self.groupCodeTextField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
      self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: NSLocalizedString("Group code should not be empty", comment: "Group code should not be empty"))
      return
    }
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.updateGroup(self.group, name: nil, code: self.groupCodeTextField.text,
      success: { (group: Group) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.delegate?.editGroupCodeViewController(self, didUpdateGroup: group)
        let newGroupInfo = ["newGroupInfo" : group]
        NSNotificationCenter.defaultCenter().postNotificationName("updateGroupInfoSuccessNotification", object: nil, userInfo: newGroupInfo)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if error is ForbiddenError || error is NotFoundError || error is UnprocessableEntityError {
          let errMsg = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  @IBAction func cancel(sender: AnyObject) {
    self.delegate?.editGroupCodeViewControllerDidCancel(self)
  }
  
  func displayErrorMessage(title: String, errorMsg: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }
}

extension EditGroupCodeViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(textField: UITextField) {
    textField.text = textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
  }
}
