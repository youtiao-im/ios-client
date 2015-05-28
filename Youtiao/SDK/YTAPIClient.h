#import <Foundation/Foundation.h>

@class YTUser;
@class YTMembership;
@class YTChannel;
@class YTFeed;

@class YTAPIContext;

@interface YTAPIClient : NSObject

- (id)initWithAPIContext:(YTAPIContext *)apiContext;

- (void)setAccessToken:(NSString *)accessToken;

- (void)fetchAuthenticatedUserWithSuccess:(void(^)(YTUser *user))success failure:(void(^)(NSError *error))failure;
- (void)fetchMembershipsOfAuthenticatedUserWithSuccess:(void(^)(NSArray *memberships))success failure:(void(^)(NSError *error))failure;

- (void)fetchFeedsOfChannel:(NSString *)channelId success:(void(^)(NSArray *feeds))success failure:(void(^)(NSError *error))failure;

@end
