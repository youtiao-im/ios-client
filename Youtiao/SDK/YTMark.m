#import "YTMark.h"
#import "YTUser.h"


@implementation YTMark

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"symbol": @"symbol",
           @"user": @"user"};
}

+ (NSValueTransformer *)userJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTUser class]];
}

- (id)initWithSymbol:(NSString *)symbol {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _symbol = symbol;

  return self;
}

@end
