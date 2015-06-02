#import "CommentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface CommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *createdByAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *createdByNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;

@end


@implementation CommentTableViewCell

- (void)setCommentViewModel:(CommentViewModel *)commentViewModel {
  _commentViewModel = commentViewModel;

  // TODO:
  [self.createdByAvatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://7pn5p7.com1.z0.glb.clouddn.com/Fjjevc7FDWqgIHZtiC57nHqnrtMH"]];
  self.createdByNameLabel.text = commentViewModel.createdByName;
  self.textContentLabel.text = commentViewModel.text;
}

@end
