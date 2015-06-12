#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class CommentViewModel, CommentNewViewModel;

@interface BulletinViewModel : NSObject

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *createdByName;
@property (nonatomic, readonly) NSString *groupName;
@property (nonatomic, readonly) NSString *timestamp;
@property (nonatomic, readonly) NSString *checksCountString;
@property (nonatomic, readonly) NSString *crossesCountString;
@property (nonatomic, readonly) NSString *commentsCountString;
@property (nonatomic, readonly) RACCommand *fetchCommentsCommand;
@property (nonatomic, readonly) RACCommand *checkCommand;
@property (nonatomic, readonly) RACCommand *crossCommand;

- (id)initWithBulletin:(YTBulletin *)bulletin;

- (NSInteger)numberOfComments;
- (CommentViewModel *)commentViewModelAtIndex:(NSInteger)index;

- (CommentNewViewModel *)commentNewViewModel;

@end
