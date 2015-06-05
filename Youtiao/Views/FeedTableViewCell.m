#import "FeedTableViewCell.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface FeedTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *createdByAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *createdByNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *checksCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *crossButton;
@property (weak, nonatomic) IBOutlet UILabel *crossesCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;

@end


@implementation FeedTableViewCell

- (void)setFeedViewModel:(FeedViewModel *)feedViewModel {
  _feedViewModel = feedViewModel;

  [self bindViewModels];
}

- (void)bindViewModels {
  [self.createdByAvatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://7pn5p7.com1.z0.glb.clouddn.com/Fjjevc7FDWqgIHZtiC57nHqnrtMH"]];
  self.createdByNameLabel.text = self.feedViewModel.createdByName;
  self.channelNameLabel.text = [NSString stringWithFormat:@"#%@", self.feedViewModel.channelName];
  // TODO:
  self.createdAtLabel.text = @"7D";
  self.textContentLabel.text = self.feedViewModel.text;
  self.checkButton.rac_command = self.feedViewModel.checkCommand;
  self.checksCountLabel.text = self.feedViewModel.checksCountString;
  self.crossButton.rac_command = self.feedViewModel.crossCommand;
  self.crossesCountLabel.text = self.feedViewModel.crossesCountString;
  self.commentsCountLabel.text = self.feedViewModel.commentsCountString;

  // TODO merge signal
  @weakify(self);
  [[self.feedViewModel.checkCommand executionSignals] subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      // TODO: bind
      self.checksCountLabel.text = self.feedViewModel.checksCountString;
      self.crossesCountLabel.text = self.feedViewModel.crossesCountString;
      self.commentsCountLabel.text = self.feedViewModel.commentsCountString;
    }];
  }];

  [[self.feedViewModel.crossCommand executionSignals] subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      // TODO: bind
      self.checksCountLabel.text = self.feedViewModel.checksCountString;
      self.crossesCountLabel.text = self.feedViewModel.crossesCountString;
      self.commentsCountLabel.text = self.feedViewModel.commentsCountString;
    }];
  }];
}

@end
