#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class YTBulletin, YTMembership;

@interface YTStamp : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *bulletinId;
@property (nonatomic, readonly) NSString *symbol;
@property (nonatomic, readonly) NSString *createdByType;
@property (nonatomic, readonly) NSString *createdById;
@property (nonatomic, readonly) YTBulletin *bulletin;
@property (nonatomic, readonly) YTMembership *createdBy;

- (id)initWithSymbol:(NSString *)symbol;

@end
