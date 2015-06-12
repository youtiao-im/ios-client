#import "YTMembership.h"
#import "YTGroup.h"
#import "YTUser.h"


@implementation YTMembership

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"groupId": @"group_id",
           @"userId": @"user_id",
           @"role": @"role",
           @"alias": @"alias",
           @"group": @"group",
           @"user": @"user"};
}

+ (NSValueTransformer *)groupJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTGroup class]];
}

+ (NSValueTransformer *)userJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTUser class]];
}

@end
