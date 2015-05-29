#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"

@interface ChannelViewModel : NSObject

@property (nonatomic, strong) YTMembership *membership;
@property (nonatomic, strong, readonly) NSString *name;

@end
