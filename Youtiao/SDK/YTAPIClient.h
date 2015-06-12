#import <Foundation/Foundation.h>


@class YTUser, YTGroup, YTMembership, YTBulletin, YTComment, YTStamp;
@class YTAPIContext;

@interface YTAPIClient : NSObject

- (id)initWithAPIContext:(YTAPIContext *)apiContext;

- (void)setAccessToken:(NSString *)accessToken;

- (void)fetchAuthenticatedUserWithSuccess:(void(^)(YTUser *user))success failure:(void(^)(NSError *error))failure;

- (void)fetchGroupsWithSuccess:(void(^)(NSArray *groups))success failure:(void(^)(NSError *error))failure;
- (void)createGroup:(YTGroup *)group success:(void(^)(YTGroup *group))success failure:(void(^)(NSError *error))failure;
- (void)joinGroup:(NSString *)groupId success:(void(^)(YTGroup *group))success failure:(void(^)(NSError *error))failure;

- (void)fetchMembershipsOfGroup:(NSString *)groupId success:(void(^)(NSArray *memberships))success failure:(void(^)(NSError *error))failure;

- (void)fetchBulletinsWithSuccess:(void (^)(NSArray *bulletins))success failure:(void (^)(NSError *error))failure;
- (void)fetchBulletinsOfGroup:(NSString *)groupId success:(void(^)(NSArray *bulletins))success failure:(void(^)(NSError *error))failure;
- (void)createBulletin:(YTBulletin *)bulletin forGroup:(NSString *)groupId success:(void(^)(YTBulletin *bulletin))success failure:(void(^)(NSError *error))failure;
- (void)stampBulletin:(NSString *)bulletinId withSymbol:(NSString *)symbol success:(void(^)(YTBulletin *bulletin))success failure:(void(^)(NSError *error))failure;

- (void)fetchStampsOfBulletin:(NSString *)bulletinId success:(void(^)(NSArray *stamps))success failure:(void(^)(NSError *error))failure;

- (void)fetchCommentsOfBulletin:(NSString *)bulletinId success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
- (void)createComment:(YTComment *)comment forBulletin:(NSString *)bulletinId success:(void(^)(YTComment *comment))success failure:(void(^)(NSError *error))failure;

@end
