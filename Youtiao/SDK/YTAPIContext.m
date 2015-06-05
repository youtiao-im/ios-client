#import "YTAPIContext.h"


@implementation YTAPIContext

+ (YTAPIContext *)sharedInstance {
  static YTAPIContext *instance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _apiBaseURL = [NSURL URLWithString:@"http://192.168.200.152:3000/api/v1"];
  // TODO:
  _accessToken = @"e89a9fedd0b03282a0f944ef37a0cc06014affbc4784958903dd4fe5d42cdf6c";

  _apiClient = [[YTAPIClient alloc] initWithAPIContext:self];

  return self;
}

@end
