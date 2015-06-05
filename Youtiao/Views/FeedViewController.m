#import "FeedViewController.h"
#import "FeedDetailTableViewCell.h"
#import "FeedOperationsTableViewCell.h"
#import "CommentTableViewCell.h"


@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *commentCreateButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;

@property (nonatomic) CommentNewViewModel *commentNewViewModel;

@end


@implementation FeedViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.commentNewViewModel = [self.feedViewModel commentNewViewModel];

  [self configViews];
  [self bindViewModels];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
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
  return [self.feedViewModel numberOfComments] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // TODO:
  UITableViewCell *cell;
  if (indexPath.row == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    ((FeedDetailTableViewCell *)cell).feedViewModel = self.feedViewModel;
  } else if (indexPath.row == 1) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"OperationsCell"];
    ((FeedOperationsTableViewCell *)cell).feedViewModel = self.feedViewModel;
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    ((CommentTableViewCell *)cell).commentViewModel = [self.feedViewModel commentViewModelAtIndex:indexPath.row-2];
  }
  return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Remove seperator inset
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }

  // Prevent the cell from inheriting the Table View's margin settings
  if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    [cell setPreservesSuperviewLayoutMargins:NO];
  }

  // Explictly set your cell's layout margins
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

- (void)keyboardDidShow:(NSNotification *)sender {
  CGRect frame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGRect newFrame = [self.view convertRect:frame fromView:[[UIApplication sharedApplication] delegate].window];
  self.bottomLayoutConstraint.constant = CGRectGetHeight(self.view.frame) - newFrame.origin.y;
  [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)sender {
  self.bottomLayoutConstraint.constant = 0;
  [self.view layoutIfNeeded];
}

@end
