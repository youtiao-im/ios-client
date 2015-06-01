#import <Foundation/Foundation.h>


@class YTUser, YTMembership, YTChannel, YTFeed, YTComment;
@class YTAPIContext;

@interface YTAPIClient : NSObject

- (id)initWithAPIContext:(YTAPIContext *)apiContext;

- (void)setAccessToken:(NSString *)accessToken;

- (void)fetchAuthenticatedUserWithSuccess:(void(^)(YTUser *user))success failure:(void(^)(NSError *error))failure;
- (void)fetchMembershipsOfAuthenticatedUserWithSuccess:(void(^)(NSArray *memberships))success failure:(void(^)(NSError *error))failure;

- (void)createChannel:(YTChannel *)channel success:(void(^)(YTChannel *channel))success failure:(void(^)(NSError *error))failure;
- (void)fetchFeedsOfChannel:(NSString *)channelId success:(void(^)(NSArray *feeds))success failure:(void(^)(NSError *error))failure;
- (void)fetchMembershipsOfChannel:(NSString *)channelId success:(void(^)(NSArray *feeds))success failure:(void(^)(NSError *error))failure;

- (void)createFeed:(YTFeed *)feed forChannel:(NSString *)channelId success:(void(^)(YTFeed *feed))success failure:(void(^)(NSError *error))failure;
- (void)fetchCommentsOfFeed:(NSString *)feedId success:(void(^)(NSArray *feeds))success failure:(void(^)(NSError *error))failure;

- (void)createComment:(YTComment *)comment forFeed:(NSString *)feedId success:(void(^)(YTComment *comment))success failure:(void(^)(NSError *error))failure;

@end
