#import "ChannelViewController.h"

#import "ChannelViewModel.h"
#import "MembershipViewModel.h"
#import "UserViewModel.h"

@interface ChannelViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *membershipsTableView;

@property (nonatomic, strong) ChannelViewModel *channelViewModel;

@end

@implementation ChannelViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.membershipsTableView.dataSource = self;
  self.membershipsTableView.delegate = self;

  [self bindViewModel];
}

- (void)bindViewModel {
  self.channelViewModel = [self.membershipViewModel channelViewModel];

  // TODO:
  self.title = self.channelViewModel.name;

  // TODO: do we need weak/strong dance?
  [[[self.channelViewModel fetchMembershipsCommand] execute:nil] subscribeCompleted:^{
    [self.membershipsTableView reloadData];
  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.channelViewModel numberOfMemberships];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UserCell"];
  }

  MembershipViewModel *membershipViewModel = [self.channelViewModel membershipViewModelAtIndex:indexPath.row];

  cell.textLabel.text = [membershipViewModel userViewModel].email;
  return cell;
}

@end
