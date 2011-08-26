#import "GRConstraintBuilder.h"


@implementation GRConstraintBuilder

+(GRStrokeConstraints)startConstraintToEndConstraint:(GRStrokeConstraints)start_constraint_
{
   return start_constraint_ << 4;
}

+(GRStrokeConstraints)getConstraintForxBeg:( CGFloat )x_
                                      xFin:( CGFloat )y_
{
   NSAssert( fabs( x_ ) <= 1, @"The x_ value has not been normalized" );
   NSAssert( fabs( y_ ) <= 1, @"The y_ value has not been normalized" );
   
   static const CGFloat middle_point_ = 0.5f;
   
   if ( x_ <= middle_point_ && y_ <= middle_point_ )
   {
      return StartTopLeft;
   }
   else if ( x_ <= middle_point_ && y_ > middle_point_ )
   {
      return StartBottomLeft;
   }
   else if ( x_ > middle_point_ && y_ <= middle_point_ )
   {
      return StartTopRight;
   }
   else //if ( x_ > middle_point_ && y_ > middle_point_ )
   {
      return StartBottomRight;
   }
   
   NSAssert( NO, @"Unexpected condition result" );
   return 0;
}

+(GRStrokeConstraints)getConstraintForxBeg:( CGFloat )x_beg_
                                      xFin:( CGFloat )x_fin_
                                      yBeg:( CGFloat )y_beg_
                                      yFin:( CGFloat )y_fin_
{
   GRStrokeConstraints start_ = [ self getConstraintForxBeg: x_beg_
                                                       xFin: y_beg_ ];
   
   GRStrokeConstraints end_   = [ self getConstraintForxBeg: x_fin_
                                                       xFin: y_fin_ ];
   end_ = [ self startConstraintToEndConstraint: end_ ];
   
   return start_ | end_;
}

+(BOOL)matchConstraint:( GRStrokeConstraints )first_
 andExpectedConstraint:( GRStrokeConstraints )second_;
{
   //second includes first as a subset
   return first_ & ~second_;
}

@end
