import Foundation

protocol NewBulletinViewControllerDelegate {
  func newBulletinViewController(controller: NewBulletinViewController, didCreateBulletin bulletin: Bulletin)
  func newBulletinViewControllerDidCancel(controller: NewBulletinViewController)
}

class NewBulletinViewController: UITableViewController, GroupsViewControllerDelegate {
  @IBOutlet weak var textTextView: UITextView!
  @IBOutlet weak var groupTextField: UITextField!

  var group: Group?
  var delegate: NewBulletinViewControllerDelegate?

  var warningAlertView: UIAlertView!

  override func viewDidLoad() {
    super.viewDidLoad()
    textTextView.text = ""
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("cancelInput:"))
    tapGestureRecognizer.numberOfTapsRequired = 2
    self.view.addGestureRecognizer(tapGestureRecognizer)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let groupsNavigationViewController = segue.destinationViewController as? UINavigationController {
      if let groupsViewController = groupsNavigationViewController.topViewController as? GroupsViewController {
        groupsViewController.delegate = self
      }
    }
  }

  func cancelInput(gestureRecognizer: UIGestureRecognizer) {
    if textTextView.isFirstResponder() {
      textTextView.resignFirstResponder()
    }
  }

  func didSelectGroup(group: Group) {
    self.group = group
    groupTextField.text = self.group?.name
  }

  @IBAction func create(sender: AnyObject) {
    if self.group == nil {
      let warningTitle = NSLocalizedString("Warning", comment: "Warning")
      let errorMsg = NSLocalizedString("You must select a group to create a bulletin", comment: "Group cannot be nil")
      self.displayErrorMessage(warningTitle, errorMsg: errorMsg)
      return
    }
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.createBulletinWithText(self.textTextView.text, forGroup: group!,
      success: { (bulletin: Bulletin) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.delegate?.newBulletinViewController(self, didCreateBulletin: bulletin)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let unprocessableEntityError = error as? UnprocessableEntityError {
          var errorMessage: String?
          switch unprocessableEntityError.reason! {
          case UnprocessableEntityErrorReason.Blank:
            errorMessage = NSLocalizedString("Bulletin text cannot be blank.", comment: "Bulletin text cannot be blank.")
          case UnprocessableEntityErrorReason.TooShort:
            errorMessage = NSLocalizedString("Bulletin text is too short.", comment: "Bulletin text is too short.")
          case UnprocessableEntityErrorReason.TooLong:
            errorMessage = NSLocalizedString("Bulletin text is too long.", comment: "Bulletin text is too long.")
          default:
            errorMessage = NSLocalizedString("Bulletin text is invalid.", comment: "Bulletin text is invalid.")
          }
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errorMessage!)
        } else if error is ForbiddenError {
          var errorMessage = ErrorsHelper.errorMessageForError(error)
          self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errorMessage)
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  @IBAction func cancel(sender: AnyObject) {
    self.delegate?.newBulletinViewControllerDidCancel(self)
  }

  func displayErrorMessage(title: String, errorMsg: String) {
    if warningAlertView != nil && warningAlertView.visible {
      warningAlertView.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView.show()
  }
}

extension NewBulletinViewController: UITableViewDelegate {
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 20.0
    } else {
      return 10.0
    }
  }
}

extension NewBulletinViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if textField === self.groupTextField {
      textField.inputView = UIView(frame: CGRectZero)
    }
    return true
  }

  func textFieldDidBeginEditing(textField: UITextField) {
    self.performSegueWithIdentifier("selectGroupForNewBulletinSegue", sender: nil)
  }
}
