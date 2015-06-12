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
  _accessToken = @"a79d0595b0202dc7537354001183b357de6506c725d9339eb3f8ef6da9c9be39";

  _apiClient = [[YTAPIClient alloc] initWithAPIContext:self];

  return self;
}

@end
