#import <Foundation/Foundation.h>

#import "YTUser.h"
#import "YTMembership.h"
#import "YTChannel.h"
#import "YTFeed.h"

#import "YTAPIClient.h"

@interface YTAPIContext : NSObject

@property (nonatomic, readonly) YTAPIClient *apiClient;
@property (nonatomic, readonly) NSURL *apiBaseURL;
@property (nonatomic, readonly) NSInteger version;
@property (nonatomic) NSString *accessToken;

+ (YTAPIContext *)sharedInstance;

@end
