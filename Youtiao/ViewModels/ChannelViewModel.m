#import "ChannelViewModel.h"

@implementation ChannelViewModel

- (NSString *)name {
  return self.membership.channel.name;
}

@end
