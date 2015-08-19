import UIKit
import MessageUI

class FeedbackViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
    cell?.selectionStyle = UITableViewCellSelectionStyle.None
  }
}

extension FeedbackViewController: UITableViewDelegate {
  func configuredMailComposeViewController() -> MFMailComposeViewController? {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
    mailComposerVC.setToRecipients(["feng.ye@youtiao.im"])
    mailComposerVC.setSubject(NSLocalizedString("Problem Feedback", comment: "Problem Feedback"))
    var messageBody: String = NSLocalizedString("", comment: "")
    mailComposerVC.setMessageBody(messageBody, isHTML: true)
    return mailComposerVC
  }

  func showSendMailErrorAlert() {
    let sendMailErrorAlert = UIAlertView(title: NSLocalizedString("Warning", comment: "Warning"), message: NSLocalizedString("Can not send email from this device, you should change configuration for email first", comment: "Can not send email"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
    sendMailErrorAlert.show()
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if indexPath.row == 0 {
      let mailComposeViewController: MFMailComposeViewController? = self.configuredMailComposeViewController()
      if mailComposeViewController == nil {
        return
      } else {
        if MFMailComposeViewController.canSendMail() {
          self.navigationController?.presentViewController(mailComposeViewController!, animated: true, completion: nil)
        } else {
          self.showSendMailErrorAlert()
        }
      }
    }
  }

  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 20.0
    } else {
      return 10.0
    }
  }
}

extension FeedbackViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
    switch (result.value) {
    case MFMailComposeResultFailed.value:
      let alertView = UIAlertView(title: NSLocalizedString("Warning", comment: "Warning"), message: NSLocalizedString("Mail send failed", comment: "Mail send failed"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
      alertView.show()
    default:
        break
    }
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
}
