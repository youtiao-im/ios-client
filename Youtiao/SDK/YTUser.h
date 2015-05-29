#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface YTUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *email;

@end
