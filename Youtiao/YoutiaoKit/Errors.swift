//
//  Error.swift
//  Youtiao
//
//  Created by Feng Ye on 6/25/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class YoutiaoError: NSError {
}

class UnauthorizedError: YoutiaoError {
}

class ForbiddenError: YoutiaoError {
}

class NotFoundError: YoutiaoError {
}

enum UnprocessableEntityErrorReason {
  case TooLong, TooShort, Blank, Invalid, Taken
}

class UnprocessableEntityError: YoutiaoError {
  var attributeName: String!
  var reason: UnprocessableEntityErrorReason!

  static func fromErrorString(errorString: String) -> UnprocessableEntityError {
    let components = errorString.componentsSeparatedByString(":")
    let error = UnprocessableEntityError()
    error.attributeName = components[0]
    switch components[1] {
    case "too_long":
      error.reason = UnprocessableEntityErrorReason.TooLong
    case "too_short":
      error.reason = UnprocessableEntityErrorReason.TooShort
    case "blank":
      error.reason = UnprocessableEntityErrorReason.Blank
    case "taken":
      error.reason = UnprocessableEntityErrorReason.Taken
    default:
      error.reason = UnprocessableEntityErrorReason.Invalid
    }
    return error
  }
}

class ServerError: YoutiaoError {
}

class OperationCancelledError: YoutiaoError {
}

class NetworkError: YoutiaoError {
  override init(domain: String, code: Int, userInfo dict: [NSObject : AnyObject]?) {
    super.init(domain: domain, code: code, userInfo: dict)
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
