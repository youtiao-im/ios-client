#import <UIKit/UIKit.h>

@class FeedNewViewModel, FeedNewViewController, FeedViewModel;

@protocol FeedNewViewControllerDelegate <NSObject>

@optional

- (void)feedNewViewController:(FeedNewViewController *)controller didCreateFeed:(FeedViewModel *)feedViewModel;
- (void)feedNewViewControllerDidCancel:(FeedNewViewController *)controller;

@end

@interface FeedNewViewController : UIViewController

@property (nonatomic, strong) id<FeedNewViewControllerDelegate> delegate;
@property (nonatomic, strong) FeedNewViewModel *feedNewViewModel;

@end
