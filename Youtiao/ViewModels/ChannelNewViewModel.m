#import "ChannelNewViewModel.h"

#import "ChannelViewModel.h"

@interface ChannelNewViewModel ()

@property (nonatomic, strong) YTChannel *createdChannel;

@end

@implementation ChannelNewViewModel

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  RACSignal *nameValidSignal = [[RACObserve(self, name) map:^id(NSString *name) {
    return @(name.length > 3);
  }] distinctUntilChanged];

  _createChannelCommand = [[RACCommand alloc] initWithEnabled:nameValidSignal signalBlock:^RACSignal *(id input) {
    return [self createChannelSignal];
  }];

  return self;
}

- (ChannelViewModel *)createdChannelViewModel {
  if (self.createdChannel == nil) {
    return nil;
  }
  return [[ChannelViewModel alloc] initWithChannel:self.createdChannel];
}

- (RACSignal *)createChannelSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    YTChannel *newChannel = [[YTChannel alloc] initWithName:self.name];
    [[[YTAPIContext sharedInstance] apiClient] createChannel:newChannel success:^(YTChannel *channel) {
      @strongify(self);
      self.createdChannel = channel;
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
