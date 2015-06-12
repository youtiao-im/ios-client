#import "BulletinTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface BulletinTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *createdByAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *createdByNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *checksCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *crossButton;
@property (weak, nonatomic) IBOutlet UILabel *crossesCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;

@end


@implementation BulletinTableViewCell

- (void)setBulletinViewModel:(BulletinViewModel *)bulletinViewModel {
  _bulletinViewModel = bulletinViewModel;

  [self bindViewModels];
}

- (void)bindViewModels {
  [self.createdByAvatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://7pn5p7.com1.z0.glb.clouddn.com/Fjjevc7FDWqgIHZtiC57nHqnrtMH"]];
  self.createdByNameLabel.text = self.bulletinViewModel.createdByName;
  self.groupNameLabel.text = [NSString stringWithFormat:@"#%@", self.bulletinViewModel.groupName];
  // TODO:
  self.createdAtLabel.text = @"7D";
  self.textContentLabel.text = self.bulletinViewModel.text;
  self.checkButton.rac_command = self.bulletinViewModel.checkCommand;
  self.checksCountLabel.text = self.bulletinViewModel.checksCountString;
  self.crossButton.rac_command = self.bulletinViewModel.crossCommand;
  self.crossesCountLabel.text = self.bulletinViewModel.crossesCountString;
  self.commentsCountLabel.text = self.bulletinViewModel.commentsCountString;

  // TODO merge signal
  @weakify(self);
  [[self.bulletinViewModel.checkCommand executionSignals] subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      // TODO: bind
      self.checksCountLabel.text = self.bulletinViewModel.checksCountString;
      self.crossesCountLabel.text = self.bulletinViewModel.crossesCountString;
      self.commentsCountLabel.text = self.bulletinViewModel.commentsCountString;
    }];
  }];

  [[self.bulletinViewModel.crossCommand executionSignals] subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      // TODO: bind
      self.checksCountLabel.text = self.bulletinViewModel.checksCountString;
      self.crossesCountLabel.text = self.bulletinViewModel.crossesCountString;
      self.commentsCountLabel.text = self.bulletinViewModel.commentsCountString;
    }];
  }];
}

@end
