//
//  Blob.swift
//  Youtiao
//
//  Created by Feng Ye on 6/18/15.
//  Copyright (c) 2015 youtiao.im. All rights reserved.
//

import Foundation

class Blob : MTLModel, MTLJSONSerializing {

  var id: String?
  var dataURLString: String?

  var dataURL: NSURL? {
    get {
      if (self.dataURLString != nil) {
        return NSURL(string: self.dataURLString!)
      } else {
        return nil
      }
    }
  }

  static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return [
      "id": "id",
      "dataURLString": "data_url"
    ]
  }
}
