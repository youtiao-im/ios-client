#import "SettingsViewController.h"
#import <FontAwesomeKit/FAKIonIcons.h>


@interface SettingsViewController ()

@end


@implementation SettingsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self == nil) {
    return nil;
  }

  self.tabBarItem.image = [[FAKIonIcons iosPersonOutlineIconWithSize:35] imageWithSize:CGSizeMake(35, 35)];
  self.tabBarItem.selectedImage = [[FAKIonIcons iosPersonIconWithSize:35] imageWithSize:CGSizeMake(35, 35)];

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // TODO: move app delegate
  self.authenticatedUserViewModel = [[AuthenticatedUserViewModel alloc] init];

//  [self bindViewModel];
}

@end
