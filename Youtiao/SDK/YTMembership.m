#import "YTMembership.h"

@implementation YTMembership

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"role": @"role",
           @"channel": @"channel",
           @"user": @"user"};
}

@end
