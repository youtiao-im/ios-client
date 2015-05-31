#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"

@class FeedViewModel;

@interface FeedNewViewModel : NSObject

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong, readonly) RACCommand *createFeedCommand;

- (id)initWithChannel:(YTChannel *)channel;

- (FeedViewModel *)createdFeedViewModel;

@end
