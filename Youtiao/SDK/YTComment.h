#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class YTUser;

@interface YTComment : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) YTUser *createdBy;

- (id)initWithText:(NSString *)text;

@end
