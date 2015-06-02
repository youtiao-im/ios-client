#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class MembershipViewModel, FeedViewModel;

@interface AuthenticatedUserViewModel : NSObject

@property (nonatomic, readonly) RACCommand *fetchFeedsCommand;
@property (nonatomic, readonly) RACCommand *fetchMembershipsCommand;

- (NSInteger)numberOfFeeds;
- (FeedViewModel *)feedViewModelAtIndex:(NSInteger)index;

- (NSInteger)numberOfMemberships;
- (MembershipViewModel *)membershipViewModelAtIndex:(NSInteger)index;

@end
