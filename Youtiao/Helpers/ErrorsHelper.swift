//
//  ErrorsHelper.swift
//  Youtiao
//
//  Created by Feng Ye on 6/30/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class ErrorsHelper: NSObject {
  static func handleCommonErrors(error: NSError) {
    if error is UnauthorizedError {
      SessionsHelper.signOut()
    } else if error is OperationCancelledError {
      return
    } else if error is NetworkError {
      let errorTitle = NSLocalizedString("Network Error", comment: "Network Error")
      let errorMessage = error.localizedDescription
      RKDropdownAlert.title(errorTitle, message: errorMessage, backgroundColor: UIColor.flatOrangeColorDark(), textColor: UIColor.whiteColor())
    } else if error is ServerError {
      RKDropdownAlert.title(NSLocalizedString("Server Error", comment: "Server Error"), message: NSLocalizedString("Please try again later.", comment: "Please try again later."), backgroundColor: UIColor.flatOrangeColorDark(), textColor: UIColor.whiteColor())
    } else {
      RKDropdownAlert.title(NSLocalizedString("Unknown Error", comment: "Unknown Error"), message: NSLocalizedString("Please try again later.", comment: "Please try again later."), backgroundColor: UIColor.flatRedColorDark(), textColor: UIColor.whiteColor())
    }
  }
  
  static func errorMessageForError(error: NSError) -> String {
    if error is UnauthorizedError {
      return NSLocalizedString("Unauthorized", comment: "Unauthorized")
    } else if error is ForbiddenError {
      return NSLocalizedString("Forbidden", comment: "Forbidden")
    } else if error is NotFoundError {
      return NSLocalizedString("Target item not exist", comment: "Target item not exist")
    } else if error is ServerError {
      return NSLocalizedString("Server error encountered", comment: "Server error encountered")
    } else if error is UnprocessableEntityError {
      let theError = error as! UnprocessableEntityError
      var errorMsg: String
      let theErrorReason: UnprocessableEntityErrorReason = theError.reason
      switch theErrorReason {
        case .TooLong:
          errorMsg = theError.attributeName + NSLocalizedString(" too long", comment: " too long")
        case .TooShort:
          errorMsg = theError.attributeName + NSLocalizedString(" too short", comment: " too short")
        case .Blank:
          errorMsg = theError.attributeName + NSLocalizedString(" is blank", comment: " is blank")
        case .Taken:
          errorMsg = theError.attributeName + NSLocalizedString(" is taken", comment: " is taken")
        default:
          errorMsg = theError.attributeName + NSLocalizedString(" is invalid", comment: " is invalid")
      }
      return errorMsg
    } else if error is NetworkError {
      return error.localizedDescription
    } else if error is OperationCancelledError {
      return NSLocalizedString("Operation is cancelled", comment: "Operation is cancelled")
    } else {
      return NSLocalizedString("Unknown error encountered", comment: "Unknown error encountered")
    }
  }
}
