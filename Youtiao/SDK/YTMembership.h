#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class YTUser;

@interface YTMembership : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *role;
@property (nonatomic, readonly) YTUser *user;

@end
