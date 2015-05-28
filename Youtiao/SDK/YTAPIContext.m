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

  if (self) {
    _apiBaseURL = [NSURL URLWithString:@"http://192.168.200.152:3000/api"];
    _version = 1;
    // TODO:
    _accessToken = @"dc10bdfacfab9f025aaf9fd11ad391c77534e26768a3b38aba690b28a5098b9b";

    _apiClient = [[YTAPIClient alloc] initWithAPIContext:self];
  }

  return self;
}

@end
