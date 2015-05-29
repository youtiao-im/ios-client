#import "ChannelNewViewController.h"

#import "ChannelNewViewModel.h"

@interface ChannelNewViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UIButton *createButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@end

@implementation ChannelNewViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // TODO:
  self.title = @"New Channel";

  [self bindViewModel];
}

- (void)bindViewModel {
  RAC(self.channelNewViewModel, name) = self.nameField.rac_textSignal;
  self.createButton.rac_command = self.channelNewViewModel.createChannelCommand;

  @weakify(self);
  [[self.channelNewViewModel.createChannelCommand executionSignals] subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      if (self.delegate != nil) {
        [self.delegate channelNewViewController:self didCreateChannel:[self.channelNewViewModel createdChannelViewModel]];
      }
    }];
  }];
}

- (IBAction)cancel:(id)sender {
  if (self.delegate != nil) {
    [self.delegate channelNewViewControllerDidCancel:self];
  }
}

@end
