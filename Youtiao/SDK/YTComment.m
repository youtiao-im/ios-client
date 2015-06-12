#import "YTComment.h"
#import "YTBulletin.h"
#import "YTMembership.h"


@implementation YTComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"bulletinId": @"bulletin_id",
           @"text": @"text",
           @"createdByType": @"created_by_type",
           @"createdById": @"created_by_id",
           @"bulletin": @"bulletin",
           @"createdBy": @"created_by"};
}

+ (NSValueTransformer *)bulletinJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTBulletin class]];
}

+ (NSValueTransformer *)createdByJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTMembership class]];
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
