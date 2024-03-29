import Foundation

class Bulletin : MTLModel, MTLJSONSerializing {
  var id: String?
  var groupId: String?
  var text: String?
  var createdById: String?
  var checksCount: NSNumber?
  var crossesCount: NSNumber?
  var eyesCount: NSNumber?
  var commentsCount: NSNumber?
  var group: Group?
  var createdBy: User?
  var currentStamp: Stamp?
  var createdAt: NSNumber?

  static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return [
      "id": "id",
      "groupId": "group_id",
      "text": "text",
      "createdById": "created_by_id",
      "checksCount": "checks_count",
      "crossesCount": "crosses_count",
      "eyesCount": "eyes_count",
      "commentsCount": "comments_count",
      "group": "group",
      "createdBy": "created_by",
      "currentStamp": "current_stamp",
      "createdAt": "created_at"
    ]
  }

  static func groupJSONTransformer() -> NSValueTransformer! {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(Group.self)
  }

  static func createdByJSONTransformer() -> NSValueTransformer! {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(User.self)
  }

  static func currentStampJSONTransformer() -> NSValueTransformer! {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(Stamp.self)
  }
}
