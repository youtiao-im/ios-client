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
  _accessToken = @"a3071d473601060c1530bce26b6a8c26e32684cd0aab9ca5c6851a907ca69506";

  _apiClient = [[YTAPIClient alloc] initWithAPIContext:self];

  return self;
}

@end
