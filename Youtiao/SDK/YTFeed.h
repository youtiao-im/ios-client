#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class YTChannel, YTUser, YTMark;

@interface YTFeed : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSInteger checksCount;
@property (nonatomic, readonly) NSInteger crossesCount;
@property (nonatomic, readonly) NSInteger commentsCount;
@property (nonatomic, readonly) YTChannel *channel;
@property (nonatomic, readonly) YTUser *createdBy;
@property (nonatomic, readonly) YTMark *mark;

- (id)initWithText:(NSString *)text;

@end
