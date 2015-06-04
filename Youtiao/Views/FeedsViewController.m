#import "FeedsViewController.h"
#import "FeedViewController.h"
#import "FeedTableViewCell.h"


@interface FeedsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *feedsTableView;

@end


@implementation FeedsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self == nil) {
    return nil;
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // TODO: move app delegate
  self.authenticatedUserViewModel = [[AuthenticatedUserViewModel alloc] init];

  [self configViews];
  [self bindViewModels];
}

- (void)configViews {
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

  UINib *nib = [UINib nibWithNibName:@"FeedTableViewCell" bundle:nil];
  [self.feedsTableView registerNib:nib forCellReuseIdentifier:@"FeedCell"];

  self.feedsTableView.rowHeight = UITableViewAutomaticDimension;
  self.feedsTableView.estimatedRowHeight = 160.0;
  self.feedsTableView.dataSource = self;
  self.feedsTableView.delegate = self;
}

- (void)bindViewModels {
  @weakify(self);
  [self.authenticatedUserViewModel.fetchFeedsCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      [self.feedsTableView reloadData];
    }];
  }];

  [self.authenticatedUserViewModel.fetchFeedsCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSIndexPath *selectedIndexPath = [self.feedsTableView indexPathForSelectedRow];
  [self.feedsTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.authenticatedUserViewModel numberOfFeeds];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
  ((FeedTableViewCell *) cell).feedViewModel = [self.authenticatedUserViewModel feedViewModelAtIndex:indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"FeedSegue" sender:self];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }

  if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    [cell setPreservesSuperviewLayoutMargins:NO];
  }

  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController *viewController = segue.destinationViewController;
  if ([viewController isMemberOfClass:[FeedViewController class]]) {
    FeedViewController * feedViewController = (FeedViewController *) viewController;
    NSIndexPath *indexPath = [self.feedsTableView indexPathForSelectedRow];
    feedViewController.feedViewModel = [self.authenticatedUserViewModel feedViewModelAtIndex:indexPath.row];
  }
}

@end
