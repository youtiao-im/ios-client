#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class CommentViewModel;

@interface CommentNewViewModel : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic, readonly) RACCommand *createCommentCommand;

- (id)initWithBulletin:(YTBulletin *)bulletin;

@end
