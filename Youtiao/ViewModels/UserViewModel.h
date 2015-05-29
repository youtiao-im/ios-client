#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"

@interface UserViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *email;

- (id)initWithUser:(YTUser *)user;

@end
