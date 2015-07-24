import Foundation

class SignUpViewController: UITableViewController {
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!

  var warningAlertView: UIAlertView!

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBarHidden = false
  }

  override func viewWillDisappear(animated: Bool) {
    self.navigationController?.navigationBarHidden = true
    super.viewWillDisappear(animated)
  }
  
  @IBAction func signUpTapped(sender: AnyObject) {
    self.emailTextField.resignFirstResponder()
    self.passwordTextField.resignFirstResponder()

    if !self.isInputValidation() {
     return
    }
    let email = self.emailTextField.text
    let password = self.passwordTextField.text
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.signUpWithEmail(email, password: password, name: nil,
      success: { (user: User) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.signUpSucceededWithUser(user)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        var errMsg = ErrorsHelper.errorMessageForError(error)
        self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: errMsg)
      }
    )
  }

  private func signUpSucceededWithUser(user: User) {
    self.loginWithEmail()
  }

  private func isInputValidation() -> Bool {
    let email = self.emailTextField.text
    let password = self.passwordTextField.text
    if email.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
      self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: NSLocalizedString("Email invalid", comment: "Email invalid"))
      return false
    } else if password.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
      self.displayErrorMessage(NSLocalizedString("Warning", comment: "Warning"), errorMsg: NSLocalizedString("Password invalid", comment: "Password invalid"))
      return false
    }
    return true
  }

  private func loginWithEmail() {
    let email = self.emailTextField.text
    let password = self.passwordTextField.text
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.signInWithEmail(email, password: password,
      success: { (dictionary: [NSObject: AnyObject]) -> Void in
        let token = dictionary["access_token"] as? String
        if token != nil {
          NSUserDefaults.standardUserDefaults().setValue(token, forKey: "token")
          NSUserDefaults.standardUserDefaults().synchronize()
        }
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        UIApplication.sharedApplication().delegate?.window??.rootViewController = mainStoryBoard.instantiateInitialViewController() as? UIViewController
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        var errMsg = ErrorsHelper.errorMessageForError(error)
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

extension SignUpViewController: UITableViewDelegate {
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 20.0
    } else {
      return 10.0
    }
  }
}

extension SignUpViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == self.emailTextField {
      self.passwordTextField.becomeFirstResponder()
    } else {
      self.passwordTextField.resignFirstResponder()
    }
    return true
  }

  func textFieldDidEndEditing(textField: UITextField) {
    if textField == self.emailTextField {
      var filledString = textField.text
      filledString = filledString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
      textField.text = filledString
    }
  }
}
