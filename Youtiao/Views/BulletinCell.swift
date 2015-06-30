//
//  BulletinCell.swift
//  Youtiao
//
//  Created by Feng Ye on 6/18/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation


class BulletinCell: UITableViewCell {

  @IBOutlet weak var userAvatarImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var groupNameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var textContentLabel: UILabel!
  @IBOutlet weak var checksCountLabel: UILabel!
  @IBOutlet weak var crossesCountLabel: UILabel!
  @IBOutlet weak var checkButton: UIButton!
  @IBOutlet weak var crossButton: UIButton!

  var checked: Bool = false {
    didSet {
      if (self.checked) {
        self.checksCountLabel.textColor = GREEN_COLOR
        self.checkButton.setImageTintColor(GREEN_COLOR, forState: UIControlState.Normal)
      } else {
        self.checksCountLabel.textColor = MUTED_TEXT_COLOR
        self.checkButton.setImageTintColor(MUTED_ICON_COLOR, forState: UIControlState.Normal)
      }
    }
  }

  var crossed: Bool = false {
    didSet {
      if (self.crossed) {
        self.crossesCountLabel.textColor = RED_COLOR
        self.crossButton.setImageTintColor(RED_COLOR, forState: UIControlState.Normal)
      } else {
        self.crossesCountLabel.textColor = MUTED_TEXT_COLOR
        self.crossButton.setImageTintColor(MUTED_ICON_COLOR, forState: UIControlState.Normal)
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    self.groupNameLabel.textColor = MUTED_TEXT_COLOR
    self.timestampLabel.textColor = MUTED_TEXT_COLOR
    self.checksCountLabel.textColor = MUTED_TEXT_COLOR
    self.checkButton.setImageTintColor(MUTED_ICON_COLOR, forState: UIControlState.Normal)
    self.crossesCountLabel.textColor = MUTED_TEXT_COLOR
    self.crossButton.setImageTintColor(MUTED_ICON_COLOR, forState: UIControlState.Normal)
  }
}
