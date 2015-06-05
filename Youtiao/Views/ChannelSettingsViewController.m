#import "ChannelSettingsViewController.h"


@interface ChannelSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *membershipsTableView;

@end

@implementation ChannelSettingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self configViews];
  [self bindViewModels];
}

- (void)configViews {
  self.title = self.channelViewModel.name;
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

  self.membershipsTableView.rowHeight = UITableViewAutomaticDimension;
  self.membershipsTableView.dataSource = self;
  self.membershipsTableView.delegate = self;
}

- (void)bindViewModels {
  // TODO: do we need weak/strong dance?
  [[self.channelViewModel.fetchMembershipsCommand execute:nil] subscribeCompleted:^{
    [self.membershipsTableView reloadData];
  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.channelViewModel numberOfMemberships];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // TODO:
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UserCell"];
  }

  MembershipViewModel *membershipViewModel = [self.channelViewModel membershipViewModelAtIndex:indexPath.row];
  cell.textLabel.text = [membershipViewModel userViewModel].email;
  return cell;
}

@end
