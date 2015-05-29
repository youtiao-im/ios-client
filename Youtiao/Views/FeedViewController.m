#import "FeedViewController.h"

#import "FeedViewModel.h"
#import "CommentViewModel.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UITableView *commentsTableView;

@end

@implementation FeedViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // TODO:
  self.title = @"Feed detail";

  self.commentsTableView.dataSource = self;
  self.commentsTableView.delegate = self;

  [self bindViewModel];
}

- (void)bindViewModel {
  self.textLabel.text = self.feedViewModel.text;

  // TODO: do we need weak/strong dance?
  [[[self.feedViewModel fetchCommentsCommand] execute:nil] subscribeCompleted:^{
    [self.commentsTableView reloadData];
  }];
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
