#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"

@class ChannelViewModel;

@interface ChannelNewViewModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong, readonly) RACCommand *createChannelCommand;

- (ChannelViewModel *)createdChannelViewModel;

@end
