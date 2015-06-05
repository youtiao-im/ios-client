#import "YTChannel.h"
#import "YTUser.h"
#import "YTMembership.h"


@implementation YTChannel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"name": @"name",
           @"createdBy": @"created_by",
           @"membership": @"membership" };
}

+ (NSValueTransformer *)createdByJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTUser class]];
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
