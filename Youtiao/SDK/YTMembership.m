#import "YTMembership.h"
#import "YTUser.h"


@implementation YTMembership

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"role": @"role",
           @"user": @"user"};
}

+ (NSValueTransformer *)userJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTUser class]];
}

@end
