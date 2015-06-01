#import "ChannelsViewController.h"

#import "AuthenticatedUserViewModel.h"
#import "MembershipViewModel.h"
#import "ChannelViewModel.h"
#import "ChannelNewViewModel.h"

#import "ChannelFeedsViewController.h"
#import "ChannelNewViewController.h"

@interface ChannelsViewController () <UITableViewDataSource, UITableViewDelegate, ChannelNewViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *channelsTableView;

@end

@implementation ChannelsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Channels";

  self.channelsTableView.dataSource = self;
  self.channelsTableView.delegate = self;

  // TODO: move app delegate
  self.authenticatedUserViewModel = [[AuthenticatedUserViewModel alloc] init];

  [self bindViewModel];
}

- (void)bindViewModel {
  @weakify(self);
  [self.authenticatedUserViewModel.fetchMembershipsCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      [self.channelsTableView reloadData];
    }];
  }];

  [self.authenticatedUserViewModel.fetchMembershipsCommand execute:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.authenticatedUserViewModel numberOfMemberships];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ChannelCell"];
  }

  MembershipViewModel *membershipViewModel = [self.authenticatedUserViewModel membershipViewModelAtIndex:indexPath.row];
  cell.textLabel.text = [membershipViewModel channelViewModel].name;
  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController *viewController = segue.destinationViewController;
  if ([viewController isMemberOfClass:[ChannelFeedsViewController class]]) {
    NSIndexPath *indexPath = [self.channelsTableView indexPathForSelectedRow];
    ((ChannelFeedsViewController *) viewController).membershipViewModel = [self.authenticatedUserViewModel membershipViewModelAtIndex:indexPath.row];
  } else if ([viewController isMemberOfClass:[ChannelNewViewController class]]) {
    ((ChannelNewViewController *) viewController).channelNewViewModel = [[ChannelNewViewModel alloc] init];
    ((ChannelNewViewController *) viewController).delegate = self;
  }
}

- (void)channelNewViewController:(ChannelNewViewController *)controller didCreateChannel:(ChannelViewModel *)channelViewModel {
  [controller dismissViewControllerAnimated:YES completion:nil];
  [self.authenticatedUserViewModel.fetchMembershipsCommand execute:nil];
}

- (void)channelNewViewControllerDidCancel:(ChannelNewViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
