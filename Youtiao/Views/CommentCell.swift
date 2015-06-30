//
//  CommentCell.swift
//  Youtiao
//
//  Created by Feng Ye on 6/18/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class CommentCell: UITableViewCell {

  @IBOutlet weak var userAvatarImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var textContentLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = SECOND_BACKGROUND_COLOR
  }
}
