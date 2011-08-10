#import <Foundation/Foundation.h>


@interface GRPointsDumper : NSObject 

+(void)dumpToFileXPoints:( CGFloat* )x_points_
                 yPoints:( CGFloat* )y_points_
                   count:( NSUInteger )points_count_;

@end
