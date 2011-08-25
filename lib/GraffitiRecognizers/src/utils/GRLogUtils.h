#import <Foundation/Foundation.h>


@interface GRLogUtils : NSObject 

+(void)dumpError:( NSError* )error_
     withMessage:( NSString* )str_message_;

@end
