#import "YTAPIContext.h"

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

SpecBegin(Channel)

describe(@"-fetchAuthenticatedUserWithSuccess", ^{
  it(@"returns user", ^{
    waitUntil(^(DoneCallback done) {
      [[[YTAPIContext sharedInstance] apiClient] fetchAuthenticatedUserWithSuccess:^(YTUser *user) {
        expect(user).notTo.beNil();
        done();
      } failure:^(NSError *error) {
        failure(error.description);
        done();
      }];
    });
  });
});

describe(@"-fetchMembershipsOfAuthenticatedUserWithSuccess", ^{
  it(@"returns memberships", ^{
    waitUntil(^(DoneCallback done) {
      [[[YTAPIContext sharedInstance] apiClient] fetchMembershipsOfAuthenticatedUserWithSuccess:^(NSArray *memberships) {
        expect(memberships).notTo.beNil();
        done();
      } failure:^(NSError *error) {
        failure(error.description);
        done();
      }];
    });
  });
});

describe(@"-fetchFeedsOfChannel", ^{
  it(@"returns feeds", ^{
    waitUntil(^(DoneCallback done) {
      [[[YTAPIContext sharedInstance] apiClient] fetchFeedsOfChannel:@"GPyYROY7" success:^(NSArray *feeds) {
        expect(feeds).notTo.beNil();
        done();
      } failure:^(NSError *error) {
        failure(error.description);
        done();
      }];
    });
  });
});

SpecEnd
