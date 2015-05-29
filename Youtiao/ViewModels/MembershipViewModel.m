#import "MembershipViewModel.h"

#import "ChannelViewModel.h"
#import "UserViewModel.h"

@interface MembershipViewModel ()

@property (nonatomic, strong) YTMembership *membership;

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

- (ChannelViewModel *)channelViewModel {
  return [[ChannelViewModel alloc] initWithChannel:self.membership.channel];
}

- (UserViewModel *)userViewModel {
  return [[UserViewModel alloc] initWithUser:self.membership.user];
}

@end
