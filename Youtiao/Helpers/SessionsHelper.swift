//
//  SessionsHelper.swift
//  Youtiao
//
//  Created by Feng Ye on 6/25/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation


class SessionsHelper {

  static func signOut() {
    let signInStoryBoard = UIStoryboard(name: "Landing", bundle: nil)
    UIApplication.sharedApplication().delegate?.window??.rootViewController = signInStoryBoard.instantiateInitialViewController() as? UIViewController
  }
}
