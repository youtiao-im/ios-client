import Foundation

class SettingsViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet weak var userEmailLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var appVesionLabel: UILabel!

  var user: User!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    self.userEmailLabel.text = NSLocalizedString("Unknown", comment: "Unknown")
    self.userNameLabel.text = NSLocalizedString("Unknown", comment: "Unknown")
    

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
    }
    var cell = tableView(self.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    cell.userInteractionEnabled = false
    cell = tableView(self.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
    cell.userInteractionEnabled = false
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }

  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 20.0
    } else {
      return 10.0
    }
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
    APService.setAlias("", callbackSelector: Selector("aliasCallback:tags:alias:"), object: self)
  }

  func loadUser() {
    APIClient.sharedInstance.fetchCurrentUser(
      success: { (user: User) -> Void in
        self.user = user
        self.userEmailLabel.text = user.email
        self.userNameLabel.text = user.name
        let cell = self.tableView(self.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
        cell.userInteractionEnabled = true
      }, failure: { (error: NSError) -> Void in
        ErrorsHelper.handleCommonErrors(error)
      }
    )
  }

  func aliasCallback(iRescode: Int32, tags: NSSet?, alias: String) {
    self.doLogoutAction()
  }

  func doLogoutAction() {
    APIClient.sharedInstance.signOut(
      success: { (dictionary: [NSObject: AnyObject]) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        SessionsHelper.signOut()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate?
        appDelegate?.resetApplicationIconBadge()
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        ErrorsHelper.handleCommonErrors(error)
      }
    )
  }
}

extension SettingsViewController: UITableViewDelegate {

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
