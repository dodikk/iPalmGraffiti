#import "GRGraffitiAlphabets.h"
#import <Foundation/Foundation.h>


@protocol GRImageRecognizer < NSObject >

+(id<GRImageRecognizer>)recognizerWithAlphabetId:( GRGraffitiAlphabets )alphabet_id_;

-(NSArray*)recognizeLetterByXPoints:( CGFloat* )x_points_
                            yPoints:( CGFloat* )y_points_
                              count:( NSUInteger )points_count_;

@end
