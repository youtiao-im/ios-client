#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class GroupViewModel;

@interface GroupNewViewModel : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic, readonly) RACCommand *createGroupCommand;

@end
