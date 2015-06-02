#import "YTUser.h"


@implementation YTUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"email": @"email"};
}

- (NSString *)name {
  return [[self.email componentsSeparatedByString:@"@"] objectAtIndex:0];
}

@end
