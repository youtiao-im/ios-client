#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@interface CommentViewModel : NSObject

@property (nonatomic, readonly) NSString *text;

- (id)initWithComment:(YTComment *)comment;

@end
