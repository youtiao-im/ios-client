#import "AuthenticatedUserViewModel.h"
#import "FeedViewModel.h"
#import "MembershipViewModel.h"


@interface AuthenticatedUserViewModel ()

@property (nonatomic) NSArray *feeds;
@property (nonatomic) NSArray *memberships;

@end


@implementation AuthenticatedUserViewModel

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _fetchFeedsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchFeedsSignal];
  }];
  _fetchMembershipsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchMembershipsSignal];
  }];

  return self;
}

- (NSInteger)numberOfFeeds {
  return self.feeds == nil ? 0 : self.feeds.count;
}

- (FeedViewModel *)feedViewModelAtIndex:(NSInteger)index {
  YTFeed *feed = [self.feeds objectAtIndex:index];
  return [[FeedViewModel alloc] initWithFeed:feed];
}

- (RACSignal *)fetchFeedsSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[YTAPIContext sharedInstance].apiClient fetchFeedsOfAuthenticatedUserWithSuccess:^(NSArray *feeds) {
      @strongify(self);
      self.feeds = feeds;
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
    [[YTAPIContext sharedInstance].apiClient fetchMembershipsOfAuthenticatedUserWithSuccess:^(NSArray *memberships) {
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
