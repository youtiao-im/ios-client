#import "YTGroup.h"
#import "YTUser.h"
#import "YTMembership.h"


@implementation YTGroup

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"name": @"name",
           @"membershipsCount": @"memberships_count",
           @"membership": @"membership" };
}

+ (NSValueTransformer *)membershipByJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTMembership class]];
}

- (id)initWithName:(NSString *)name {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _name = name;

  return self;
}

@end
