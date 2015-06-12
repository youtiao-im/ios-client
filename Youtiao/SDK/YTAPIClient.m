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

- (void)fetchAuthenticatedUserWithSuccess:(void(^)(YTUser *user))success failure:(void(^)(NSError *error))failure {
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

- (void)fetchGroupsWithSuccess:(void(^)(NSArray *groups))success failure:(void(^)(NSError *error))failure {
  [self.manager GET:@"groups" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSArray *groups = [MTLJSONAdapter modelsOfClass:[YTGroup class] fromJSONArray:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(groups);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)createGroup:(YTGroup *)group success:(void(^)(YTGroup *group))success failure:(void(^)(NSError *error))failure {
  NSError *error = nil;
  NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:group error:&error];
  if (error != nil) {
    failure(error);
    return;
  }

  [self.manager POST:@"groups" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    YTGroup *group = [MTLJSONAdapter modelOfClass:[YTGroup class] fromJSONDictionary:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(group);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)joinGroup:(NSString *)groupId success:(void(^)(YTGroup *group))success failure:(void(^)(NSError *error))failure {
  [self.manager POST:[NSString stringWithFormat:@"groups/%@/join", groupId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    YTGroup *group = [MTLJSONAdapter modelOfClass:[YTGroup class] fromJSONDictionary:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(group);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)fetchMembershipsOfGroup:(NSString *)groupId success:(void(^)(NSArray *memberships))success failure:(void(^)(NSError *error))failure {
  [self.manager GET:[NSString stringWithFormat:@"groups/%@/memberships", groupId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)fetchBulletinsWithSuccess:(void (^)(NSArray *bulletins))success failure:(void (^)(NSError *error))failure {
  [self.manager GET:@"bulletins" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSArray *bulletins = [MTLJSONAdapter modelsOfClass:[YTBulletin class] fromJSONArray:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(bulletins);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)fetchBulletinsOfGroup:(NSString *)groupId success:(void(^)(NSArray *bulletins))success failure:(void(^)(NSError *error))failure {
  [self.manager GET:[NSString stringWithFormat:@"groups/%@/bulletins", groupId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSArray *bulletins = [MTLJSONAdapter modelsOfClass:[YTBulletin class] fromJSONArray:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(bulletins);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)createBulletin:(YTBulletin *)bulletin forGroup:(NSString *)groupId success:(void(^)(YTBulletin *bulletin))success failure:(void(^)(NSError *error))failure {
  NSError *error = nil;
  NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:bulletin error:&error];
  if (error != nil) {
    failure(error);
    return;
  }

  [self.manager POST:[NSString stringWithFormat:@"groups/%@/bulletins", groupId] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    YTBulletin *bulletin = [MTLJSONAdapter modelOfClass:[YTBulletin class] fromJSONDictionary:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(bulletin);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)stampBulletin:(NSString *)bulletinId withSymbol:(NSString *)symbol success:(void(^)(YTBulletin *bulletin))success failure:(void(^)(NSError *error))failure {
  YTStamp *stamp = [[YTStamp alloc] initWithSymbol:symbol];
  NSError *error = nil;
  NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:stamp error:&error];
  if (error != nil) {
    failure(error);
    return;
  }

  [self.manager POST:[NSString stringWithFormat:@"bulletins/%@/stamp", bulletinId] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    YTBulletin *bulletin = [MTLJSONAdapter modelOfClass:[YTBulletin class] fromJSONDictionary:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(bulletin);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)fetchStampsOfBulletin:(NSString *)bulletinId success:(void(^)(NSArray *stamps))success failure:(void(^)(NSError *error))failure {
  [self.manager GET:[NSString stringWithFormat:@"bulletins/%@/stamps", bulletinId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSArray *stamps = [MTLJSONAdapter modelsOfClass:[YTStamp class] fromJSONArray:responseObject error:&error];
    if (error != nil) {
      failure(error);
    } else {
      success(stamps);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)fetchCommentsOfBulletin:(NSString *)bulletinId success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure {
  [self.manager GET:[NSString stringWithFormat:@"bulletins/%@/comments", bulletinId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)createComment:(YTComment *)comment forBulletin:(NSString *)bulletinId success:(void(^)(YTComment *comment))success failure:(void(^)(NSError *error))failure {
  NSError *error = nil;
  NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:comment error:&error];
  if (error != nil) {
    failure(error);
    return;
  }

  [self.manager POST:[NSString stringWithFormat:@"bulletins/%@/comments", bulletinId] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
