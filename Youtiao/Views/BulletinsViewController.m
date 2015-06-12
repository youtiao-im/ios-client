#import "BulletinsViewController.h"
#import "BulletinViewController.h"
#import "BulletinTableViewCell.h"


@interface BulletinsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *bulletinsTableView;

@end


@implementation BulletinsViewController

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

  UINib *nib = [UINib nibWithNibName:@"BulletinTableViewCell" bundle:nil];
  [self.bulletinsTableView registerNib:nib forCellReuseIdentifier:@"BulletinCell"];

  self.bulletinsTableView.rowHeight = UITableViewAutomaticDimension;
  self.bulletinsTableView.estimatedRowHeight = 160.0;
  self.bulletinsTableView.dataSource = self;
  self.bulletinsTableView.delegate = self;
}

- (void)bindViewModels {
  @weakify(self);
  [self.authenticatedUserViewModel.fetchBulletinsCommand.executionSignals subscribeNext:^(RACSignal *signal) {
    [signal subscribeNext:^(id x) {
      @strongify(self);
      [self.bulletinsTableView reloadData];
    }];
  }];

  [self.authenticatedUserViewModel.fetchBulletinsCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSIndexPath *selectedIndexPath = [self.bulletinsTableView indexPathForSelectedRow];
  [self.bulletinsTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.authenticatedUserViewModel numberOfBulletins];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BulletinCell"];
  ((BulletinTableViewCell *) cell).bulletinViewModel = [self.authenticatedUserViewModel bulletinViewModelAtIndex:indexPath.row];
  return cell;
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
    bulletinViewController.bulletinViewModel = [self.authenticatedUserViewModel bulletinViewModelAtIndex:indexPath.row];
  }
}

@end
