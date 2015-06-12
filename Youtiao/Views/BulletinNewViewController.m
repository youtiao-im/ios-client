#import "BulletinNewViewController.h"


@interface BulletinNewViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *createBarButtonItem;
@property (weak, nonatomic) IBOutlet UITextView *textTextView;

@end

@implementation BulletinNewViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self bindViewModels];
}

- (void)bindViewModels {
  RAC(self.bulletinNewViewModel, text) = self.textTextView.rac_textSignal;
  self.createBarButtonItem.rac_command = self.bulletinNewViewModel.createBulletinCommand;

  @weakify(self);
  [self.bulletinNewViewModel.createBulletinCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(BulletinViewModel *bulletinViewModel) {
      @strongify(self);
      [self.delegate bulletinNewViewController:self didCreateBulletin:bulletinViewModel];
    }];
  }];
}

- (IBAction)cancel:(id)sender {
  [self.delegate bulletinNewViewControllerDidCancel:self];
}

@end
