#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class YTChannel;
@class YTUser;

@interface YTFeed : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) YTChannel *channel;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) YTUser *createdBy;

@end
