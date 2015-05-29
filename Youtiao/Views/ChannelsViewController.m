#import "ChannelsViewController.h"

#import "ChannelsViewModel.h"
#import "ChannelViewModel.h"

@interface ChannelsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *channelsTableView;

@end

@implementation ChannelsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.channelsTableView.dataSource = self;
  self.channelsTableView.delegate = self;

  self.channelsViewModel = [[ChannelsViewModel alloc] init];

  [[[self.channelsViewModel fetchChannelsCommand] executionSignals] subscribeNext:^(id x) {
    NSLog(@"got");
  } error:^(NSError *error) {
    NSLog(@"got");
  }];

  // TODO: do we need weak/strong dance?
  [[[self.channelsViewModel fetchChannelsCommand] execute:nil] subscribeCompleted:^{
    NSLog(@"fetched channels");
    [self.channelsTableView reloadData];
  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.channelsViewModel numberOfChannels];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ChannelCell"];
  }

  ChannelViewModel *channelViewModel = [self.channelsViewModel channelViewModelAtIndex:indexPath.row];
  cell.textLabel.text = channelViewModel.name;
  return cell;
}

@end
