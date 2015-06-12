#import "YTBulletin.h"
#import "YTGroup.h"
#import "YTMembership.h"
#import "YTStamp.h"


@implementation YTBulletin

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"groupId": @"group_id",
           @"text": @"text",
           @"createdByType": @"created_by_type",
           @"createdById": @"created_by_id",
           @"checksCount": @"checks_count",
           @"crossesCount": @"crosses_count",
           @"commentsCount": @"comments_count",
           @"group": @"group",
           @"createdBy": @"created_by",
           @"stamp": @"stamp"};
}

+ (NSValueTransformer *)groupJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTGroup class]];
}

+ (NSValueTransformer *)createdByJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTMembership class]];
}

+ (NSValueTransformer *)stampJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTStamp class]];
}

- (id)initWithText:(NSString *)text {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _text = text;

  return self;
}

@end
