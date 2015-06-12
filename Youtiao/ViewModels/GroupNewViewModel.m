#import "GroupNewViewModel.h"
#import "GroupViewModel.h"


@interface GroupNewViewModel ()

@end


@implementation GroupNewViewModel

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  RACSignal *nameValidSignal = [[RACObserve(self, name) map:^id(NSString *name) {
    return @(name.length >= 2);
  }] distinctUntilChanged];

  _createGroupCommand = [[RACCommand alloc] initWithEnabled:nameValidSignal signalBlock:^RACSignal *(id input) {
    return [self createGroupSignal];
  }];

  return self;
}

- (RACSignal *)createGroupSignal {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    YTGroup *newGroup = [[YTGroup alloc] initWithName:self.name];
    [[YTAPIContext sharedInstance].apiClient createGroup:newGroup success:^(YTGroup *group) {
      [subscriber sendNext:[[GroupViewModel alloc] initWithGroup:group]];
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
