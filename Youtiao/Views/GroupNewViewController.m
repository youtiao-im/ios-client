#import "GroupNewViewController.h"


@interface GroupNewViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *createBarButtonItem;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end


@implementation GroupNewViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self bindViewModels];
}

- (void)bindViewModels {
  RAC(self.groupNewViewModel, name) = self.nameTextField.rac_textSignal;
  self.createBarButtonItem.rac_command = self.groupNewViewModel.createGroupCommand;

  @weakify(self);
  [[self.groupNewViewModel.createGroupCommand executionSignals] subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(GroupViewModel *groupViewModel) {
      @strongify(self);
      [self.delegate groupNewViewController:self didCreateGroup:groupViewModel];
    }];
  }];
}

- (IBAction)cancel:(id)sender {
  [self.delegate groupNewViewControllerDidCancel:self];
}

@end
