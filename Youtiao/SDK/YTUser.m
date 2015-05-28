#import "YTUser.h"

@implementation YTUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"email": @"email"};
}

@end
