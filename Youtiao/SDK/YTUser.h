#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@interface YTUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *email;

@end
