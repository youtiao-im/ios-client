import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.

    MobClick.startWithAppkey("55adf7b467e58ec60a001538", reportPolicy: BATCH, channelId: nil)
    MobClick.setLogEnabled(true)

    let remoteNotification: AnyObject? = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]
    if remoteNotification != nil {
      println("Launch this app by remote notification")
    }

    UINavigationBar.appearance().barStyle = UIBarStyle.Black
    UINavigationBar.appearance().barTintColor = BRAND_COLOR
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UINavigationBar.appearance().translucent = false

    UITabBar.appearance().tintColor = BRAND_COLOR
    UITabBar.appearance().translucent = false

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
    self.window?.makeKeyAndVisible()

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleLoadUserInfoSuccessNotification:"), name: "loadUserInfoSuccessNotification", object: nil)
    APService.setDebugMode()
    APService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Sound.rawValue | UIUserNotificationType.Alert.rawValue, categories: nil)
    APService.setupWithOption(launchOptions)

    let userDefaultsInfo = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
    let userId = userDefaultsInfo["user_id"] as! String?
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
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSNotificationCenter.defaultCenter().removeObserver(self, name: "loadUserInfoSuccessNotification", object: nil)
  }

  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    println("\n\tdevice Token: \(deviceToken)")
    APService.registerDeviceToken(deviceToken)
  }

  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    println("\n\tFailed to register for remote notification with error: \(error)")
  }

  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    APService.handleRemoteNotification(userInfo)
    let aps = userInfo["aps" as NSObject] as! NSDictionary
    let badgeCount = aps.objectForKey("badge")?.integerValue
    let content = aps.valueForKey("alert") as! String
    let sound: AnyObject? = aps.valueForKey("sound")
    println("content: \(content), badgeCount: \(badgeCount)")
    if badgeCount > 0 {
      UIApplication.sharedApplication().applicationIconBadgeNumber += badgeCount!
      self.setBulletinTabItemBadgeWithIncrementValue(badgeCount!)
    }
  }

  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    APService.handleRemoteNotification(userInfo)
    completionHandler(UIBackgroundFetchResult.NewData)
    println("iOS7 Remote Notification here")
    let aps = userInfo["aps" as NSObject] as! NSDictionary
    let badgeCount = aps.objectForKey("badge")?.integerValue
    let content = aps.valueForKey("alert") as! String
    let sound: AnyObject? = aps.valueForKey("sound")
    println("content: \(content), badgeCount: \(badgeCount)")
    if badgeCount > 0 {
      UIApplication.sharedApplication().applicationIconBadgeNumber += badgeCount!
      self.setBulletinTabItemBadgeWithIncrementValue(badgeCount!)
    }
  }

  func bindsAliasWithUserId(userId: String) {
    APService.setAlias(userId, callbackSelector: Selector("tagsAliasCallback:tags:alias:"), object: self)
  }

  func tagsAliasCallback(iRescode: Int32, tags: NSSet?, alias: String) {
    println("rescode: \(iRescode), tags: \(tags?.description), alias: \(alias)")
  }

  func handleLoadUserInfoSuccessNotification(notification: NSNotification) {
    let userObj: User? = notification.userInfo?["user" as NSObject] as! User?
    if let userId = userObj?.id {
      self.bindsAliasWithUserId(userId)
    }
  }

  func setBulletinTabItemBadgeWithIncrementValue(increment: Int) {
    let rootViewController = self.window?.rootViewController
    if (rootViewController?.isKindOfClass(NSClassFromString("UITabBarController")) != nil) {
      let tabBarController = rootViewController as! UITabBarController
      let tabBar = tabBarController.tabBar
      if let firstItem = tabBar.items?[0] as? UITabBarItem {
        let originalBadgeValue = firstItem.badgeValue
        var newBadgeCount: Int? = (originalBadgeValue == nil) ? 0 : originalBadgeValue?.toInt()
        if increment > 0 {
          if newBadgeCount != nil {
            newBadgeCount! += increment
          } else {
            newBadgeCount = increment
          }
        }
        var newBadgeValue: String?
        if newBadgeCount <= 0 {
          newBadgeValue = nil
        } else {
          if newBadgeCount >= 100 {
            newBadgeValue = "99+"
          } else {
            if newBadgeCount != nil {
              newBadgeValue = String(newBadgeCount!)
            } else {
              newBadgeValue = nil
            }
          }
        }
        firstItem.badgeValue = newBadgeValue
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
}
