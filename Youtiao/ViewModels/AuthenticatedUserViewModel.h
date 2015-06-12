#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class BulletinViewModel, GroupViewModel;

@interface AuthenticatedUserViewModel : NSObject

@property (nonatomic, readonly) RACCommand *fetchBulletinsCommand;
@property (nonatomic, readonly) RACCommand *fetchGroupsCommand;

- (NSInteger)numberOfBulletins;
- (BulletinViewModel *)bulletinViewModelAtIndex:(NSInteger)index;

- (NSInteger)numberOfGroups;
- (GroupViewModel *)groupViewModelAtIndex:(NSInteger)index;

@end
