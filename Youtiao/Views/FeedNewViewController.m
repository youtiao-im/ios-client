#import "FeedNewViewController.h"


@interface FeedNewViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textTextView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@end

@implementation FeedNewViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self bindViewModels];
}

- (void)bindViewModels {
  RAC(self.feedNewViewModel, text) = self.textTextView.rac_textSignal;
  self.createButton.rac_command = self.feedNewViewModel.createFeedCommand;

  @weakify(self);
  [self.feedNewViewModel.createFeedCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(FeedViewModel *feedViewModel) {
      @strongify(self);
      [self.delegate feedNewViewController:self didCreateFeed:feedViewModel];
    }];
  }];
}

- (IBAction)cancel:(id)sender {
  [self.delegate feedNewViewControllerDidCancel:self];
}

@end
