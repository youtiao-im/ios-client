#import "BulletinViewModel.h"
#import "CommentViewModel.h"
#import "CommentNewViewModel.h"


@interface BulletinViewModel ()

@property (nonatomic) YTBulletin *bulletin;
@property (nonatomic) NSArray *comments;

@end


@implementation BulletinViewModel

- (id)initWithBulletin:(YTBulletin *)bulletin {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _bulletin = bulletin;

  _fetchCommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self fetchCommentsSignal];
  }];
  _checkCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self stampBulletinWithSymbolSignal:@"check"];
  }];
  _crossCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self stampBulletinWithSymbolSignal:@"cross"];
  }];

  return self;
}

- (NSString *)text {
  return self.bulletin.text;
}

- (NSString *)createdByName {
  // TODO:
  return self.bulletin.createdBy.identifier;
}

- (NSString *)groupName {
  return self.bulletin.group.name;
}

- (NSString *)checksCountString {
  return [NSString stringWithFormat:@"%ld", (long)self.bulletin.checksCount];
}

- (NSString *)crossesCountString {
  return [NSString stringWithFormat:@"%ld", (long)self.bulletin.crossesCount];
}

- (NSString *)commentsCountString {
  return [NSString stringWithFormat:@"%ld", (long)self.bulletin.commentsCount];
}

- (NSInteger)numberOfComments {
  return self.comments == nil ? 0 : self.comments.count;
}

- (CommentViewModel *)commentViewModelAtIndex:(NSInteger)index {
  YTComment *comment = [self.comments objectAtIndex:index];
  return [[CommentViewModel alloc] initWithComment:comment];
}

- (RACSignal *)fetchCommentsSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[YTAPIContext sharedInstance].apiClient fetchCommentsOfBulletin:self.bulletin.identifier success:^(NSArray *comments) {
      @strongify(self);
      self.comments = comments;
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

- (RACSignal *)stampBulletinWithSymbolSignal:(NSString *)symbol {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [[YTAPIContext sharedInstance].apiClient stampBulletin:self.bulletin.identifier withSymbol:symbol success:^(YTBulletin *bulletin) {
      @strongify(self);
      self.bulletin = bulletin;
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

- (CommentNewViewModel *)commentNewViewModel {
  return [[CommentNewViewModel alloc] initWithBulletin:self.bulletin];
}

@end
