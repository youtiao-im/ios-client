#import <UIKit/UIKit.h>
#import "ViewModels.h"


@class GroupNewViewController;

@protocol GroupNewViewControllerDelegate <NSObject>

@optional
- (void)groupNewViewController:(GroupNewViewController *)controller didCreateGroup:(GroupViewModel *)groupViewModel;
- (void)groupNewViewControllerDidCancel:(GroupNewViewController *)controller;

@end


@interface GroupNewViewController : UIViewController

@property (weak, nonatomic) id<GroupNewViewControllerDelegate> delegate;
@property (nonatomic) GroupNewViewModel *groupNewViewModel;

@end
