#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"

@class ChannelViewModel, UserViewModel;

@interface MembershipViewModel : NSObject

- (id)initWithMembership:(YTMembership *)membership;

- (ChannelViewModel *)channelViewModel;
- (UserViewModel *)userViewModel;

@end
