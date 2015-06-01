#import <UIKit/UIKit.h>
#import "ViewModels.h"


@class ChannelNewViewController;

@protocol ChannelNewViewControllerDelegate <NSObject>

@optional
- (void)channelNewViewController:(ChannelNewViewController *)controller didCreateChannel:(ChannelViewModel *)channelViewModel;
- (void)channelNewViewControllerDidCancel:(ChannelNewViewController *)controller;

@end


@interface ChannelNewViewController : UIViewController

@property (weak, nonatomic) id<ChannelNewViewControllerDelegate> delegate;
@property (nonatomic) ChannelNewViewModel *channelNewViewModel;

@end
