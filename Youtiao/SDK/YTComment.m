#import "YTComment.h"

#import "YTUser.h"

@implementation YTComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"text": @"text",
           @"createdBy": @"created_by"};
}

+ (NSValueTransformer *)createdByJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTUser class]];
}

@end
