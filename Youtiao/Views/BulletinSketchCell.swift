import UIKit

class BulletinSketchCell: UITableViewCell {
  @IBOutlet weak var groupNameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var textContentSketchLabel: UILabel!
  @IBOutlet weak var readFlagImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

}
