//
//  EditUserNameViewController.swift
//  Youtiao
//
//  Created by Banmayun on 15/7/8.
//  Copyright (c) 2015年 youtiao.im. All rights reserved.
//

import Foundation

protocol EditUserNameViewControllerDelegate {
  func editUserNameViewController(controller: EditUserNameViewController, didUpdateUser user: User)
  func editUserNameViewControllerDidCancel(controller: EditUserNameViewController)
}

class EditUserNameViewController: UITableViewController {
  
  @IBOutlet weak var userNameTextField: UITextField!
  
  var user: User!
  var delegate: EditUserNameViewControllerDelegate?
  var warningAlertView: UIAlertView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userNameTextField.text = user.name
  }
  
  @IBAction func saveItemTapped(sender: AnyObject) {
    if self.userNameTextField.isFirstResponder() {
      self.userNameTextField.resignFirstResponder()
    }
    let newUserName = self.userNameTextField.text
    if newUserName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
      self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: NSLocalizedString("User name invalid", comment: "User name invalid"))
      return
    } else if newUserName == user.name {
      self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
      return
    }
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.updateCurrentUserWithName(newUserName, avatatId: nil, success: { (user: User) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.user = user
        self.delegate?.editUserNameViewController(self, didUpdateUser: user)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if error is ForbiddenError || error is NotFoundError || error is UnprocessableEntityError {
          var errMsg = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }
  
  @IBAction func cancelItemTapped(sender: AnyObject) {
    self.delegate?.editUserNameViewControllerDidCancel(self)
  }
  
  func displayErrorMessage(title: String, errorMsg: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }
}

extension EditUserNameViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    return true
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    var filledText = textField.text
    filledText = filledText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    textField.text = filledText
  }
}