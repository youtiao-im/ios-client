//
//  BulletinViewController.swift
//  Youtiao
//
//  Created by Feng Ye on 6/17/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class BulletinViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var commentsTableView: UITableView!
  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var newCommentView: UIView!
  @IBOutlet weak var commentTextTextField: UITextField!

  var bulletin: Bulletin!
  private var comments: [Comment] = [Comment]()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    let bulletinDetailCellNib = UINib(nibName: "BulletinDetailCell", bundle: nil)
    self.commentsTableView.registerNib(bulletinDetailCellNib, forCellReuseIdentifier: "BulletinDetailCell")
    let commentCellNib = UINib(nibName: "CommentCell", bundle: nil)
    self.commentsTableView.registerNib(commentCellNib, forCellReuseIdentifier: "CommentCell")
    self.commentsTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentsTableView.estimatedRowHeight = 160.0;

    self.commentsTableView.tableFooterView = UIView()

    self.newCommentView.backgroundColor = BACKGROUND_COLOR
    var newCommentViewTopBorder = CALayer()
    newCommentViewTopBorder.frame = CGRectMake(0.0, 0.0, self.newCommentView.frame.width, 0.5)
    newCommentViewTopBorder.backgroundColor = UIColor(hex: 0xc8c8c8).CGColor
    self.newCommentView.layer.addSublayer(newCommentViewTopBorder)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)

    self.commentsTableView.ins_addInfinityScrollWithHeight(60.0,
      handler: { (scrollView: UIScrollView!) -> Void in
        self.loadMoreComments()
      }
    )

    let infinityIndicator = INSDefaultInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))
    self.commentsTableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)
    infinityIndicator.startAnimating()

    self.loadComments()
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.comments.count + 1
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if (indexPath.row == 0) {
      let cell = tableView.dequeueReusableCellWithIdentifier("BulletinDetailCell") as! BulletinDetailCell

      if let avatarDataURL = bulletin.createdBy?.avatar?.dataURL {
        cell.userAvatarImageView.sd_setImageWithURL(avatarDataURL)
      }
      cell.userNameLabel.text = self.bulletin.createdBy?.name
      cell.groupNameLabel.text = self.bulletin.group?.name
      cell.timestampLabel.text = "1h"
      cell.textContentLabel.text = self.bulletin.text
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
      let comment = self.comments[indexPath.row - 1]

      if let avatarDataURL = comment.createdBy?.avatar?.dataURL {
        cell.userAvatarImageView.sd_setImageWithURL(avatarDataURL)
      }
      cell.userNameLabel.text = comment.createdBy?.name
      cell.timestampLabel.text = "1h"
      cell.textContentLabel.text = comment.text
      return cell
    }
  }

  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.separatorInset = UIEdgeInsetsZero
    cell.preservesSuperviewLayoutMargins = false
    cell.layoutMargins = UIEdgeInsetsZero
  }

  func keyboardDidShow(sender: NSNotification!) {
    let frame = sender.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
    let newFrame = self.view.convertRect(frame, fromView: UIApplication.sharedApplication().delegate!.window!)
    self.bottomLayoutConstraint.constant = CGRectGetHeight(self.view.frame) - newFrame.origin.y
    self.view.layoutIfNeeded()
  }

  func keyboardWillHide(sender: NSNotification!) {
    self.bottomLayoutConstraint.constant = 0
    self.view.layoutIfNeeded()
  }

  @IBAction func createComment(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    APIClient.sharedInstance.createCommentWithText(self.commentTextTextField.text, forBulletin: self.bulletin,
      success: { (comment: Comment) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.loadComments()
        self.view.endEditing(true)
        self.commentTextTextField.text = nil
      }, failure: { (error: NSError) -> Void in
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let unprocessableEntityError = error as? UnprocessableEntityError {
          var errorMessage: String?
          switch unprocessableEntityError.reason! {
          case UnprocessableEntityErrorReason.Blank:
            errorMessage = "Comment text cannot be blank."
          case UnprocessableEntityErrorReason.TooShort:
            errorMessage = "Comment text is too short."
          case UnprocessableEntityErrorReason.TooLong:
            errorMessage = "Comment text is too long."
          default:
            errorMessage = "Comment text is invalid."
          }

          var alertView = UIAlertView(title: "Failed to Create Comment", message: errorMessage, delegate: self, cancelButtonTitle: "OK")
          alertView.show()
        } else if error is ForbiddenError {
          // TODO:
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func loadComments() {
    APIClient.sharedInstance.fetchCommentsForBulletin(self.bulletin,
      success: { (comments: [Comment]) -> Void in
        self.comments = comments
        self.commentsTableView.reloadData()
        self.commentsTableView.ins_infiniteScrollBackgroundView.enabled = comments.count >= 25
      }, failure: { (error: NSError) -> Void in
        if error is ForbiddenError {
          // TODO:
        } else {
          ErrorsHelper.handleCommonErrors(error)
        }
      }
    )
  }

  func loadMoreComments() {
    if let lastComment = self.comments.last {
      APIClient.sharedInstance.fetchCommentsForBulletin(self.bulletin, createdBeforeComment: lastComment,
        success: { (comments: [Comment]) -> Void in
          self.comments += comments
          self.commentsTableView.reloadData()
          self.commentsTableView.ins_endInfinityScrollWithStoppingContentOffset(true)
          self.commentsTableView.ins_infiniteScrollBackgroundView.enabled = comments.count >= 25
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
}
