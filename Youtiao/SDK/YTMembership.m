#import "YTMembership.h"

#import "YTChannel.h"
#import "YTUser.h"

@implementation YTMembership

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"role": @"role",
           @"channel": @"channel",
           @"user": @"user"};
}

+ (NSValueTransformer *)channelJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTChannel class]];
}

+ (NSValueTransformer *)userJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTUser class]];
}

@end
