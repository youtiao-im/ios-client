import Foundation

protocol JoinGroupViewControllerDelegate {
  func joinGroupViewController(controller: JoinGroupViewController, didJoinGroup group: Group)
  func joinGroupViewControllerDidCancel(controller: JoinGroupViewController)
}

class JoinGroupViewController: UITableViewController {
  @IBOutlet weak var codeTextField: UITextField!

  var delegate: JoinGroupViewControllerDelegate?

  var warningAlertView: UIAlertView!

  @IBAction func join(sender: AnyObject) {
    if self.codeTextField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
      let warningTitle = NSLocalizedString("Warning", comment: "Warning")
      let errorMsg = NSLocalizedString("Group code should not be empty", comment: "Group code should not be empty")
      self.displayErrorMessage(warningTitle, errorMsg: errorMsg)
      return
    }
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.joinGroupWithCode(self.codeTextField.text,
      success: { (group: Group) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.delegate?.joinGroupViewController(self, didJoinGroup: group)
        let userInfo = ["groupInfo" : group]
        NSNotificationCenter.defaultCenter().postNotificationName("joinGroupSuccessNotification", object: nil, userInfo: userInfo)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if error is NotFoundError {
          var errMsg = NSLocalizedString("We cannot find any group with the given code.", comment: "We cannot find any group with the given code.")
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
        } else if error is ForbiddenError {
          var errMsg = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  @IBAction func cancel(sender: AnyObject) {
    self.delegate?.joinGroupViewControllerDidCancel(self)
  }

  func displayErrorMessage(title: String, errorMsg: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }
}

extension JoinGroupViewController: UITableViewDelegate {
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 20.0
    } else {
      return 10.0
    }
  }
}
