#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YTAPIContext.h"


@class BulletinViewModel, MembershipViewModel, BulletinNewViewModel;

@interface GroupViewModel : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) RACCommand *fetchBulletinsCommand;
@property (nonatomic, readonly) RACCommand *fetchMembershipsCommand;

- (id)initWithGroup:(YTGroup *)group;

- (NSInteger)numberOfBulletins;
- (BulletinViewModel *)bulletinViewModelAtIndex:(NSInteger)index;

- (NSInteger)numberOfMemberships;
- (MembershipViewModel *)membershipViewModelAtIndex:(NSInteger)index;

- (BulletinNewViewModel *)bulletinNewViewModel;

@end
