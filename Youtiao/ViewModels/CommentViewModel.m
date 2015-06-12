#import "CommentViewModel.h"


@interface CommentViewModel ()

@property (nonatomic) YTComment *comment;

@end


@implementation CommentViewModel

- (id)initWithComment:(YTComment *)comment {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _comment = comment;

  return self;
}

- (NSString *)text {
  return self.comment.text;
}

- (NSString *)createdByName {
  // TODO:
  return self.comment.createdBy.identifier;
}

@end
