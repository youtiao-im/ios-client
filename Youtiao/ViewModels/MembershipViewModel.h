#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class UserViewModel;

@interface MembershipViewModel : NSObject

- (id)initWithMembership:(YTMembership *)membership;

- (UserViewModel *)userViewModel;

@end
