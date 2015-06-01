#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class FeedViewModel, MembershipViewModel, FeedNewViewModel;

@interface ChannelViewModel : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) RACCommand *fetchFeedsCommand;
@property (nonatomic, readonly) RACCommand *fetchMembershipsCommand;

- (id)initWithChannel:(YTChannel *)channel;

- (NSInteger)numberOfFeeds;
- (FeedViewModel *)feedViewModelAtIndex:(NSInteger)index;

- (NSInteger)numberOfMemberships;
- (MembershipViewModel *)membershipViewModelAtIndex:(NSInteger)index;

- (FeedNewViewModel *)feedNewViewModel;

@end
