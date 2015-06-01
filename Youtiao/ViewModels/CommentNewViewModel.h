#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"

@class CommentViewModel;

@interface CommentNewViewModel : NSObject

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong, readonly) RACCommand *createCommentCommand;

- (id)initWithFeed:(YTFeed *)feed;

- (CommentViewModel *)createdCommentViewModel;

@end
