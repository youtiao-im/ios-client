#import <Foundation/Foundation.h>
#import "YTUser.h"
#import "YTGroup.h"
#import "YTMembership.h"
#import "YTBulletin.h"
#import "YTComment.h"
#import "YTStamp.h"
#import "YTAPIClient.h"


@interface YTAPIContext : NSObject

@property (nonatomic, readonly) YTAPIClient *apiClient;
@property (nonatomic, readonly) NSURL *apiBaseURL;
@property (nonatomic) NSString *accessToken;

+ (YTAPIContext *)sharedInstance;

@end
