#import "AuthenticatedUserViewModel.h"
#import "BulletinViewModel.h"
#import "GroupViewModel.h"


@interface AuthenticatedUserViewModel ()

@property (nonatomic) NSArray *bulletins;
@property (nonatomic) NSArray *groups;

@end


@implementation AuthenticatedUserViewModel

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _fetchBulletinsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchBulletinsSignal];
  }];
  _fetchGroupsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchGroupsSignal];
  }];

  return self;
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
    [[YTAPIContext sharedInstance].apiClient fetchBulletinsWithSuccess:^(NSArray *bulletins) {
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

- (NSInteger)numberOfGroups {
  return self.groups == nil ? 0 : self.groups.count;
}

- (GroupViewModel *)groupViewModelAtIndex:(NSInteger)index {
  YTGroup *group = [self.groups objectAtIndex:index];
  return [[GroupViewModel alloc] initWithGroup:group];
}

- (RACSignal *)fetchGroupsSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[YTAPIContext sharedInstance].apiClient fetchGroupsWithSuccess:^(NSArray *groups) {
      @strongify(self);
      self.groups = groups;
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

@end
