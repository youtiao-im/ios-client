#import "BulletinNewViewModel.h"
#import "BulletinViewModel.h"


@interface BulletinNewViewModel ()

@property (nonatomic) YTGroup *group;
@property (nonatomic) YTBulletin *createdBulletin;

@end


@implementation BulletinNewViewModel

- (id)initWithGroup:(YTGroup *)group {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _group = group;

  RACSignal *textValidSignal = [[RACObserve(self, text) map:^id(NSString *text) {
    return @(text.length > 0);
  }] distinctUntilChanged];

  _createBulletinCommand = [[RACCommand alloc] initWithEnabled:textValidSignal signalBlock:^RACSignal *(id input) {
    return [self createBulletinSignal];
  }];

  return self;
}

- (RACSignal *)createBulletinSignal {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    YTBulletin *newBulletin = [[YTBulletin alloc] initWithText:self.text];
    [[YTAPIContext sharedInstance].apiClient createBulletin:newBulletin forGroup:self.group.identifier success:^(YTBulletin *bulletin) {
      [subscriber sendNext:[[BulletinViewModel alloc] initWithBulletin:bulletin]];
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
