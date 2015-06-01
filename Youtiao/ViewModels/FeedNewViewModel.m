#import "FeedNewViewModel.h"
#import "FeedViewModel.h"


@interface FeedNewViewModel ()

@property (nonatomic) YTChannel *channel;
@property (nonatomic) YTFeed *createdFeed;

@end


@implementation FeedNewViewModel

- (id)initWithChannel:(YTChannel *)channel {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _channel = channel;

  RACSignal *textValidSignal = [[RACObserve(self, text) map:^id(NSString *text) {
    return @(text.length > 0);
  }] distinctUntilChanged];

  _createFeedCommand = [[RACCommand alloc] initWithEnabled:textValidSignal signalBlock:^RACSignal *(id input) {
    return [self createFeedSignal];
  }];

  return self;
}

- (RACSignal *)createFeedSignal {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    YTFeed *newFeed = [[YTFeed alloc] initWithText:self.text];
    [[YTAPIContext sharedInstance].apiClient createFeed:newFeed forChannel:self.channel.identifier success:^(YTFeed *feed) {
      [subscriber sendNext:[[FeedViewModel alloc] initWithFeed:feed]];
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
