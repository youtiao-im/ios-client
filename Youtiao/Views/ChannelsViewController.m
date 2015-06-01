#import "ChannelsViewController.h"

#import <FontAwesomeKit/FAKIonIcons.h>

#import "AuthenticatedUserViewModel.h"
#import "MembershipViewModel.h"
#import "ChannelViewModel.h"
#import "ChannelNewViewModel.h"

#import "ChannelFeedsViewController.h"
#import "ChannelNewViewController.h"

@interface ChannelsViewController () <UITableViewDataSource, UITableViewDelegate, ChannelNewViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *channelNewButton;
@property (nonatomic, weak) IBOutlet UITableView *channelsTableView;

@end

@implementation ChannelsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self == nil) {
    return nil;
  }

  self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Channels" image:[[FAKIonIcons iosBellOutlineIconWithSize:35] imageWithSize:CGSizeMake(35, 35)] selectedImage:[[FAKIonIcons iosBellIconWithSize:35] imageWithSize:CGSizeMake(35, 35)]];

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Channels";

  self.channelNewButton.image = [[FAKIonIcons plusRoundIconWithSize:25] imageWithSize:CGSizeMake(25, 25)];

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

  self.tabBarController.tabBar.hidden = YES;
}

- (void)channelNewViewController:(ChannelNewViewController *)controller didCreateChannel:(ChannelViewModel *)channelViewModel {
  [controller dismissViewControllerAnimated:YES completion:nil];
  [self.authenticatedUserViewModel.fetchMembershipsCommand execute:nil];
}

- (void)channelNewViewControllerDidCancel:(ChannelNewViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
