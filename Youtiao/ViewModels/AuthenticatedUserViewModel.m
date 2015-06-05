#import "AuthenticatedUserViewModel.h"
#import "FeedViewModel.h"
#import "ChannelViewModel.h"


@interface AuthenticatedUserViewModel ()

@property (nonatomic) NSArray *feeds;
@property (nonatomic) NSArray *channels;

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
  _fetchChannelsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchChannelsSignal];
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

- (NSInteger)numberOfChannels {
  return self.channels == nil ? 0 : self.channels.count;
}

- (ChannelViewModel *)channelViewModelAtIndex:(NSInteger)index {
  YTChannel *channel = [self.channels objectAtIndex:index];
  return [[ChannelViewModel alloc] initWithChannel:channel];
}

- (RACSignal *)fetchChannelsSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[YTAPIContext sharedInstance].apiClient fetchMemberedChannelsWithSuccess:^(NSArray *channels) {
      @strongify(self);
      self.channels = channels;
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
