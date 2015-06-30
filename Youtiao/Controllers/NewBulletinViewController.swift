//
//  NewBulletinViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/23/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

protocol NewBulletinViewControllerDelegate {
  func newBulletinViewController(controller: NewBulletinViewController, didCreateBulletin bulletin: Bulletin)
  func newBulletinViewControllerDidCancel(controller: NewBulletinViewController)
}

class NewBulletinViewController: UITableViewController {

//  @IBOutlet weak var textField: UITextField!

  @IBOutlet weak var textTextView: UITextView!

  var group: Group!
  var delegate: NewBulletinViewControllerDelegate?

  @IBAction func create(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.createBulletinWithText(self.textTextView.text, forGroup: group,
      success: { (bulletin: Bulletin) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.delegate?.newBulletinViewController(self, didCreateBulletin: bulletin)
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let unprocessableEntityError = error as? UnprocessableEntityError {
          var errorMessage: String?
          switch unprocessableEntityError.reason! {
          case UnprocessableEntityErrorReason.Blank:
            errorMessage = "Bulletin text cannot be blank."
          case UnprocessableEntityErrorReason.TooShort:
            errorMessage = "Bulletin text is too short."
          case UnprocessableEntityErrorReason.TooLong:
            errorMessage = "Bulletin text is too long."
          default:
            errorMessage = "Bulletin text is invalid."
          }

          var alertView = UIAlertView(title: "Failed to Createe Bulletin", message: errorMessage, delegate: self, cancelButtonTitle: "OK")
          alertView.show()
        } else if error is ForbiddenError {
          // TODO:
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  @IBAction func cancel(sender: AnyObject) {
    self.delegate?.newBulletinViewControllerDidCancel(self)
  }
}
