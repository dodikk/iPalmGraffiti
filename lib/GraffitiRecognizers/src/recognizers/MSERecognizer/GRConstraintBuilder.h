#include "GRStrokeConstraints.h"
#import <Foundation/Foundation.h>


@interface GRConstraintBuilder : NSObject 

+(GRStrokeConstraints)getConstraintForxBeg:( CGFloat )x_beg_
                                      xFin:( CGFloat )x_fin_
                                      yBeg:( CGFloat )y_beg_
                                      yFin:( CGFloat )y_fin_;

+(BOOL)matchConstraint:( GRStrokeConstraints )first_
 andExpectedConstraint:( GRStrokeConstraints )second_;

@end
