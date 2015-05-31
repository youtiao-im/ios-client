#import "FeedNewViewModel.h"

#import "FeedViewModel.h"

@interface FeedNewViewModel ()

@property (nonatomic, strong) YTChannel *channel;
@property (nonatomic, strong) YTFeed *createdFeed;

@end

@implementation FeedNewViewModel

- (id)initWithChannel:(YTChannel *)channel {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _channel = channel;

  RACSignal *textValidSignal = [[RACObserve(self, text) map:^id(NSString *text) {
    return @(text.length > 6);
  }] distinctUntilChanged];

  _createFeedCommand = [[RACCommand alloc] initWithEnabled:textValidSignal signalBlock:^RACSignal *(id input) {
    return [self createFeedSignal];
  }];

  return self;
}

- (FeedViewModel *)createdFeedViewModel {
  if (self.createdFeed == nil) {
    return nil;
  }
  return [[FeedViewModel alloc] initWithFeed:self.createdFeed];
}

- (RACSignal *)createFeedSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    YTFeed *newFeed = [[YTFeed alloc] initWithText:self.text];
    [[[YTAPIContext sharedInstance] apiClient] createFeed:newFeed forChannel:self.channel.identifier success:^(YTFeed *feed) {
      @strongify(self);
      self.createdFeed = feed;
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
