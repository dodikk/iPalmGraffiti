#import "GRGraffitiRecognizerState.h"
#import <Foundation/Foundation.h>


@interface GRMseNormalizer : NSObject 

+(void)normalizeXData:( CGFloat*   )x_points_
                yData:( CGFloat*   )y_points_
          pointsCount:( NSUInteger )points_count_
        segmentsCount:( NSUInteger )segments_count_
               result:( GRGraffitiRecognizerState* )result_;


+(CGFloat)getDistanceForX1:( CGFloat*   )x1_
                        Y1:( CGFloat*   )y1_
                        X2:( CGFloat*   )x2_
                        Y2:( CGFloat*   )y2_
                     count:( NSUInteger )count_;

@end
