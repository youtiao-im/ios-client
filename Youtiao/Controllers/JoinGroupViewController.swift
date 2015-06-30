//
//  JoinGroupViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/24/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

protocol JoinGroupViewControllerDelegate {
  func joinGroupViewController(controller: JoinGroupViewController, didJoinGroup group: Group)
  func joinGroupViewControllerDidCancel(controller: JoinGroupViewController)
}

class JoinGroupViewController: UITableViewController {

  @IBOutlet weak var codeTextField: UITextField!

  var delegate: JoinGroupViewControllerDelegate?

  @IBAction func join(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.joinGroupWithCode(self.codeTextField.text,
      success: { (group: Group) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.delegate?.joinGroupViewController(self, didJoinGroup: group)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if error is NotFoundError {
          var alertView = UIAlertView(title: "No such group", message: "We cannot find any group with the given code.", delegate: self, cancelButtonTitle: "OK")
          alertView.show()
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  @IBAction func cancel(sender: AnyObject) {
    self.delegate?.joinGroupViewControllerDidCancel(self)
  }
}
