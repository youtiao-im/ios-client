#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"

@class ChannelViewModel;

@interface ChannelsViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *fetchChannelsCommand;

- (NSInteger)numberOfChannels;
- (ChannelViewModel *)channelViewModelAtIndex:(NSInteger)index;

@end
