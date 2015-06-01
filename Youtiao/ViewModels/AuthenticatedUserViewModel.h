#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class MembershipViewModel;

@interface AuthenticatedUserViewModel : NSObject

@property (nonatomic, readonly) RACCommand *fetchMembershipsCommand;

- (NSInteger)numberOfMemberships;
- (MembershipViewModel *)membershipViewModelAtIndex:(NSInteger)index;

@end
