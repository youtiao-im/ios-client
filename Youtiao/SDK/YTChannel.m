#import "YTChannel.h"

#import "YTUser.h"

@implementation YTChannel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"name": @"name",
           @"createdBy": @"created_by"};
}

+ (NSValueTransformer *)createdByJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTUser class]];
}

@end
