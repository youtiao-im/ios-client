#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class YTChannel, YTUser;

@interface YTMembership : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *role;
@property (nonatomic, readonly) YTChannel *channel;
@property (nonatomic, readonly) YTUser *user;

@end
