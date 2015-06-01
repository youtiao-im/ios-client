#import "FeedViewController.h"


@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *commentCreateButton;
@property (nonatomic) CommentNewViewModel *commentNewViewModel;

@end


@implementation FeedViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.commentNewViewModel = [self.feedViewModel commentNewViewModel];

  [self bindViewModels];
}

- (void)configViews {
  self.textLabel.text = self.feedViewModel.text;

  self.commentsTableView.dataSource = self;
  self.commentsTableView.delegate = self;
}

- (void)bindViewModels {
  RAC(self.commentNewViewModel, text) = self.commentTextField.rac_textSignal;
  self.commentCreateButton.rac_command = self.commentNewViewModel.createCommentCommand;

  @weakify(self);
  [self.feedViewModel.fetchCommentsCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      [self.commentsTableView reloadData];
    }];
  }];

  [self.commentNewViewModel.createCommentCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      self.commentTextField.text = nil;
      [self.feedViewModel.fetchCommentsCommand execute:nil];
    }];
  }];

  [self.feedViewModel.fetchCommentsCommand execute:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.feedViewModel numberOfComments];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // TODO:
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentCell"];
  }

  CommentViewModel *commentViewModel = [self.feedViewModel commentViewModelAtIndex:indexPath.row];
  cell.textLabel.text = commentViewModel.text;
  return cell;
}

@end
