#import "FeedNewViewController.h"

#import "FeedNewViewModel.h"

@interface FeedNewViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (nonatomic, weak) IBOutlet UIButton *createButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@end

@implementation FeedNewViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // TODO:
  self.title = @"New Feed";

  [self bindViewModel];
}

- (void)bindViewModel {
  RAC(self.feedNewViewModel, text) = self.textField.rac_textSignal;
  self.createButton.rac_command = self.feedNewViewModel.createFeedCommand;

  @weakify(self);
  [self.feedNewViewModel.createFeedCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      if (self.delegate != nil) {
        [self.delegate feedNewViewController:self didCreateFeed:[self.feedNewViewModel createdFeedViewModel]];
      }
    }];
  }];
}

- (IBAction)cancel:(id)sender {
  if (self.delegate != nil) {
    [self.delegate feedNewViewControllerDidCancel:self];
  }
}

@end
