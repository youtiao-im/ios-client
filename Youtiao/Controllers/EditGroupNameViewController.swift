import Foundation

protocol EditGroupNameViewControllerDelegate {
  func editGroupNameViewController(controller: EditGroupNameViewController, didUpdateGroup group: Group)
  func editGroupNameViewControllerDidCancel(controller: EditGroupNameViewController)
}

class EditGroupNameViewController: UITableViewController {
  @IBOutlet weak var groupNameTextField: UITextField!

  var group: Group!
  var delegate: EditGroupNameViewControllerDelegate?

  var warningAlertView: UIAlertView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.groupNameTextField.text = self.group.name
  }

  @IBAction func save(sender: AnyObject) {
    self.groupNameTextField.resignFirstResponder()
    if self.groupNameTextField.text == group.name {
      self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
      return
    } else if self.groupNameTextField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
      self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: NSLocalizedString("Group name should not be empty", comment: "Group name should not be empty"))
      return
    }
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.updateGroup(self.group, name: self.groupNameTextField.text, code: nil,
      success: { (group: Group) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.delegate?.editGroupNameViewController(self, didUpdateGroup: group)
        let userInfoDict = ["newGroupInfo": group]
        NSNotificationCenter.defaultCenter().postNotificationName("updateGroupInfoSuccessNotification", object: nil, userInfo: userInfoDict)
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

  func displayErrorMessage(title: String, errorMsg: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }

  @IBAction func cancel(sender: AnyObject) {
    self.delegate?.editGroupNameViewControllerDidCancel(self)
  }
}

extension EditGroupNameViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    return true
  }

  func textFieldDidEndEditing(textField: UITextField) {
    textField.text = textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
  }
}
