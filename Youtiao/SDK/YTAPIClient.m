#import "YTAPIClient.h"

#import <AFNetworking/AFNetworking.h>
#import "YTAPIContext.h"

@interface YTAPIClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation YTAPIClient

- (id)initWithAPIContext:(YTAPIContext *)apiContext {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:apiContext.apiBaseURL];
  _manager.requestSerializer = [AFJSONRequestSerializer serializer];
  _manager.responseSerializer = [AFJSONResponseSerializer serializer];

  [_manager.requestSerializer setValue:[NSString stringWithFormat:@"application/vnd.youtiao.im+json; version=%ld", (long)apiContext.version] forHTTPHeaderField:@"Accept"];
  [self setAccessToken:apiContext.accessToken];

  return self;
}

- (void)setAccessToken:(NSString *)accessToken {
  [self.manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
}

- (void)fetchAuthenticatedUserWithSuccess:(void (^)(YTUser *user))success failure:(void (^)(NSError *error))failure {
  [self.manager GET:@"user" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    YTUser *user = [MTLJSONAdapter modelOfClass:[YTUser class] fromJSONDictionary:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(user);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)fetchMembershipsOfAuthenticatedUserWithSuccess:(void (^)(NSArray *memberships))success failure:(void (^)(NSError *error))failure {
  [self.manager GET:@"user/memberships" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSArray *memberships = [MTLJSONAdapter modelsOfClass:[YTMembership class] fromJSONArray:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(memberships);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)createChannel:(YTChannel *)channel success:(void(^)(YTChannel *channel))success failure:(void(^)(NSError *error))failure {
  NSError *error = nil;
  NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:channel error:&error];
  if (error != nil) {
    failure(error);
    return;
  }

  [self.manager POST:@"channels" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    YTChannel *channel = [MTLJSONAdapter modelOfClass:[YTChannel class] fromJSONDictionary:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(channel);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)fetchFeedsOfChannel:(NSString *)channelId success:(void(^)(NSArray *feeds))success failure:(void(^)(NSError *error))failure {
  [self.manager GET:[NSString stringWithFormat:@"channels/%@/feeds", channelId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSArray *feeds = [MTLJSONAdapter modelsOfClass:[YTFeed class] fromJSONArray:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(feeds);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)fetchMembershipsOfChannel:(NSString *)channelId success:(void(^)(NSArray *feeds))success failure:(void(^)(NSError *error))failure {
  [self.manager GET:[NSString stringWithFormat:@"channels/%@/memberships", channelId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSArray *memberships = [MTLJSONAdapter modelsOfClass:[YTMembership class] fromJSONArray:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(memberships);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)createFeed:(YTFeed *)feed forChannel:(NSString *)channelId success:(void(^)(YTFeed *feed))success failure:(void(^)(NSError *error))failure {
  NSError *error = nil;
  NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:feed error:&error];
  if (error != nil) {
    failure(error);
    return;
  }

  [self.manager POST:[NSString stringWithFormat:@"channels/%@/feeds", channelId] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    YTFeed *feed = [MTLJSONAdapter modelOfClass:[YTFeed class] fromJSONDictionary:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(feed);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)fetchCommentsOfFeed:(NSString *)feedId success:(void(^)(NSArray *feeds))success failure:(void(^)(NSError *error))failure {
  [self.manager GET:[NSString stringWithFormat:@"feeds/%@/comments", feedId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSArray *comments = [MTLJSONAdapter modelsOfClass:[YTComment class] fromJSONArray:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(comments);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)createComment:(YTComment *)comment forFeed:(NSString *)feedId success:(void(^)(YTComment *commnt))success failure:(void(^)(NSError *error))failure {
  NSError *error = nil;
  NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:comment error:&error];
  if (error != nil) {
    failure(error);
    return;
  }

  [self.manager POST:[NSString stringWithFormat:@"feeds/%@/comments", feedId] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    YTComment *comment = [MTLJSONAdapter modelOfClass:[YTComment class] fromJSONDictionary:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(comment);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

@end
