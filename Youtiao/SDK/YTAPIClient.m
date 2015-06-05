#import "YTAPIClient.h"
#import <AFNetworking/AFNetworking.h>
#import "YTAPIContext.h"


@interface YTAPIClient ()

@property (nonatomic) AFHTTPRequestOperationManager *manager;

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

- (void)fetchFeedsOfAuthenticatedUserWithSuccess:(void (^)(NSArray *feeds))success failure:(void (^)(NSError *error))failure {
  [self.manager GET:@"user/feeds" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)fetchMemberedChannelsWithSuccess:(void (^)(NSArray *channels))success failure:(void (^)(NSError *error))failure {
  [self.manager GET:@"user/membered_channels" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSArray *channels = [MTLJSONAdapter modelsOfClass:[YTChannel class] fromJSONArray:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(channels);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)joinChannel:(NSString *)channelId success:(void(^)(YTChannel *channel))success failure:(void(^)(NSError *error))failure {
  [self.manager PUT:[NSString stringWithFormat:@"user/membered_channels/%@", channelId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)markFeed:(NSString *)feedId withSymbol:(NSString *)symbol success:(void(^)(YTFeed *feed))success failure:(void(^)(NSError *error))failure; {
  YTMark *mark = [[YTMark alloc] initWithSymbol:symbol];
  NSError *error = nil;
  NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:mark error:&error];
  if (error != nil) {
    failure(error);
    return;
  }

  [self.manager PUT:[NSString stringWithFormat:@"user/marked_feeds/%@", feedId] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)fetchMarksOfFeed:(NSString *)feedId success:(void(^)(NSArray *marks))success failure:(void(^)(NSError *error))failure {
  [self.manager GET:[NSString stringWithFormat:@"feeds/%@/marks", feedId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSArray *marks = [MTLJSONAdapter modelsOfClass:[YTMark class] fromJSONArray:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(marks);
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
