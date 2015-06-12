#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class YTGroup, YTUser;

@interface YTMembership : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *groupId;
@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) NSString *role;
@property (nonatomic, readonly) NSString *alias;
@property (nonatomic, readonly) YTGroup *group;
@property (nonatomic, readonly) YTUser *user;

@end
