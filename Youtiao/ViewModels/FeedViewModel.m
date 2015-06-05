#import "FeedViewModel.h"
#import "CommentViewModel.h"
#import "CommentNewViewModel.h"


@interface FeedViewModel ()

@property (nonatomic) YTFeed *feed;
@property (nonatomic) NSArray *comments;

@end


@implementation FeedViewModel

- (id)initWithFeed:(YTFeed *)feed {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _feed = feed;

  _fetchCommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchCommentsSignal];
  }];
  _checkCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self markFeedWithSymbolSignal:@"check"];
  }];
  _crossCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self markFeedWithSymbolSignal:@"cross"];
  }];

  return self;
}

- (NSString *)text {
  return self.feed.text;
}

- (NSString *)createdByName {
  return self.feed.createdBy.name;
}

- (NSString *)channelName {
  return self.feed.channel.name;
}

- (NSString *)checksCountString {
  return [NSString stringWithFormat:@"%ld", (long)self.feed.checksCount];
}

- (NSString *)crossesCountString {
  return [NSString stringWithFormat:@"%ld", (long)self.feed.crossesCount];
}

- (NSString *)commentsCountString {
  return [NSString stringWithFormat:@"%ld", (long)self.feed.commentsCount];
}

- (NSInteger)numberOfComments {
  return self.comments == nil ? 0 : self.comments.count;
}

- (CommentViewModel *)commentViewModelAtIndex:(NSInteger)index {
  YTComment *comment = [self.comments objectAtIndex:index];
  return [[CommentViewModel alloc] initWithComment:comment];
}

- (RACSignal *)fetchCommentsSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[YTAPIContext sharedInstance].apiClient fetchCommentsOfFeed:self.feed.identifier success:^(NSArray *comments) {
      @strongify(self);
      self.comments = comments;
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

- (RACSignal *)markFeedWithSymbolSignal:(NSString *)symbol {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[YTAPIContext sharedInstance].apiClient markFeed:self.feed.identifier withSymbol:symbol success:^(YTFeed *feed) {
      @strongify(self);
      self.feed = feed;
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

- (CommentNewViewModel *)commentNewViewModel {
  return [[CommentNewViewModel alloc] initWithFeed:self.feed];
}

@end
