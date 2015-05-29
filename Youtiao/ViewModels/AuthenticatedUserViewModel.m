#import "AuthenticatedUserViewModel.h"

#import "MembershipViewModel.h"

@interface AuthenticatedUserViewModel ()

@property (nonatomic, strong) NSArray *memberships;

@end

@implementation AuthenticatedUserViewModel

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _fetchMembershipsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchMembershipsSignal];
  }];

  return self;
}

- (NSInteger)numberOfMemberships {
  return self.memberships == nil ? 0 : self.memberships.count;
}

- (MembershipViewModel *)membershipViewModelAtIndex:(NSInteger)index {
  YTMembership *membership = [self.memberships objectAtIndex:index];
  return [[MembershipViewModel alloc] initWithMembership:membership];
}

- (RACSignal *)fetchMembershipsSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[[YTAPIContext sharedInstance] apiClient] fetchMembershipsOfAuthenticatedUserWithSuccess:^(NSArray *memberships) {
      @strongify(self);
      self.memberships = memberships;
      [subscriber sendNext:nil];
      [subscriber sendCompleted];
    } failure:^(NSError *error) {
      [subscriber sendError:error];
      [subscriber sendCompleted];
    }];

    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

@end
