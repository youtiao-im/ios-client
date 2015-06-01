#import "SettingsViewController.h"

#import <FontAwesomeKit/FAKIonIcons.h>

#import "AuthenticatedUserViewModel.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self == nil) {
    return nil;
  }

  self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:[[FAKIonIcons iosPersonOutlineIconWithSize:35] imageWithSize:CGSizeMake(35, 35)] selectedImage:[[FAKIonIcons iosPersonIconWithSize:35] imageWithSize:CGSizeMake(35, 35)]];

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Me";

  // TODO: move app delegate
  self.authenticatedUserViewModel = [[AuthenticatedUserViewModel alloc] init];

//  [self bindViewModel];
}

@end
