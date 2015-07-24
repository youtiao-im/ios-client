import Foundation

class SignInViewController: UITableViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  var warningAlertView: UIAlertView!

  override func viewDidLoad() {
    emailTextField.delegate = self
    passwordTextField.delegate = self
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
  }

  func doSignInAction() {
    let emailText = emailTextField.text
    let passwdText = passwordTextField.text
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.signInWithEmail(emailText, password: passwdText,
      success: { (dictionary: [NSObject : AnyObject]) -> Void in
        let token = dictionary["access_token"] as? String
        if token != nil {
          NSUserDefaults.standardUserDefaults().setValue(token, forKey: "token")
          NSUserDefaults.standardUserDefaults().synchronize()
        }
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.loadUserInfo()
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        var errMsg: String
        if error is UnauthorizedError {
          errMsg = NSLocalizedString("Incorrect email address or password", comment: "Incorrect email address or password")
        } else {
          errMsg = ErrorsHelper.errorMessageForError(error)
        }
        self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
      }
    )
  }

  @IBAction func signIn(sender: AnyObject) {
    emailTextField.resignFirstResponder()
    let emailTextLength = emailTextField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
    if emailTextField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
      self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: NSLocalizedString("Email should not be empty", comment: "Email should not be empty"))
      return
    }
    self.doSignInAction()
  }

  @IBAction func forgotPassword(sender: AnyObject) {
    let urlBaseURLString = "http://youtiao.im:3000"
    let pageURL = urlBaseURLString + "/users/password/new"
    let forgotPasswordUrl: NSURL? = NSURL(string: pageURL)
    UIApplication.sharedApplication().openURL(forgotPasswordUrl!)
  }

  func loadUserInfo() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.fetchCurrentUser(
      success: { (user: User) -> Void in
        let userId = user.id
        NSUserDefaults.standardUserDefaults().setValue(userId, forKey: "user_id")
        NSUserDefaults.standardUserDefaults().synchronize()
        let userInfo = ["user": user]
        NSNotificationCenter.defaultCenter().postNotificationName("loadUserInfoSuccessNotification", object: nil, userInfo: userInfo)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        UIApplication.sharedApplication().delegate?.window??.rootViewController = mainStoryBoard.instantiateInitialViewController() as? UIViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate?
        appDelegate?.setBulletinTabItemBadge(UIApplication.sharedApplication().applicationIconBadgeNumber)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let errMsg = ErrorsHelper.errorMessageForError(error)
        self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
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
}

extension SignInViewController: UITableViewDelegate {
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 20.0
    } else {
      return 10.0
    }
  }
}

extension SignInViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == emailTextField {
      let rectifiedText = textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
      textField.text = rectifiedText
    }
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
      return true
    }
    return true
  }
}
