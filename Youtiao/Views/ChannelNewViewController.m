#import "ChannelNewViewController.h"
#import <CMPopTipView/CMPopTipView.h>


@interface ChannelNewViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *createBarButtonItem;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *textButton;

@end


@implementation ChannelNewViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self bindViewModels];
}

- (void)bindViewModels {
  RAC(self.channelNewViewModel, name) = self.nameTextField.rac_textSignal;
  self.createBarButtonItem.rac_command = self.channelNewViewModel.createChannelCommand;

  @weakify(self);
  [[self.channelNewViewModel.createChannelCommand executionSignals] subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(ChannelViewModel *channelViewModel) {
      @strongify(self);
      [self.delegate channelNewViewController:self didCreateChannel:channelViewModel];
    }];
  }];
}

- (IBAction)cancel:(id)sender {
  NSLog(@"asdafsa");
  [self.delegate channelNewViewControllerDidCancel:self];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)customAction:(id)sender {
    NSLog(@"Custom Action");
}


@end
