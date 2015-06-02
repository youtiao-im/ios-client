#import "FeedsViewController.h"
#import <FontAwesomeKit/FAKIonIcons.h>
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

  self.tabBarItem.image = [[FAKIonIcons iosHomeOutlineIconWithSize:35] imageWithSize:CGSizeMake(35, 35)];
  self.tabBarItem.selectedImage = [[FAKIonIcons iosHomeIconWithSize:35] imageWithSize:CGSizeMake(35, 35)];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.authenticatedUserViewModel numberOfFeeds];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
  ((FeedTableViewCell *) cell).feedViewModel = [self.authenticatedUserViewModel feedViewModelAtIndex:indexPath.row];
  return cell;
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
