#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class YTUser;

@interface YTMark : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *symbol;
@property (nonatomic, readonly) YTUser *user;

- (id)initWithSymbol:(NSString *)symbol;

@end
