#import "FeedOperationsTableViewCell.h"


@implementation FeedOperationsTableViewCell

- (void)setFeedViewModel:(FeedViewModel *)feedViewModel {
  _feedViewModel = feedViewModel;
  [self bindViewModels];
}

- (void)bindViewModels {
  self.checkButton.rac_command = self.feedViewModel.checkCommand;
  self.checksCountLabel.text = self.feedViewModel.checksCountString;
  self.crossButton.rac_command = self.feedViewModel.crossCommand;
  self.crossesCountLabel.text = self.feedViewModel.crossesCountString;

  @weakify(self);
  [[self.feedViewModel.checkCommand executionSignals] subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      // TODO: bind
      self.checksCountLabel.text = self.feedViewModel.checksCountString;
      self.crossesCountLabel.text = self.feedViewModel.crossesCountString;
    }];
  }];

  [[self.feedViewModel.crossCommand executionSignals] subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      // TODO: bind
      self.checksCountLabel.text = self.feedViewModel.checksCountString;
      self.crossesCountLabel.text = self.feedViewModel.crossesCountString;
    }];
  }];
}

@end
