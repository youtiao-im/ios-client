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

  _apiBaseURL = [NSURL URLWithString:@"http://192.168.200.152:3000/api"];
  _version = 1;
  // TODO:
  _accessToken = @"0852ccaf3aa26354a0b80225109eee09268dc81c7ed37042610ef1e4e24679ae";

  _apiClient = [[YTAPIClient alloc] initWithAPIContext:self];

  return self;
}

@end
