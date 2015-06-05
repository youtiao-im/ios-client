#import "YTFeed.h"
#import "YTChannel.h"
#import "YTUser.h"
#import "YTMark.h"


@implementation YTFeed

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"text": @"text",
           @"checksCount": @"checks_count",
           @"crossesCount": @"crosses_count",
           @"commentsCount": @"comments_count",
           @"channel": @"channel",
           @"createdBy": @"created_by",
           @"mark": @"mark"};
}

+ (NSValueTransformer *)channelJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTChannel class]];
}

+ (NSValueTransformer *)createdByJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTUser class]];
}

+ (NSValueTransformer *)markJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTMark class]];
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
