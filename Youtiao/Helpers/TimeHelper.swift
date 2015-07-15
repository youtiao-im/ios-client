import Foundation

class TimeHelper {
  static let littleWhileInterval = 3.0
  static let displayDaysConstant = 10.0

  static func formattedTime(oriTime: Double) -> String {
    let timeIntervalSince1970 = NSDate().timeIntervalSince1970
    let timeIntervalFromOriTime = timeIntervalSince1970 - oriTime
    if timeIntervalFromOriTime <= 3.0 {
      return NSLocalizedString("just now", comment: "just now")
    } else if timeIntervalFromOriTime > 3.0 && timeIntervalFromOriTime < 60.0 {
      // Seconds
      let seconds = Int(timeIntervalFromOriTime)
      return "\(seconds)" + NSLocalizedString(" seconds ago", comment: " seconds ago")
    } else if timeIntervalFromOriTime >= 60.0 && timeIntervalFromOriTime < 60.0 * 60.0 {
      // Minutes
      let minutes = Int(timeIntervalFromOriTime / 60.0)
      return "\(minutes)" + NSLocalizedString(" minutes ago", comment: " minutes ago")
    } else if timeIntervalFromOriTime >= 60.0 * 60.0 && timeIntervalFromOriTime < 60.0 * 60.0 * 24 {
      // Hours
      let hours = Int(timeIntervalFromOriTime / (60.0 * 60.0))
      return "\(hours)" + NSLocalizedString(" hours ago", comment: " hours ago")
    } else if timeIntervalFromOriTime >= 60.0 * 60.0 * 24 && timeIntervalFromOriTime < 60.0 * 60.0 * 24 * displayDaysConstant {
      // Days
      let days = Int(timeIntervalFromOriTime / (60.0 * 60.0 * 24))
      return "\(days)" + NSLocalizedString(" days ago", comment: " days ago")
    } else if timeIntervalFromOriTime >= 60.0 * 60.0 * 24 * displayDaysConstant {
      let oriDate = NSDate(timeIntervalSince1970: oriTime)
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
      dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
      dateFormatter.locale = NSLocale(localeIdentifier: self.currentSystemLanguage())
      return dateFormatter.stringFromDate(oriDate)
    } else {
      let oriDate = NSDate(timeIntervalSince1970: oriTime)
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
      dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
      dateFormatter.locale = NSLocale(localeIdentifier: self.currentSystemLanguage())
      return dateFormatter.stringFromDate(oriDate)
    }
  }

  static func currentSystemLanguage() -> String! {
    var lang: String? = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages")?.objectAtIndex(0) as? String
    if lang != nil {
      if lang == "zh_Hans" || lang == "zh_Hant" {
        return "zh_CN"
      } else {
        return "en_US"
      }
    } else {
      return "en_US"
    }
  }
}
