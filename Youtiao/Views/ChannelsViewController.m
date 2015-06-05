#import "ChannelsViewController.h"
#import <FontAwesomeKit/FAKIonIcons.h>
#import "ChannelFeedsViewController.h"
#import "ChannelNewViewController.h"
#import "ChannelTableViewCell.h"


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

  self.channelsTableView.rowHeight = UITableViewAutomaticDimension;
  self.channelsTableView.estimatedRowHeight = 65.0;
  self.channelsTableView.dataSource = self;
  self.channelsTableView.delegate = self;
}

- (void)bindViewModels {
  @weakify(self);
  [self.authenticatedUserViewModel.fetchChannelsCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      [self.channelsTableView reloadData];
    }];
  }];

  [self.authenticatedUserViewModel.fetchChannelsCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSIndexPath *selectedIndexPath = [self.channelsTableView indexPathForSelectedRow];
  [self.channelsTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.authenticatedUserViewModel numberOfChannels];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // TODO:
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell"];
  ((ChannelTableViewCell *) cell).channelViewModel = [self.authenticatedUserViewModel channelViewModelAtIndex:indexPath.row];
  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController *viewController = segue.destinationViewController;
  if ([viewController isMemberOfClass:[ChannelFeedsViewController class]]) {
    ChannelFeedsViewController *channelFeedsViewController = ((ChannelFeedsViewController *) viewController);
    NSIndexPath *indexPath = [self.channelsTableView indexPathForSelectedRow];
    channelFeedsViewController.channelViewModel = [self.authenticatedUserViewModel channelViewModelAtIndex:indexPath.row];
  } else if ([viewController isMemberOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)viewController;
    UIViewController *rootViewController = [navigationController.viewControllers objectAtIndex:0];
    if ([rootViewController isMemberOfClass:[ChannelNewViewController class]]) {
      ChannelNewViewController *channelNewViewController = (ChannelNewViewController *) rootViewController;
      channelNewViewController.channelNewViewModel = [[ChannelNewViewModel alloc] init];
      channelNewViewController.delegate = self;
    }
  }
}

- (void)channelNewViewController:(ChannelNewViewController *)controller didCreateChannel:(ChannelViewModel *)channelViewModel {
  [controller dismissViewControllerAnimated:YES completion:nil];
  [self.authenticatedUserViewModel.fetchChannelsCommand execute:nil];
}

- (void)channelNewViewControllerDidCancel:(ChannelNewViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
