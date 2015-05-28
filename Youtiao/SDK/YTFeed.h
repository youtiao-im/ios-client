#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class YTChannel;
@class YTUser;

@interface YTFeed : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) YTChannel *channel;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) YTUser *createdBy;

@end
