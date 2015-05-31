#import "YTFeed.h"

#import "YTUser.h"

@implementation YTFeed

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"text": @"text",
           @"createdBy": @"created_by"};
}

+ (NSValueTransformer *)createdByJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTUser class]];
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
