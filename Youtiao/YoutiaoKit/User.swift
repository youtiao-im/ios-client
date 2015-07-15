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
