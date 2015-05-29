#import "ChannelsViewModel.h"

#import "ChannelViewModel.h"

@interface ChannelsViewModel ()

@property (nonatomic, strong) NSArray *memberships;

- (RACSignal *)fetchChannelsSignal;

@end

@implementation ChannelsViewModel

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _fetchChannelsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchChannelsSignal];
  }];

  return self;
}

- (NSInteger)numberOfChannels {
  return self.memberships == nil ? 0 : self.memberships.count;
}

- (ChannelViewModel *)channelViewModelAtIndex:(NSInteger)index {
  ChannelViewModel *channelViewModel = [[ChannelViewModel alloc] init];
  channelViewModel.membership = [self.memberships objectAtIndex:index];
  return channelViewModel;
}

- (RACSignal *)fetchChannelsSignal {
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
