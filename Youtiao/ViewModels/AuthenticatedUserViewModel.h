#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class FeedViewModel, ChannelViewModel;

@interface AuthenticatedUserViewModel : NSObject

@property (nonatomic, readonly) RACCommand *fetchFeedsCommand;
@property (nonatomic, readonly) RACCommand *fetchChannelsCommand;

- (NSInteger)numberOfFeeds;
- (FeedViewModel *)feedViewModelAtIndex:(NSInteger)index;

- (NSInteger)numberOfChannels;
- (ChannelViewModel *)channelViewModelAtIndex:(NSInteger)index;

@end
