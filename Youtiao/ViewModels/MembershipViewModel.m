#import "MembershipViewModel.h"
#import "UserViewModel.h"


@interface MembershipViewModel ()

@property (nonatomic) YTMembership *membership;

@end


@implementation MembershipViewModel

- (id)initWithMembership:(YTMembership *)membership {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _membership = membership;

  return self;
}

- (UserViewModel *)userViewModel {
  return [[UserViewModel alloc] initWithUser:self.membership.user];
}

@end
