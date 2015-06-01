#import "ChannelNewViewModel.h"
#import "ChannelViewModel.h"


@interface ChannelNewViewModel ()

@end


@implementation ChannelNewViewModel

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  RACSignal *nameValidSignal = [[RACObserve(self, name) map:^id(NSString *name) {
    return @(name.length >= 2);
  }] distinctUntilChanged];

  _createChannelCommand = [[RACCommand alloc] initWithEnabled:nameValidSignal signalBlock:^RACSignal *(id input) {
    return [self createChannelSignal];
  }];

  return self;
}

- (RACSignal *)createChannelSignal {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    YTChannel *newChannel = [[YTChannel alloc] initWithName:self.name];
    [[YTAPIContext sharedInstance].apiClient createChannel:newChannel success:^(YTChannel *channel) {
      [subscriber sendNext:[[ChannelViewModel alloc] initWithChannel:channel]];
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
