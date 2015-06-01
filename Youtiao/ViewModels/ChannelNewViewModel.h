#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class ChannelViewModel;

@interface ChannelNewViewModel : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic, readonly) RACCommand *createChannelCommand;

@end
