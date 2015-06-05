#import "FeedDetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation FeedDetailTableViewCell

- (void)setFeedViewModel:(FeedViewModel *)feedViewModel {
  _feedViewModel = feedViewModel;
  [self bindViewModels];
}

- (void)bindViewModels {
  [self.createdByAvatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://7pn5p7.com1.z0.glb.clouddn.com/Fjjevc7FDWqgIHZtiC57nHqnrtMH"]];
  self.createdByNameLabel.text = self.feedViewModel.createdByName;
  self.channelNameLabel.text = [NSString stringWithFormat:@"#%@", self.feedViewModel.channelName];
  // TODO:
  self.textContentLabel.text = self.feedViewModel.text;
}

@end
