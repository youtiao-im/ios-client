#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class YTFeed;
@class YTUser;

@interface YTComment : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) YTFeed *feed;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) YTUser *createdBy;

@end
