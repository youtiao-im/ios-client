#import "ChannelTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface ChannelTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;


@end


@implementation ChannelTableViewCell

- (void)setChannelViewModel:(ChannelViewModel *)channelViewModel {
  _channelViewModel = channelViewModel;

  // TODO:
  [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:@"http://7pn5p7.com1.z0.glb.clouddn.com/Fjjevc7FDWqgIHZtiC57nHqnrtMH"]];
  self.nameLabel.text = channelViewModel.name;
}

@end
