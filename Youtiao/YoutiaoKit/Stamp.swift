//
//  Stamp.swift
//  Youtiao
//
//  Created by Feng Ye on 6/17/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class Stamp : MTLModel, MTLJSONSerializing {

  var id: String?
  var bulletinId: String?
  var symbol: String?
  var createdById: String?
  var createdBy: User?

  static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return [
      "id": "id",
      "bulletinId": "bulletin_id",
      "symbol": "symbol",
      "createdById": "created_by_id",
      "createdBy": "created_by"
    ]
  }

  static func createdByJSONTransformer() -> NSValueTransformer! {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(User.self)
  }
}
