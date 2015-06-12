#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class YTGroup, YTMembership, YTStamp;

@interface YTBulletin : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *groupId;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *createdByType;
@property (nonatomic, readonly) NSString *createdById;
@property (nonatomic, readonly) NSInteger checksCount;
@property (nonatomic, readonly) NSInteger crossesCount;
@property (nonatomic, readonly) NSInteger commentsCount;
@property (nonatomic, readonly) YTGroup *group;
@property (nonatomic, readonly) YTMembership *createdBy;
@property (nonatomic, readonly) YTStamp *stamp;

- (id)initWithText:(NSString *)text;

@end
