//
//  SignInViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/18/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class SignInViewController: UITableViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  @IBAction func signIn(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//    APIClient.sharedInstance.signInWithEmail(self.emailTextField.text, password: self.passwordTextField.text, success: { (Void) -> Void in
//      let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//      UIApplication.sharedApplication().delegate?.window??.rootViewController = mainStoryBoard.instantiateInitialViewController() as? UIViewController
//      }, failure: { (error: NSError) -> Void in
//        NSLog("sign in error")
//      }
//    )
    APIClient.sharedInstance.signInWithEmail("luffy@straw-hat.org", password: "12345678",
      success: { (Void) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        UIApplication.sharedApplication().delegate?.window??.rootViewController = mainStoryBoard.instantiateInitialViewController() as? UIViewController
      }, failure: { (error: NSError) -> Void in
        NSLog("%@", error)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if error is UnauthorizedError {
          var alertView = UIAlertView(title: "Sign-in failed", message: "Incorrect email address or password.", delegate: self, cancelButtonTitle: "OK")
          alertView.show()
        } else {
          // TODO:
//          DropdownAlertsHelper.showServerErrorAlert()
        }
      }
    )
  }
}
