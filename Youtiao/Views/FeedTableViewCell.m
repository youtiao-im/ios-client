#import "FeedTableViewCell.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface FeedTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *createdByAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *createdByNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;

@end


@implementation FeedTableViewCell

- (void)setFeedViewModel:(FeedViewModel *)feedViewModel {
  _feedViewModel = feedViewModel;

  // TODO:
  [self.createdByAvatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://7pn5p7.com1.z0.glb.clouddn.com/Fjjevc7FDWqgIHZtiC57nHqnrtMH"]];
  self.createdByNameLabel.text = feedViewModel.createdByName;
  self.channelNameLabel.text = [NSString stringWithFormat:@"#%@", feedViewModel.channelName];
  self.textContentLabel.text = feedViewModel.text;
}

@end
