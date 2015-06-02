#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@interface CommentViewModel : NSObject

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *createdByName;

- (id)initWithComment:(YTComment *)comment;

@end
