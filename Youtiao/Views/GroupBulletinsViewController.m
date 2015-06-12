#import "GroupBulletinsViewController.h"
#import "GroupSettingsViewController.h"
#import "BulletinNewViewController.h"
#import "BulletinViewController.h"
#import "BulletinTableViewCell.h"


@interface GroupBulletinsViewController () <UITableViewDataSource, UITableViewDelegate, BulletinNewViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *groupSettingsBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *bulletinsTableView;

@end


@implementation GroupBulletinsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self configViews];
  [self bindViewModels];
}

- (void)configViews {
  self.title = self.groupViewModel.name;
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

  UIImage *addIconImage = [UIImage imageNamed:@"quill"];
  UIBarButtonItem *bulletinNewBarButtonItem = [[UIBarButtonItem alloc] initWithImage:addIconImage style:UIBarButtonItemStylePlain target:self action:@selector(performBulletinNewSegue)];
  [bulletinNewBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -30, 0, -60)];
  [self.navigationItem setRightBarButtonItems:@[[self.navigationItem rightBarButtonItem], bulletinNewBarButtonItem]];

  UINib *nib = [UINib nibWithNibName:@"BulletinTableViewCell" bundle:nil];
  [self.bulletinsTableView registerNib:nib forCellReuseIdentifier:@"BulletinCell"];

  self.bulletinsTableView.rowHeight = UITableViewAutomaticDimension;
  self.bulletinsTableView.estimatedRowHeight = 160.0;
  self.bulletinsTableView.dataSource = self;
  self.bulletinsTableView.delegate = self;
}

- (void)bindViewModels {
  @weakify(self);
  [self.groupViewModel.fetchBulletinsCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      [self.bulletinsTableView reloadData];
    }];
  }];

  [self.groupViewModel.fetchBulletinsCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSIndexPath *selectedIndexPath = [self.bulletinsTableView indexPathForSelectedRow];
  [self.bulletinsTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.groupViewModel numberOfBulletins];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BulletinTableViewCell *bulletinCell = [tableView dequeueReusableCellWithIdentifier:@"BulletinCell"];
  BulletinViewModel *bulletinViewModel = [self.groupViewModel bulletinViewModelAtIndex:indexPath.row];
  bulletinCell.bulletinViewModel = bulletinViewModel;
  return bulletinCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"BulletinSegue" sender:self];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }

  if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    [cell setPreservesSuperviewLayoutMargins:NO];
  }

  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController *viewController = segue.destinationViewController;
  if ([viewController isMemberOfClass:[BulletinViewController class]]) {
    BulletinViewController * bulletinViewController = (BulletinViewController *) viewController;
    NSIndexPath *indexPath = [self.bulletinsTableView indexPathForSelectedRow];
    bulletinViewController.bulletinViewModel = [self.groupViewModel bulletinViewModelAtIndex:indexPath.row];
  } else if ([viewController isMemberOfClass:[GroupSettingsViewController class]]) {
    GroupSettingsViewController * groupSettingsViewController = (GroupSettingsViewController *) viewController;
    groupSettingsViewController.groupViewModel = self.groupViewModel;
  } else if ([viewController isMemberOfClass:[UINavigationController class]]) {
    UINavigationController* navigationController = (UINavigationController *)viewController;
    UIViewController *rootViewController = [navigationController.viewControllers objectAtIndex:0];
    if ([rootViewController isMemberOfClass:[BulletinNewViewController class]]) {
      BulletinNewViewController *bulletinNewViewController = (BulletinNewViewController *) rootViewController;
      bulletinNewViewController.bulletinNewViewModel = [self.groupViewModel bulletinNewViewModel];
      bulletinNewViewController.delegate = self;
    }
  }
}

- (void)bulletinNewViewController:(BulletinNewViewController *)controller didCreateBulletin:(BulletinViewModel *)bulletinViewModel {
  [controller dismissViewControllerAnimated:YES completion:nil];
  [self.groupViewModel.fetchBulletinsCommand execute:nil];
}

- (void)bulletinNewViewControllerDidCancel:(BulletinNewViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)performBulletinNewSegue{
  [self performSegueWithIdentifier:@"BulletinNewSegue" sender:self];
}

@end
