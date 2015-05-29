#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"

@class CommentViewModel;

@interface FeedViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *text;

@property (nonatomic, strong, readonly) RACCommand *fetchCommentsCommand;

- (id)initWithFeed:(YTFeed *)feed;

- (NSInteger)numberOfComments;
- (CommentViewModel *)commentViewModelAtIndex:(NSInteger)index;

@end
