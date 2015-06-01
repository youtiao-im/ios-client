#import <UIKit/UIKit.h>
#import "ViewModels.h"


@class FeedNewViewController;

@protocol FeedNewViewControllerDelegate <NSObject>

@optional
- (void)feedNewViewController:(FeedNewViewController *)controller didCreateFeed:(FeedViewModel *)feedViewModel;
- (void)feedNewViewControllerDidCancel:(FeedNewViewController *)controller;

@end


@interface FeedNewViewController : UIViewController

@property (weak, nonatomic) id<FeedNewViewControllerDelegate> delegate;
@property (nonatomic) FeedNewViewModel *feedNewViewModel;

@end
