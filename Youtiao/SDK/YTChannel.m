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

- (id)initWithName:(NSString *)name {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _name = name;

  return self;
}

@end
