#import <Foundation/Foundation.h>

#import "YTUser.h"
#import "YTMembership.h"
#import "YTChannel.h"
#import "YTFeed.h"
#import "YTComment.h"

#import "YTAPIClient.h"

@interface YTAPIContext : NSObject

@property (nonatomic, strong, readonly) YTAPIClient *apiClient;
@property (nonatomic, strong, readonly) NSURL *apiBaseURL;
@property (nonatomic, readonly) NSInteger version;
@property (nonatomic, strong) NSString *accessToken;

+ (YTAPIContext *)sharedInstance;

@end
