//
//  User.swift
//  Youtiao
//
//  Created by Feng Ye on 6/17/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class User : MTLModel, MTLJSONSerializing {

  var id: String?
  var email: String?
  var name: String?
  var avatar: Blob?

  static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return [
      "id": "id",
      "email": "email",
      "name": "name",
      "avatar": "avatar"
    ]
  }

  static func avatarJSONTransformer() -> NSValueTransformer! {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(Blob.self)
  }
}
