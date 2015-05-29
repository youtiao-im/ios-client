#import "UserViewModel.h"

@interface UserViewModel ()

@property (nonatomic, strong) YTUser *user;

@end

@implementation UserViewModel

- (id)initWithUser:(YTUser *)user {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _user = user;

  return self;
}

- (NSString *)email {
  return self.user.email;
}

@end
