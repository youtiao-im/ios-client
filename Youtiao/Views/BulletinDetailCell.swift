//
//  BulletinDetailCell.swift
//  Youtiao
//
//  Created by Feng Ye on 6/18/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class BulletinDetailCell: UITableViewCell {

  @IBOutlet weak var userAvatarImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var groupNameLabel: UILabel!
  @IBOutlet weak var textContentLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.groupNameLabel.textColor = MUTED_TEXT_COLOR
    self.timestampLabel.textColor = MUTED_TEXT_COLOR
//    self.bulletinChecksCountLabel?.textColor = secondaryLabelTextColor
//    self.bulletinCrossesCountLabel?.textColor = secondaryLabelTextColor
//    self.bulletinCommentsCountLabel?.textColor = secondaryLabelTextColor
  }
}
