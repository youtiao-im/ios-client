#import "FeedTableViewCell.h"
#import <FontAwesomeKit/FAKIonIcons.h>


@interface FeedTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *createdByAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *createdByNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *starsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markIconImageView;

@end


@implementation FeedTableViewCell

- (void)setFeedViewModel:(FeedViewModel *)feedViewModel {
  self.createdByNameLabel.text = feedViewModel.createdByName;
  self.textContentLabel.text = feedViewModel.text;

  _commentIconImageView.image = [[FAKIonIcons chatboxIconWithSize:16] imageWithSize:CGSizeMake(16, 16)];
  _starIconImageView.image = [[FAKIonIcons starIconWithSize:16] imageWithSize:CGSizeMake(16, 16)];
  _markIconImageView.image = [[FAKIonIcons moreIconWithSize:16] imageWithSize:CGSizeMake(16, 16)];
}

@end
