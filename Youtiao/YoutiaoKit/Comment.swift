import Foundation

class Comment : MTLModel, MTLJSONSerializing {
  var id: String?
  var bulletinId: String?
  var text: String?
  var createdById: String?
  var createdBy: User?

  static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return [
      "id": "id",
      "bulletinId": "bulletin_id",
      "text": "text",
      "createdById": "created_by_id",
      "createdBy": "created_by"
    ]
  }

  static func createdByJSONTransformer() -> NSValueTransformer! {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(User.self)
  }
}
