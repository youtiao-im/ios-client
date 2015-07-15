import Foundation

class SessionsHelper {
  static func signOut() {
    for (key, value) in NSUserDefaults.standardUserDefaults().dictionaryRepresentation() {
      NSUserDefaults.standardUserDefaults().setValue(nil, forKey: key as! String)
    }
    NSUserDefaults.standardUserDefaults().synchronize()
    let oriRootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
    let signInStoryBoard = UIStoryboard(name: "Landing", bundle: nil)
    UIApplication.sharedApplication().delegate?.window??.rootViewController = signInStoryBoard.instantiateInitialViewController() as? UIViewController
    if ((oriRootViewController?.isKindOfClass(UITabBarController)) != nil) {
      var oriTabBar = oriRootViewController as? UITabBarController
      if oriTabBar != nil {
        for var i = 0; i < oriTabBar?.viewControllers?.count; i++ {
          let viewControllers: [AnyObject]! = oriTabBar?.viewControllers!
          let oneItem: AnyObject = viewControllers[i]
          if oneItem.isKindOfClass(UINavigationController) {
            let oneNavItem = oneItem as! UINavigationController
            oneNavItem.viewControllers = nil
          }
        }
      }
      oriTabBar?.viewControllers = nil
    }
  }
}
