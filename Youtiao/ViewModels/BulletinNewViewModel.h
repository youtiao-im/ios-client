#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class BulletinViewModel;

@interface BulletinNewViewModel : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic, readonly) RACCommand *createBulletinCommand;

- (id)initWithGroup:(YTGroup *)group;

@end
