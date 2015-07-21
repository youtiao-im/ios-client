import Foundation

protocol NewGroupViewControllerDelegate {
  func newGroupViewController(controller: NewGroupViewController, didCreateGroup group: Group)
  func newGroupViewControllerDidCancel(controller: NewGroupViewController)
}

class NewGroupViewController: UITableViewController {
  @IBOutlet weak var nameTextField: UITextField!

  var delegate: NewGroupViewControllerDelegate?

  var warningAlertView: UIAlertView!

  @IBAction func create(sender: AnyObject) {
    self.nameTextField.resignFirstResponder()
    if self.nameTextField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
      self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: NSLocalizedString("Group name should not be empty", comment: "Group name should not be empty"))
      return
    }
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.createGroupWithName(self.nameTextField.text, code: nil,
      success: { (group: Group) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.delegate?.newGroupViewController(self, didCreateGroup: group)
        let userInfo = ["newGroupInfo" : group]
        NSNotificationCenter.defaultCenter().postNotificationName("createGroupSuccessNotification", object: nil, userInfo: userInfo)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let unprocessableEntityError = error as? UnprocessableEntityError {
          var errorMessage: String?
          switch unprocessableEntityError.reason! {
          case UnprocessableEntityErrorReason.Blank:
            errorMessage = NSLocalizedString("Group name cannot be blank.", comment: "Group name cannot be blank.")
          case UnprocessableEntityErrorReason.TooShort:
            errorMessage = NSLocalizedString("Group name is too short.", comment: "Group name is too short.")
          case UnprocessableEntityErrorReason.TooLong:
            errorMessage = NSLocalizedString("Group name is too long.", comment: "Group name is too long.")
          default:
            errorMessage = NSLocalizedString("Group name is invalid.", comment: "Group name is invalid.")
          }
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errorMessage!)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  @IBAction func cancel(sender: AnyObject) {
    self.delegate?.newGroupViewControllerDidCancel(self)
  }

  func displayErrorMessage(title: String, errorMsg: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }
}

extension NewGroupViewController: UITableViewDelegate {
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 20.0
    } else {
      return 10.0
    }
  }
}

extension NewGroupViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(textField: UITextField) {
    textField.text = textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
  }
}
