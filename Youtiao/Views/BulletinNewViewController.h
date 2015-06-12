#import <UIKit/UIKit.h>
#import "ViewModels.h"


@class BulletinNewViewController;

@protocol BulletinNewViewControllerDelegate <NSObject>

@optional
- (void)bulletinNewViewController:(BulletinNewViewController *)controller didCreateBulletin:(BulletinViewModel *)bulletinViewModel;
- (void)bulletinNewViewControllerDidCancel:(BulletinNewViewController *)controller;

@end


@interface BulletinNewViewController : UIViewController

@property (weak, nonatomic) id<BulletinNewViewControllerDelegate> delegate;
@property (nonatomic) BulletinNewViewModel *bulletinNewViewModel;

@end
