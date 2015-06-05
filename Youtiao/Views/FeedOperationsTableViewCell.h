#import <UIKit/UIKit.h>
#import "ViewModels.h"


@interface FeedOperationsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *checksCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *crossButton;
@property (weak, nonatomic) IBOutlet UILabel *crossesCountLabel;

@property (weak, nonatomic) FeedViewModel *feedViewModel;

@end
