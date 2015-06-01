#import "FeedsViewController.h"

#import <FontAwesomeKit/FAKIonIcons.h>

#import "AuthenticatedUserViewModel.h"

@interface FeedsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *feedsTableView;

@end

@implementation FeedsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self == nil) {
    return nil;
  }

  self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Youtiao" image:[[FAKIonIcons iosHomeOutlineIconWithSize:35] imageWithSize:CGSizeMake(35, 35)] selectedImage:[[FAKIonIcons iosHomeIconWithSize:35] imageWithSize:CGSizeMake(35, 35)]];

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Youtiao";

  self.feedsTableView.dataSource = self;
  self.feedsTableView.delegate = self;

  // TODO: move app delegate
  self.authenticatedUserViewModel = [[AuthenticatedUserViewModel alloc] init];

//  [self bindViewModel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // TODO:
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // TODO:
  return nil;
}

@end
