#import "GroupsViewController.h"
#import "GroupBulletinsViewController.h"
#import "GroupNewViewController.h"


@interface GroupsViewController () <UITableViewDataSource, UITableViewDelegate, GroupNewViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *groupNewBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;

@end


@implementation GroupsViewController

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

  self.groupsTableView.rowHeight = UITableViewAutomaticDimension;
  self.groupsTableView.estimatedRowHeight = 65.0;
  self.groupsTableView.dataSource = self;
  self.groupsTableView.delegate = self;
}

- (void)bindViewModels {
  @weakify(self);
  [self.authenticatedUserViewModel.fetchGroupsCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      [self.groupsTableView reloadData];
    }];
  }];

  [self.authenticatedUserViewModel.fetchGroupsCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSIndexPath *selectedIndexPath = [self.groupsTableView indexPathForSelectedRow];
  [self.groupsTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.authenticatedUserViewModel numberOfGroups];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GroupCell"];
  }
  cell.textLabel.text = [self.authenticatedUserViewModel groupViewModelAtIndex:indexPath.row].name;
  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController *viewController = segue.destinationViewController;
  if ([viewController isMemberOfClass:[GroupBulletinsViewController class]]) {
    GroupBulletinsViewController *groupBulletinsViewController = ((GroupBulletinsViewController *) viewController);
    NSIndexPath *indexPath = [self.groupsTableView indexPathForSelectedRow];
    groupBulletinsViewController.groupViewModel = [self.authenticatedUserViewModel groupViewModelAtIndex:indexPath.row];
  } else if ([viewController isMemberOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)viewController;
    UIViewController *rootViewController = [navigationController.viewControllers objectAtIndex:0];
    if ([rootViewController isMemberOfClass:[GroupNewViewController class]]) {
      GroupNewViewController *groupNewViewController = (GroupNewViewController *) rootViewController;
      groupNewViewController.groupNewViewModel = [[GroupNewViewModel alloc] init];
      groupNewViewController.delegate = self;
    }
  }
}

- (void)groupNewViewController:(GroupNewViewController *)controller didCreateGroup:(GroupViewModel *)groupViewModel {
  [controller dismissViewControllerAnimated:YES completion:nil];
  [self.authenticatedUserViewModel.fetchGroupsCommand execute:nil];
}

- (void)groupNewViewControllerDidCancel:(GroupNewViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
