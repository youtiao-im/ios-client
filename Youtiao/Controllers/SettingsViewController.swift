//
//  SettingsViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/17/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class SettingsViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var userAvatarImageView: UIImageView!
  @IBOutlet weak var userEmailLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    self.loadUser()
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if (indexPath.section == 0 && indexPath.row == 0) {
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self
      imagePickerController.allowsEditing = true
      self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
  }

  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    picker.dismissViewControllerAnimated(true, completion: nil)
    if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      APIClient.sharedInstance.changeCurrentUserAvatarWithImage(selectedImage,
        success: { (user: User) -> Void in
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.userAvatarImageView.sd_setImageWithURL(user.avatar?.dataURL)
          self.userEmailLabel.text = user.email
          self.userNameLabel.text = user.name
        }, failure: { (error: NSError) -> Void in
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          ErrorsHelper.handleCommonErrors(error)
        }
      )
    }
  }

  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func signOut(sender: AnyObject) {
    SessionsHelper.signOut()
  }

  func loadUser() {
    APIClient.sharedInstance.fetchCurrentUser(
      success: { (user: User) -> Void in
        self.userAvatarImageView.sd_setImageWithURL(user.avatar?.dataURL)
        self.userEmailLabel.text = user.email
        self.userNameLabel.text = user.name
      }, failure: { (error: NSError) -> Void in
        ErrorsHelper.handleCommonErrors(error)
      }
    )
  }
}
