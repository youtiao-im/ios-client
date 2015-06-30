//
//  Group.swift
//  Youtiao
//
//  Created by Feng Ye on 6/17/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class Group : MTLModel, MTLJSONSerializing {

  var id: String?
  var name: String?
  var code: String?
  var membershipsCount: NSNumber?
  var currentMembership: Membership?

  static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return [
      "id": "id",
      "name": "name",
      "code": "code",
      "membershipsCount": "memberships_count",
      "currentMembership": "current_membership"
    ]
  }

  static func currentMembershipJSONTransformer() -> NSValueTransformer! {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(Membership.self)
  }
}
