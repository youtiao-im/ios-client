#import "YTFeed.h"

@implementation YTFeed

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"text": @"text",
           @"createdBy": @"created_by"};
}

@end
