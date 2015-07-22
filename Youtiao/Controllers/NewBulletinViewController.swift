import UIKit

protocol NewBulletinViewControllerDelegate {
  func newBulletinViewController(controller: NewBulletinViewController, didCreateBulletin bulletin: Bulletin)
  func newBulletinViewControllerDidCancel(controller: NewBulletinViewController)
}

class NewBulletinViewController: UIViewController, GroupsViewControllerDelegate {

  @IBOutlet weak var topViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var groupTextField: UITextField!
  @IBOutlet weak var toLabel: UILabel!
  var textViewPlaceHolderLabel: UILabel!

  var group: Group?
  var delegate: NewBulletinViewControllerDelegate?

  var warningAlertView: UIAlertView?

  override func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleKeyboardWillShowNotification:"), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleKeyboardWillHideNotification:"), name: UIKeyboardWillHideNotification, object: nil)
    self.topViewWidthConstraint.constant = self.view.bounds.size.width
    self.scrollViewBottomConstraint.constant = 0
    self.toLabel.text = NSLocalizedString("To", comment: "To:")
    textViewPlaceHolderLabel = UILabel()
    textViewPlaceHolderLabel.text = NSLocalizedString("Enter message", comment: "Enter message")
    textViewPlaceHolderLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    textViewPlaceHolderLabel.font = UIFont.systemFontOfSize(17.0)
    textViewPlaceHolderLabel.textColor = UIColor.grayColor()
    self.textView.addSubview(textViewPlaceHolderLabel)
    let topMarginConstraint = NSLayoutConstraint(item: textViewPlaceHolderLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.textView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 8)
    let leadingMarginConstraint = NSLayoutConstraint(item: textViewPlaceHolderLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.textView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 4)
    let trailingMarginConstraint = NSLayoutConstraint(item: textViewPlaceHolderLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.textView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
    self.textView.addConstraint(topMarginConstraint)
    self.textView.addConstraint(leadingMarginConstraint)
    self.textView.addConstraint(trailingMarginConstraint)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.textView.becomeFirstResponder()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let groupsNavigationViewController = segue.destinationViewController as? UINavigationController {
      if let groupsViewController = groupsNavigationViewController.topViewController as? GroupsViewController {
        groupsViewController.delegate = self
      }
    }
  }

  func handleKeyboardWillShowNotification(notification: NSNotification) {
    let userInfo = NSDictionary(dictionary: notification.userInfo!)
    let value = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
    let frame = value.CGRectValue()
    let keyboardHeight = frame.size.height
    self.scrollViewBottomConstraint.constant = keyboardHeight
  }

  func handleKeyboardWillHideNotification(notification: NSNotification) {
    self.scrollViewBottomConstraint.constant = 0
  }

  func didSelectGroup(group: Group) {
    self.group = group
    self.groupTextField.text = self.group?.name
  }

  @IBAction func create(sender: AnyObject) {
    if self.group == nil {
      let warningTitle = NSLocalizedString("Warning", comment: "Warning")
      let errorMsg = NSLocalizedString("You must select a group to create a bulletin", comment: "Group cannot be nil")
      self.displayErrorMessage(warningTitle, errorMsg: errorMsg)
      return
    }
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.createBulletinWithText(self.textView.text, forGroup: group!,
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
    if (warningAlertView?.visible != nil) {
      warningAlertView?.dismissWithClickedButtonIndex(0, animated: false)
    }
    warningAlertView = UIAlertView(title: title, message: errorMsg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    warningAlertView?.show()
  }
}

extension NewBulletinViewController: UITextViewDelegate {
  func textViewDidChange(textView: UITextView) {
    if textView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
      self.textViewPlaceHolderLabel?.hidden = false
    } else {
      self.textViewPlaceHolderLabel?.hidden = true
    }

    var bounds = self.textView.bounds
    let maxSize = CGSize(width: bounds.size.width, height: CGFloat.max)
    let newSize = textView.sizeThatFits(maxSize)
    bounds.size = newSize
    self.textViewHeightConstraint.constant = newSize.height
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
