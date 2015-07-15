import UIKit

class BulletinCell: UITableViewCell {
  @IBOutlet weak var groupNameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var textContentLabel: UILabel!
  @IBOutlet weak var checkButton: UIButton!
  @IBOutlet weak var crossButton: UIButton!
  @IBOutlet weak var checksCountLabel: UILabel!
  @IBOutlet weak var crossesCountLabel: UILabel!

  var checked: Bool = false {
    didSet {
      if (self.checked) {
        self.checksCountLabel.textColor = GREEN_COLOR
        self.checkButton.setImageTintColor(GREEN_COLOR, forState: UIControlState.Normal)
        self.checkButton.enabled = false
        self.crossButton.enabled = true
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
        self.crossButton.enabled = false
        self.checkButton.enabled = true
      } else {
        self.crossesCountLabel.textColor = MUTED_TEXT_COLOR
        self.crossButton.setImageTintColor(MUTED_ICON_COLOR, forState: UIControlState.Normal)
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    self.groupNameLabel.textColor = MUTED_TEXT_COLOR
    self.checksCountLabel.textColor = MUTED_TEXT_COLOR
    self.checkButton.setImageTintColor(MUTED_ICON_COLOR, forState: UIControlState.Normal)
    self.crossesCountLabel.textColor = MUTED_TEXT_COLOR
    self.crossButton.setImageTintColor(MUTED_ICON_COLOR, forState: UIControlState.Normal)
  }

  func tappedCheckButton() {
    self.checked = true
  }

  func tappedCrossButton() {
    self.crossed = true
  }
}