#import "ChannelFeedsViewController.h"
#import <FontAwesomeKit/FAKIonIcons.h>
#import "ChannelSettingsViewController.h"
#import "FeedNewViewController.h"
#import "FeedViewController.h"
#import "FeedTableViewCell.h"


@interface ChannelFeedsViewController () <UITableViewDataSource, UITableViewDelegate, FeedNewViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *channelSettingsBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *feedsTableView;
@property (nonatomic) ChannelViewModel *channelViewModel;

@end


@implementation ChannelFeedsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.channelViewModel = [self.membershipViewModel channelViewModel];

  [self configViews];
  [self bindViewModels];
}

- (void)configViews {
  self.title = self.channelViewModel.name;
  self.navigationItem.backBarButtonItem.title = nil;
  self.channelSettingsBarButtonItem.image = [[FAKIonIcons personStalkerIconWithSize:25] imageWithSize:CGSizeMake(25, 25)];

  self.feedsTableView.rowHeight = UITableViewAutomaticDimension;
  self.feedsTableView.estimatedRowHeight = 160.0;
  self.feedsTableView.dataSource = self;
  self.feedsTableView.delegate = self;
}

- (void)bindViewModels {
  @weakify(self);
  [self.channelViewModel.fetchFeedsCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      [self.feedsTableView reloadData];
    }];
  }];

  [self.channelViewModel.fetchFeedsCommand execute:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.channelViewModel numberOfFeeds];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FeedTableViewCell *feedCell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
  FeedViewModel *feedViewModel = [self.channelViewModel feedViewModelAtIndex:indexPath.row];
  feedCell.feedViewModel = feedViewModel;
  return feedCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController *viewController = segue.destinationViewController;
  if ([viewController isMemberOfClass:[FeedViewController class]]) {
    FeedViewController * feedViewController = (FeedViewController *) viewController;
    NSIndexPath *indexPath = [self.feedsTableView indexPathForSelectedRow];
    feedViewController.feedViewModel = [self.channelViewModel feedViewModelAtIndex:indexPath.row];
  } else if ([viewController isMemberOfClass:[ChannelSettingsViewController class]]) {
    ChannelSettingsViewController * channelSettingsViewController = (ChannelSettingsViewController *) viewController;
    channelSettingsViewController.membershipViewModel = self.membershipViewModel;
  } else if ([viewController isMemberOfClass:[FeedNewViewController class]]) {
    FeedNewViewController *feedNewViewController = (FeedNewViewController *) viewController;
    feedNewViewController.feedNewViewModel = [self.channelViewModel feedNewViewModel];
    feedNewViewController.delegate = self;
  }
}

- (void)feedNewViewController:(FeedNewViewController *)controller didCreateFeed:(FeedViewModel *)feedViewModel {
  [controller dismissViewControllerAnimated:YES completion:nil];
  [self.channelViewModel.fetchFeedsCommand execute:nil];
}

- (void)feedNewViewControllerDidCancel:(FeedNewViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
