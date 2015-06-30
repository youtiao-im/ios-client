//
//  Membership.swift
//  Youtiao
//
//  Created by Feng Ye on 6/17/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class Membership : MTLModel, MTLJSONSerializing {

  var id: String?
  var groupId: String?
  var userId: String?
  var role: String?
  var user: User?

  static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return [
      "id": "id",
      "groupId": "group_id",
      "userId": "user_id",
      "role": "role",
      "user": "user"
    ]
  }

  static func userJSONTransformer() -> NSValueTransformer! {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(User.self)
  }
}
