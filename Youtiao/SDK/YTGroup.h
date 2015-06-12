#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class YTUser, YTMembership;

@interface YTGroup : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger membershipsCount;
@property (nonatomic, readonly) YTMembership *membership;

- (id)initWithName:(NSString *)name;

@end
