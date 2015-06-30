//
//  GroupBulletinsViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/17/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class GroupBulletinsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewBulletinViewControllerDelegate {

  @IBOutlet weak var bulletinsTableView: UITableView!

  var group: Group!
  private var bulletins: [Bulletin] = [Bulletin]()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    self.title = self.group.name

    var newBulletinBarButtonItem = UIBarButtonItem(image: UIImage(named: "quill-write"), style: UIBarButtonItemStyle.Plain, target: self, action: "performNewBulletinSegue")
    newBulletinBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -30, 0, -60)
    self.navigationItem.rightBarButtonItems = [self.navigationItem.rightBarButtonItem!, newBulletinBarButtonItem]

    let bulletinCellNib = UINib(nibName: "BulletinCell", bundle: nil)
    self.bulletinsTableView.registerNib(bulletinCellNib, forCellReuseIdentifier: "BulletinCell")
    self.bulletinsTableView.rowHeight = UITableViewAutomaticDimension;
    self.bulletinsTableView.estimatedRowHeight = 160.0;

    self.bulletinsTableView.tableFooterView = UIView()

    self.bulletinsTableView.ins_addInfinityScrollWithHeight(60.0,
      handler: { (scrollView: UIScrollView!) -> Void in
        self.loadMoreBulletins()
      }
    )

    let infinityIndicator = INSDefaultInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))
    self.bulletinsTableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)
    infinityIndicator.startAnimating()

    self.loadBulletins()
  }

  override func viewWillAppear(animated: Bool) {
    if let selectedIndexPath = self.bulletinsTableView.indexPathForSelectedRow() {
      self.bulletinsTableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
    }

    super.viewWillAppear(animated)
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.bulletins.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BulletinCell") as! BulletinCell
    let bulletin = self.bulletins[indexPath.row]

    if let avatarDataURL = bulletin.createdBy?.avatar?.dataURL {
      cell.userAvatarImageView.sd_setImageWithURL(avatarDataURL)
    }
    cell.userNameLabel.text = bulletin.createdBy?.name
    cell.groupNameLabel.text = bulletin.group?.name
    cell.timestampLabel.text = "1h"
    cell.textContentLabel.text = bulletin.text
    cell.checksCountLabel.text = bulletin.checksCount?.stringValue
    cell.crossesCountLabel.text = bulletin.crossesCount?.stringValue
    if bulletin.currentStamp != nil {
      switch bulletin.currentStamp!.symbol! {
      case "check":
        cell.checked = true
        cell.crossed = false
      case "cross":
        cell.checked = false
        cell.crossed = true
      default:
        break
      }
    }

    cell.checkButton.tag = indexPath.row
    cell.checkButton.addTarget(self, action: "checkBulletin:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.crossButton.tag = indexPath.row
    cell.crossButton.addTarget(self, action: "crossBulletin:", forControlEvents: UIControlEvents.TouchUpInside)
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier("BulletinSelectionSegue", sender: self)
  }

  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.separatorInset = UIEdgeInsetsZero
    cell.preservesSuperviewLayoutMargins = false
    cell.layoutMargins = UIEdgeInsetsZero
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let bulletinViewController = segue.destinationViewController as? BulletinViewController {
      bulletinViewController.bulletin = self.bulletins[bulletinsTableView.indexPathForSelectedRow()!.row]
    } else if let groupSettingsViewController = segue.destinationViewController as? GroupSettingsViewController {
      groupSettingsViewController.group = self.group
    } else if let segueNavigationController = segue.destinationViewController as? UINavigationController {
      if let newBulletinViewController = segueNavigationController.viewControllers[0] as? NewBulletinViewController {
        newBulletinViewController.group = self.group
        newBulletinViewController.delegate = self
      }
    }
  }

  func newBulletinViewController(controller: NewBulletinViewController, didCreateBulletin bulletin: Bulletin) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func newBulletinViewControllerDidCancel(controller: NewBulletinViewController) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func performNewBulletinSegue() {
    self.performSegueWithIdentifier("NewBulletinSegue", sender: self)
  }

  func loadBulletins() {
    APIClient.sharedInstance.fetchBulletinsForGroup(self.group,
      success: { (bulletins: [Bulletin]) -> Void in
        self.bulletins = bulletins
        self.bulletinsTableView.reloadData()
        self.bulletinsTableView.ins_infiniteScrollBackgroundView.enabled = bulletins.count >= 25
      }, failure: { (error: NSError) -> Void in
        if error is ForbiddenError {
          // TODO:
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func loadMoreBulletins() {
    if let lastBulletin = self.bulletins.last {
      APIClient.sharedInstance.fetchBulletinsForGroup(self.group, createdBeforeBulletin: lastBulletin,
        success: { (bulletins: [Bulletin]) -> Void in
          self.bulletins += bulletins
          self.bulletinsTableView.reloadData()
          self.bulletinsTableView.ins_endInfinityScrollWithStoppingContentOffset(true)
          self.bulletinsTableView.ins_infiniteScrollBackgroundView.enabled = bulletins.count >= 25
        }, failure: { (error: NSError) -> Void in
          if error is ForbiddenError {
            // TODO:
          } else {
            ErrorsHelper.handleCommonErrors(error)
          }
        }
      )
    }
  }

  func checkBulletin(sender: UIButton!) {
    let bulletin = self.bulletins[sender.tag]
    APIClient.sharedInstance.stampBulletin(bulletin, withSymbol: "check",
      success: { (bulletin: Bulletin) -> Void in
        // TODO: update cell?
      }, failure: { (error: NSError) -> Void in
        if error is ForbiddenError {
          // TODO:
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func crossBulletin(sender: UIButton!) {
    let bulletin = self.bulletins[sender.tag]
    APIClient.sharedInstance.stampBulletin(bulletin, withSymbol: "cross",
      success: { (bulletin: Bulletin) -> Void in
        // TODO: update cell?
      }, failure: { (error: NSError) -> Void in
        if error is ForbiddenError {
          // TODO:
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }
}
