#import "YTChannel.h"

@implementation YTChannel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"name": @"name",
           @"createdBy": @"created_by"};
}

@end
