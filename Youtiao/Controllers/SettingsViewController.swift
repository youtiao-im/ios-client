//
//  SettingsViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/17/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class SettingsViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var userEmailLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var appVesionLabel: UILabel!
  
  var user: User!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    
    let infoDict: [NSObject: AnyObject] = NSBundle.mainBundle().infoDictionary!
    let versionString = infoDict["CFBundleShortVersionString"] as? String
    self.appVesionLabel.text = versionString
    self.loadUser()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if user == nil {
      let cell = tableView(self.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
      cell.userInteractionEnabled = false
      self.userNameLabel.textColor = UIColor.grayColor()
      self.userEmailLabel.textColor = UIColor.grayColor()
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let destinationNavigationController = segue.destinationViewController as? UINavigationController
    if let editUserNameViewController = destinationNavigationController?.topViewController as? EditUserNameViewController {
      editUserNameViewController.user = self.user!
      editUserNameViewController.delegate = self
    }
  }

  @IBAction func signOut(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.signOut({ (dictionary: [NSObject: AnyObject]) -> Void in
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      SessionsHelper.signOut()
    }){ (error: NSError) -> Void in
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      ErrorsHelper.handleCommonErrors(error)
    }
  }

  func loadUser() {
    APIClient.sharedInstance.fetchCurrentUser(
      success: { (user: User) -> Void in
        self.user = user
        self.userEmailLabel.text = user.email
        self.userNameLabel.text = user.name
        self.userEmailLabel.textColor = UIColor.blackColor()
        self.userNameLabel.textColor = UIColor.blackColor()
        let cell = self.tableView(self.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
        cell.userInteractionEnabled = true
      }, failure: { (error: NSError) -> Void in
        ErrorsHelper.handleCommonErrors(error)
      }
    )
  }
}

extension SettingsViewController: EditUserNameViewControllerDelegate {
  func editUserNameViewController(controller: EditUserNameViewController, didUpdateUser user: User) {
    self.user = user
    self.userEmailLabel.text = user.email
    self.userNameLabel.text = user.name
    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
  func editUserNameViewControllerDidCancel(controller: EditUserNameViewController) {
    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
}
