import UIKit

class BulletinStampButton: UIButton {
  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    var bounds = self.bounds
    let widthDelta = max(44.0 - bounds.size.width, 0)
    let heightDelta = max(44.0 - bounds.size.height, 0)
    bounds = CGRect(x: 0, y: 0, width: bounds.size.width + widthDelta, height: bounds.size.height + heightDelta)
    return CGRectContainsPoint(bounds, point)
  }
}

