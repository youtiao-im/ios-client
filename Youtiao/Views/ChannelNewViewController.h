#import <UIKit/UIKit.h>

@class ChannelNewViewModel, ChannelNewViewController, ChannelViewModel;

@protocol ChannelNewViewControllerDelegate <NSObject>

@optional

- (void)channelNewViewController:(ChannelNewViewController *)controller didCreateChannel:(ChannelViewModel *)channelViewModel;
- (void)channelNewViewControllerDidCancel:(ChannelNewViewController *)controller;

@end

@interface ChannelNewViewController : UIViewController

@property (nonatomic, strong) id<ChannelNewViewControllerDelegate> delegate;
@property (nonatomic, strong) ChannelNewViewModel *channelNewViewModel;

@end
