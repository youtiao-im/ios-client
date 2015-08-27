import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.

    MobClick.startWithAppkey("55adf7b467e58ec60a001538", reportPolicy: BATCH, channelId: nil)

    UINavigationBar.appearance().barStyle = UIBarStyle.Black
    UINavigationBar.appearance().barTintColor = BRAND_COLOR
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

    UITabBar.appearance().tintColor = BRAND_COLOR

    UITableView.appearance().backgroundColor = BACKGROUND_COLOR

    self.window?.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal

    var storyBoard: UIStoryboard?
    APIClient.sharedInstance.accessToken = NSUserDefaults.standardUserDefaults().valueForKey("token") as? String
    if (APIClient.sharedInstance.accessToken == nil) {
      storyBoard = UIStoryboard(name: "Landing", bundle: nil)
    } else {
      storyBoard = UIStoryboard(name: "Main", bundle: nil)
    }

    self.window?.rootViewController = storyBoard?.instantiateInitialViewController() as? UIViewController
    if NSString(string: UIDevice.currentDevice().systemVersion).floatValue >= 8.0 {
      UINavigationBar.appearance().translucent = false
      UITabBar.appearance().translucent = false
    } else {
      if self.window?.rootViewController?.isKindOfClass(NSClassFromString("UITabBarController")) == true {
        let tabBarController = self.window?.rootViewController as! UITabBarController
        tabBarController.tabBar.translucent = false
      }
    }
    self.window?.makeKeyAndVisible()

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleLoadUserInfoSuccessNotification:"), name: "loadUserInfoSuccessNotification", object: nil)
    APService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Sound.rawValue | UIUserNotificationType.Alert.rawValue, categories: nil)
    APService.setupWithOption(launchOptions)

    let userDefaultsInfo = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
    let currentUser = userDefaultsInfo["user"] as? [String : AnyObject]
    let userId = currentUser?["id"] as! String?
    if userId != nil {
      self.bindsAliasWithUserId(userId!)
    }

    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    self.setBulletinTabItemBadge(application.applicationIconBadgeNumber)
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSNotificationCenter.defaultCenter().removeObserver(self, name: "loadUserInfoSuccessNotification", object: nil)
  }

  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    APService.registerDeviceToken(deviceToken)
  }

  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
  }

  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    APService.handleRemoteNotification(userInfo)
    completionHandler(UIBackgroundFetchResult.NewData)
    let aps = userInfo["aps" as NSObject] as! NSDictionary
    let badgeCount = aps.objectForKey("badge")?.integerValue
    let content = aps.valueForKey("alert") as! String
    let sound: AnyObject? = aps.valueForKey("sound")
    if application.applicationState == UIApplicationState.Active {
      application.applicationIconBadgeNumber = badgeCount!
      self.setBulletinTabItemBadge(badgeCount!)
    } else {
      self.setBulletinTabItemBadge(application.applicationIconBadgeNumber)
    }
  }

  func bindsAliasWithUserId(userId: String) {
    APService.setAlias(userId, callbackSelector: Selector("tagsAliasCallback:tags:alias:"), object: self)
  }

  func tagsAliasCallback(iRescode: Int32, tags: NSSet?, alias: String) {
  }

  func handleLoadUserInfoSuccessNotification(notification: NSNotification) {
    let userObj: User? = notification.userInfo?["user" as NSObject] as! User?
    if let userId = userObj?.id {
      self.bindsAliasWithUserId(userId)
    }
  }

  func setBulletinTabItemBadge(value: Int){
    let rootViewController = self.window?.rootViewController
    if (rootViewController?.isKindOfClass(NSClassFromString("UITabBarController")) == true) {
      let tabBarController = rootViewController as! UITabBarController
      let tabBar = tabBarController.tabBar
      if let firstItem = tabBar.items?[0] as? UITabBarItem {
        if value <= 0 {
          firstItem.badgeValue = nil
        } else if value >= 100 {
          firstItem.badgeValue = "99+"
        } else {
          firstItem.badgeValue = String(value)
        }
      }
    }
  }

  func resetBulletinTabItemBadge() {
    let rootViewController = self.window?.rootViewController
    if rootViewController?.isKindOfClass(NSClassFromString("UITabBarController")) != nil {
      let tabBarController = rootViewController as! UITabBarController
      let tabBar = tabBarController.tabBar
      if let firstItem = tabBar.items?[0] as? UITabBarItem {
        firstItem.badgeValue = nil
      }
    }
  }

  func resetApplicationIconBadge() {
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
  }

  func resetBadgeValueOnServer() {
    APService.resetBadge()
  }
}
