#import <Foundation/Foundation.h>


@interface GRImageRecognizer : NSObject 

-(NSArray*)recognizeLetterByXPoints:( CGFloat* )x_points_
                            yPoints:( CGFloat* )y_points_
                              count:( NSUInteger )points_count_;

@end
