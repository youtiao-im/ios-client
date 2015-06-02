#import "YTFeed.h"
#import "YTChannel.h"
#import "YTUser.h"


@implementation YTFeed

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"text": @"text",
           @"channel": @"channel",
           @"createdBy": @"created_by"};
}

+ (NSValueTransformer *)channelJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTChannel class]];
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
