#import "FeedViewModel.h"

#import "CommentViewModel.h"

@interface FeedViewModel ()

@property (nonatomic, strong) YTFeed *feed;
@property (nonatomic, strong) NSArray *comments;

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

  return self;
}

- (NSString *)text {
  return self.feed.text;
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
    [[[YTAPIContext sharedInstance] apiClient] fetchCommentsOfFeed:self.feed.identifier success:^(NSArray *comments) {
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

@end
