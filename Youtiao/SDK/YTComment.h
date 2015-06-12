#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class YTBulletin, YTMembership;

@interface YTComment : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *bulletinId;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *createdByType;
@property (nonatomic, readonly) NSString *createdById;
@property (nonatomic, readonly) YTBulletin *bulletin;
@property (nonatomic, readonly) YTMembership *createdBy;

- (id)initWithText:(NSString *)text;

@end
