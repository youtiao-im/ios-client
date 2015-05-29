#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class YTUser;

@interface YTChannel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) YTUser *createdBy;

- (id)initWithName:(NSString *)name;

@end
