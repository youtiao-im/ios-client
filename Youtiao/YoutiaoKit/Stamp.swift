import Foundation

class Stamp : MTLModel, MTLJSONSerializing {
  var id: String?
  var bulletinId: String?
  var symbol: String?
  var createdById: String?
  var createdBy: User?
  var createdAt: NSNumber?

  static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return [
      "id": "id",
      "bulletinId": "bulletin_id",
      "symbol": "symbol",
      "createdById": "created_by_id",
      "createdBy": "created_by",
      "createdAt": "created_at"
    ]
  }

  static func createdByJSONTransformer() -> NSValueTransformer! {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(User.self)
  }
}
