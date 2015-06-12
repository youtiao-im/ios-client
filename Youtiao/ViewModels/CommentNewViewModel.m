#import "CommentNewViewModel.h"
#import "CommentViewModel.h"


@interface CommentNewViewModel ()

@property (nonatomic) YTBulletin *bulletin;

@end


@implementation CommentNewViewModel

- (id)initWithBulletin:(YTBulletin *)bulletin {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _bulletin = bulletin;

  RACSignal *textValidSignal = [[RACObserve(self, text) map:^id(NSString *text) {
    return @(text.length > 6);
  }] distinctUntilChanged];

  _createCommentCommand = [[RACCommand alloc] initWithEnabled:textValidSignal signalBlock:^RACSignal *(id input) {
    return [self createCommentSignal];
  }];

  return self;
}

- (RACSignal *)createCommentSignal {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    YTComment *newComment = [[YTComment alloc] initWithText:self.text];
    [[YTAPIContext sharedInstance].apiClient createComment:newComment forBulletin:self.bulletin.identifier success:^(YTComment *comment) {
      [subscriber sendNext:[[CommentViewModel alloc] initWithComment:comment]];
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
