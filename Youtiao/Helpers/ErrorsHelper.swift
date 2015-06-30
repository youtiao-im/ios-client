//
//  ErrorsHelper.swift
//  Youtiao
//
//  Created by Feng Ye on 6/30/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class ErrorsHelper: NSObject {

  // TODO:
  static func handleCommonErrors(error: NSError) {
    if error is UnauthorizedError {
      SessionsHelper.signOut()
    } else if error is ServerError {
      RKDropdownAlert.title("Server Error", message: "Please try again later.", backgroundColor: UIColor.flatOrangeColorDark(), textColor: UIColor.whiteColor())
    } else {
      RKDropdownAlert.title("Unknown Error", message: "Please try again later.", backgroundColor: UIColor.flatRedColorDark(), textColor: UIColor.whiteColor())
    }
  }
}
