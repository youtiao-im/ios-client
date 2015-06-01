#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class FeedViewModel;

@interface FeedNewViewModel : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic, readonly) RACCommand *createFeedCommand;

- (id)initWithChannel:(YTChannel *)channel;

@end
