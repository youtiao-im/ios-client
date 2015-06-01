#import "CommentNewViewModel.h"

#import "CommentViewModel.h"

@interface CommentNewViewModel ()

@property (nonatomic, strong) YTFeed *feed;
@property (nonatomic, strong) YTComment *createdComment;

@end

@implementation CommentNewViewModel

- (id)initWithFeed:(YTFeed *)feed {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _feed = feed;

  RACSignal *textValidSignal = [[RACObserve(self, text) map:^id(NSString *text) {
    return @(text.length > 6);
  }] distinctUntilChanged];

  _createCommentCommand = [[RACCommand alloc] initWithEnabled:textValidSignal signalBlock:^RACSignal *(id input) {
    return [self createCommentSignal];
  }];

  return self;
}

- (CommentViewModel *)createdCommentViewModel {
  if (self.createdComment == nil) {
    return nil;
  }
  return [[CommentViewModel alloc] initWithComment:self.createdComment];
}

- (RACSignal *)createCommentSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    YTComment *newComment = [[YTComment alloc] initWithText:self.text];
    [[[YTAPIContext sharedInstance] apiClient] createComment:newComment forFeed:self.feed.identifier success:^(YTComment *comment) {
      @strongify(self);
      self.createdComment = comment;
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
