#import "GroupViewModel.h"
#import "BulletinViewModel.h"
#import "MembershipViewModel.h"
#import "BulletinNewViewModel.h"


@interface GroupViewModel ()

@property (nonatomic) YTGroup *group;
@property (nonatomic) NSArray *bulletins;
@property (nonatomic) NSArray *memberships;

@end


@implementation GroupViewModel

- (id)initWithGroup:(YTGroup *)group {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _group = group;

  _fetchBulletinsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchBulletinsSignal];
  }];
  _fetchMembershipsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchMembershipsSignal];
  }];

  return self;
}

- (NSString *)name {
  return self.group.name;
}

- (NSInteger)numberOfBulletins {
  return self.bulletins == nil ? 0 : self.bulletins.count;
}

- (BulletinViewModel *)bulletinViewModelAtIndex:(NSInteger)index {
  YTBulletin *bulletin = [self.bulletins objectAtIndex:index];
  return [[BulletinViewModel alloc] initWithBulletin:bulletin];
}

- (RACSignal *)fetchBulletinsSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[YTAPIContext sharedInstance].apiClient fetchBulletinsOfGroup:self.group.identifier success:^(NSArray *bulletins) {
      @strongify(self);
      self.bulletins = bulletins;
      [subscriber sendNext:nil];
      [subscriber sendCompleted];
    } failure:^(NSError *error) {
      [subscriber sendError:error];
      [subscriber sendCompleted];
    }];

    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (NSInteger)numberOfMemberships {
  return self.memberships == nil ? 0 : self.memberships.count;
}

- (MembershipViewModel *)membershipViewModelAtIndex:(NSInteger)index {
  YTMembership *membership = [self.memberships objectAtIndex:index];
  return [[MembershipViewModel alloc] initWithMembership:membership];
}

- (RACSignal *)fetchMembershipsSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[YTAPIContext sharedInstance].apiClient fetchMembershipsOfGroup:self.group.identifier success:^(NSArray *memberships) {
      @strongify(self);
      self.memberships = memberships;
      [subscriber sendNext:nil];
      [subscriber sendCompleted];
    } failure:^(NSError *error) {
      [subscriber sendError:error];
      [subscriber sendCompleted];
    }];

    return [RACDisposable disposableWithBlock:^{
    }];
  }];
}

- (BulletinNewViewModel *)bulletinNewViewModel {
  return [[BulletinNewViewModel alloc] initWithGroup:self.group];
}

@end
