#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class CommentViewModel, CommentNewViewModel;

@interface FeedViewModel : NSObject

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *createdByName;
@property (nonatomic, readonly) NSString *channelName;
@property (nonatomic, readonly) NSString *timestamp;
@property (nonatomic, readonly) NSInteger commentsCount;
@property (nonatomic, readonly) NSInteger starsCount;
@property (nonatomic, readonly) RACCommand *fetchCommentsCommand;

- (id)initWithFeed:(YTFeed *)feed;

- (NSInteger)numberOfComments;
- (CommentViewModel *)commentViewModelAtIndex:(NSInteger)index;

- (CommentNewViewModel *)commentNewViewModel;

@end
