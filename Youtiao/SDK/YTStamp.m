#import "YTStamp.h"
#import "YTBulletin.h"
#import "YTMembership.h"


@implementation YTStamp

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"identifier": @"id",
           @"bulletinId": @"bulletin_id",
           @"symbol": @"symbol",
           @"createdByType": @"created_by_type",
           @"createdById": @"created_by_id",
           @"createdBy": @"created_by"};
}

+ (NSValueTransformer *)bulletinJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTBulletin class]];
}

+ (NSValueTransformer *)createdByJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YTMembership class]];
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
