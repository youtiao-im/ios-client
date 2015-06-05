#import <UIKit/UIKit.h>
#import "ViewModels.h"

@interface FeedDetailTableViewCell : UITableViewCell

@property (nonatomic) FeedViewModel *feedViewModel;

@property (weak, nonatomic) IBOutlet UIImageView *createdByAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *createdByNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@end
