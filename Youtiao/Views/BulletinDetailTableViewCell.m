#import "BulletinDetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation BulletinDetailTableViewCell

- (void)setBulletinViewModel:(BulletinViewModel *)bulletinViewModel {
  _bulletinViewModel = bulletinViewModel;
  [self bindViewModels];
}

- (void)bindViewModels {
  [self.createdByAvatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://7pn5p7.com1.z0.glb.clouddn.com/Fjjevc7FDWqgIHZtiC57nHqnrtMH"]];
  self.createdByNameLabel.text = self.bulletinViewModel.createdByName;
  self.groupNameLabel.text = [NSString stringWithFormat:@"#%@", self.bulletinViewModel.groupName];
  // TODO:
  self.textContentLabel.text = self.bulletinViewModel.text;
}

@end
