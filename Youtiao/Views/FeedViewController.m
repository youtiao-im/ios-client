#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "CommentTableViewCell.h"


@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *commentCreateButton;
@property (nonatomic) CommentNewViewModel *commentNewViewModel;

@end


@implementation FeedViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.commentNewViewModel = [self.feedViewModel commentNewViewModel];

  [self configViews];
  [self bindViewModels];
}

- (void)configViews {
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

  self.commentsTableView.rowHeight = UITableViewAutomaticDimension;
  self.commentsTableView.estimatedRowHeight = 65.0;
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
  return [self.feedViewModel numberOfComments] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // TODO:
  UITableViewCell *cell;
  if (indexPath.row == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    ((FeedTableViewCell *)cell).feedViewModel = self.feedViewModel;
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    ((CommentTableViewCell *)cell).commentViewModel = [self.feedViewModel commentViewModelAtIndex:indexPath.row-1];
  }

//  if (cell == nil) {
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentCell"];
//  }
//
//  CommentViewModel *commentViewModel = [self.feedViewModel commentViewModelAtIndex:indexPath.row];
//  cell.textLabel.text = commentViewModel.text;
  return cell;
}

@end
