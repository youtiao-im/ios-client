#import <UIKit/UIKit.h>
#import "ViewModels.h"

@interface BulletinDetailTableViewCell : UITableViewCell

@property (nonatomic) BulletinViewModel *bulletinViewModel;

@property (weak, nonatomic) IBOutlet UIImageView *createdByAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *createdByNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@end
