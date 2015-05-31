#import "ChannelFeedsViewController.h"

#import "MembershipViewModel.h"
#import "ChannelViewModel.h"
#import "FeedViewModel.h"

#import "ChannelViewController.h"
#import "FeedViewController.h"
#import "FeedNewViewController.h"

@interface ChannelFeedsViewController () <UITableViewDataSource, UITableViewDelegate, FeedNewViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *feedsTableView;

@property (nonatomic, strong) ChannelViewModel *channelViewModel;

@end

@implementation ChannelFeedsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.feedsTableView.dataSource = self;
  self.feedsTableView.delegate = self;

  [self bindViewModel];
}

- (void)bindViewModel {
  self.channelViewModel = [self.membershipViewModel channelViewModel];

  self.title = self.channelViewModel.name;

  @weakify(self);
  [[self.channelViewModel fetchFeedsCommand].executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      [self.feedsTableView reloadData];
    }];
  }];

  [[self.channelViewModel fetchFeedsCommand] execute:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.channelViewModel numberOfFeeds];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FeedCell"];
  }

  FeedViewModel *feedViewModel = [self.channelViewModel feedViewModelAtIndex:indexPath.row];
  cell.textLabel.text = feedViewModel.text;
  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController *viewController = segue.destinationViewController;
  if ([viewController isMemberOfClass:[FeedViewController class]]) {
    NSIndexPath *indexPath = [self.feedsTableView indexPathForSelectedRow];
    ((FeedViewController *) viewController).feedViewModel = [self.channelViewModel feedViewModelAtIndex:indexPath.row];
  } else if ([viewController isMemberOfClass:[ChannelViewController class]]) {
    ((ChannelViewController *) viewController).membershipViewModel = self.membershipViewModel;
  } else if ([viewController isMemberOfClass:[FeedNewViewController class]]) {
    ((FeedNewViewController *) viewController).feedNewViewModel = [self.channelViewModel feedNewViewModel];
    ((FeedNewViewController *) viewController).delegate = self;
  }
}

- (void)feedNewViewController:(FeedNewViewController *)controller didCreateFeed:(FeedViewModel *)feedViewModel {
  NSLog(@"sadasd");
  [controller dismissViewControllerAnimated:YES completion:nil];
  [[self.channelViewModel fetchFeedsCommand] execute:nil];
}

- (void)feedNewViewControllerDidCancel:(FeedNewViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
