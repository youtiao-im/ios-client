#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class YTChannel;
@class YTUser;

@interface YTMembership : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *role;
@property (nonatomic, strong, readonly) YTChannel *channel;
@property (nonatomic, strong, readonly) YTUser *user;

@end
