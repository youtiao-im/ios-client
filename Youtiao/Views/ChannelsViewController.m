#import "ChannelsViewController.h"
#import <FontAwesomeKit/FAKIonIcons.h>
#import "ChannelFeedsViewController.h"
#import "ChannelNewViewController.h"


@interface ChannelsViewController () <UITableViewDataSource, UITableViewDelegate, ChannelNewViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *channelNewBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *channelsTableView;

@end


@implementation ChannelsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self == nil) {
    return nil;
  }

  self.tabBarItem.image = [[FAKIonIcons iosBellOutlineIconWithSize:35] imageWithSize:CGSizeMake(35, 35)];
  self.tabBarItem.selectedImage = [[FAKIonIcons iosBellIconWithSize:35] imageWithSize:CGSizeMake(35, 35)];

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
  self.channelNewBarButtonItem.image = [[FAKIonIcons plusRoundIconWithSize:25] imageWithSize:CGSizeMake(25, 25)];

  self.channelsTableView.rowHeight = UITableViewAutomaticDimension;
  self.channelsTableView.estimatedRowHeight = 160.0;
  self.channelsTableView.dataSource = self;
  self.channelsTableView.delegate = self;
}

- (void)bindViewModels {
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
  // TODO:
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
    ChannelFeedsViewController *channelFeedsViewController = ((ChannelFeedsViewController *) viewController);
    NSIndexPath *indexPath = [self.channelsTableView indexPathForSelectedRow];
    channelFeedsViewController.membershipViewModel = [self.authenticatedUserViewModel membershipViewModelAtIndex:indexPath.row];
  } else if ([viewController isMemberOfClass:[ChannelNewViewController class]]) {
    ChannelNewViewController *channelNewViewController = (ChannelNewViewController *) viewController;
    channelNewViewController.channelNewViewModel = [[ChannelNewViewModel alloc] init];
    channelNewViewController.delegate = self;
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
