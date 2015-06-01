#import "FeedViewController.h"

#import "FeedViewModel.h"
#import "CommentViewModel.h"
#import "CommentNewViewModel.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (nonatomic, strong) CommentNewViewModel *commentNewViewModel;

@end

@implementation FeedViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // TODO:
  self.title = @"Feed detail";

  self.commentsTableView.dataSource = self;
  self.commentsTableView.delegate = self;

  self.commentNewViewModel = [self.feedViewModel commentNewViewModel];

  [self bindViewModel];
}

- (void)bindViewModel {
  self.textLabel.text = self.feedViewModel.text;

  RAC(self.commentNewViewModel, text) = self.textField.rac_textSignal;
  self.createButton.rac_command = self.commentNewViewModel.createCommentCommand;

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
      self.textField.text = nil;
      [self.feedViewModel.fetchCommentsCommand execute:nil];
    }];
  }];

  [self.feedViewModel.fetchCommentsCommand execute:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.feedViewModel numberOfComments];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentCell"];
  }

  CommentViewModel *commentViewModel = [self.feedViewModel commentViewModelAtIndex:indexPath.row];
  cell.textLabel.text = commentViewModel.text;
  return cell;
}

@end
