#import "ChannelFeedsViewController.h"

#import "MembershipViewModel.h"
#import "ChannelViewModel.h"
#import "FeedViewModel.h"

#import "ChannelDetailViewController.h"
#import "FeedDetailViewController.h"

@interface ChannelFeedsViewController () <UITableViewDataSource, UITableViewDelegate>

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

  // TODO: do we need weak/strong dance?
  [[[self.channelViewModel fetchFeedsCommand] execute:nil] subscribeCompleted:^{
    [self.feedsTableView reloadData];
  }];
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
  if ([viewController isMemberOfClass:[FeedDetailViewController class]]) {
    NSIndexPath *indexPath = [self.feedsTableView indexPathForSelectedRow];
    ((FeedDetailViewController *) viewController).feedViewModel = [self.channelViewModel feedViewModelAtIndex:indexPath.row];
  } else if ([viewController isMemberOfClass:[ChannelDetailViewController class]]) {
    ((ChannelDetailViewController *) viewController).membershipViewModel = self.membershipViewModel;
  }
}

@end
