#import "ChannelViewModel.h"

#import "FeedViewModel.h"
#import "MembershipViewModel.h"

@interface ChannelViewModel ()

@property (nonatomic, strong) YTChannel *channel;
@property (nonatomic, strong) NSArray *feeds;
@property (nonatomic, strong) NSArray *memberships;

@end

@implementation ChannelViewModel

- (id)initWithChannel:(YTChannel *)channel {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _channel = channel;

  _fetchFeedsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchFeedsSignal];
  }];
  _fetchMembershipsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchMembershipsSignal];
  }];

  return self;
}

- (NSString *)name {
  return self.channel.name;
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
    [[[YTAPIContext sharedInstance] apiClient] fetchFeedsOfChannel:self.channel.identifier success:^(NSArray *feeds) {
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
    [[[YTAPIContext sharedInstance] apiClient] fetchMembershipsOfChannel:self.channel.identifier success:^(NSArray *memberships) {
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
