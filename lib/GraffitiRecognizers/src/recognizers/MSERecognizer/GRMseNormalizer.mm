#import "GRMseNormalizer.h"
#import "GRTypes.h"

@implementation GRMseNormalizer


+(void)getSegmentsLengthVector:( CGFloat*   )result_
                     fromXData:( CGFloat*   )x_points_
                         yData:( CGFloat*   )y_points_
                         count:( NSUInteger )count_

{
   result_[ 0 ] = 0;
   vDSP_vpythg( x_points_    , 1,
                y_points_    , 1,
                x_points_ + 1, 1,
                y_points_ + 1, 1, 
                result_      , 1,
                count_ - 1      );
}


+(void)getSegmentsAccumulatedLengthVector:( CGFloat*   )result_
                                fromXData:( CGFloat*   )x_points_
                                    yData:( CGFloat*   )y_points_
                                    count:( NSUInteger )count_
{
   CGFloat_vt length_entries_( 0, count_ );
   CGFloat* length_entries_start_ = &length_entries_.at( 0 );
   
   [ self getSegmentsLengthVector: length_entries_start_
                        fromXData: x_points_
                            yData: y_points_
                            count: count_ ];
   
   
   static CGFloat modifier_ = 1.f;
   
   vDSP_vrsum ( length_entries_start_, 1,
                &modifier_,
                result_              , 1,
                count_                  );
   

}

+(void)prepareInterpolationCoeffsForAccumulatedLength:( CGFloat_vt* )p_accumulated_sizes_
                                        segmentsXData:( CGFloat_vt* )p_segments_x_data_
                                               result:( CGFloat_vt* )p_interpolation_coeffs_
{
   NSAssert( p_accumulated_sizes_   , @"p_accumulated_sizes_    - unexpected NIL passed" );
   NSAssert( p_segments_x_data_     , @"p_segments_x_data_      - unexpected NIL passed" );
   NSAssert( p_interpolation_coeffs_, @"p_interpolation_coeffs_ - unexpected NIL passed" );
  
   CGFloat_vt& accumulated_sizes_       = *p_accumulated_sizes_      ;
   CGFloat_vt& segments_x_data_         = *p_segments_x_data_        ;
   CGFloat_vt& interpolation_coeffs_    = *p_interpolation_coeffs_   ;


   interpolation_coeffs_.clear();
   interpolation_coeffs_.reserve( segments_x_data_.size() + 1 );
   
   CGFloat_vt_ci accumulated_sizes_beg_ = accumulated_sizes_.begin ();
   CGFloat_vt_ci accumulated_sizes_end_ = accumulated_sizes_.end   ();
   CGFloat_vt_ci accumulated_sizes_it_  = accumulated_sizes_beg_     ;
   
   CGFloat_vt_ci segments_x_data_beg_      = segments_x_data_.begin();
   CGFloat_vt_ci segments_x_data_end_      = segments_x_data_.end  ();
   CGFloat_vt_ci segments_x_data_it_       = segments_x_data_beg_    ;
   
   
   CGFloat    tmp_numerator_   = 0.f;
   CGFloat    tmp_denominator_ = 1.f;
   NSUInteger segment_index_   = 0  ;
   CGFloat    ratio_           = 0.f;
   CGFloat    coeff_item_      = 0.f;
   while ( ( accumulated_sizes_it_ != accumulated_sizes_end_ ) && 
           ( segments_x_data_it_   != segments_x_data_end_   )   )
   {
      accumulated_sizes_it_ = std::find_if
      ( 
         accumulated_sizes_it_, accumulated_sizes_end_, 
         std::bind2nd( std::greater_equal<CGFloat>(), *segments_x_data_it_ ) 
      );
      
      segment_index_ = std::distance( accumulated_sizes_beg_, accumulated_sizes_it_ );     
      ratio_ = 0.f;
      
      if ( accumulated_sizes_end_ != accumulated_sizes_it_ )
      {
         tmp_numerator_   = (*segments_x_data_it_      ) - (*accumulated_sizes_it_);
         tmp_denominator_ = (*accumulated_sizes_it_ + 1) - (*accumulated_sizes_it_);
         
         ratio_ = tmp_numerator_ / tmp_denominator_;
      }
      
      coeff_item_ = segment_index_ + ratio_;
      interpolation_coeffs_.push_back( coeff_item_ );
      
      ++accumulated_sizes_it_;
   }
}

+(void)interpolatexData:( CGFloat*   )x_points_
                  yData:( CGFloat*   )y_points_
            pointsCount:( NSUInteger )points_count_
          segmentsCount:( NSUInteger )segments_count_
                 result:( GRGraffitiRecognizerState* )result_
{
   NSAssert( x_points_, @"x_points_ - unexpected NIL passed" );
   NSAssert( y_points_, @"y_points_ - unexpected NIL passed" );
   NSAssert( result_  , @"result_   - unexpected NIL passed" );
   
   CGFloat_vt accumulated_sizes_( 0, points_count_ );
   CGFloat* accumulated_sizes_start_ = &accumulated_sizes_.at( 0 );
   
   [ self getSegmentsAccumulatedLengthVector: accumulated_sizes_start_
                                   fromXData: x_points_
                                       yData: y_points_
                                       count: points_count_ ];
   
   
   
   
   
   CGFloat_vt segments_len_data_( 0, segments_count_ );
   CGFloat* segments_len_data_start_ = &segments_len_data_.at( 0 );
   static CGFloat bias_ = 0;
   static CGFloat multiplier_ = 1.f / segments_count_;
   vDSP_vramp( &bias_                 , &multiplier_,
              segments_len_data_start_, 1           ,
              segments_count_                       );
   
   
   
   CGFloat_vt interpolation_coeffs_/*( 0, segments_count_ )*/;
   [ self prepareInterpolationCoeffsForAccumulatedLength: &accumulated_sizes_
                                           segmentsXData: &segments_len_data_
                                                  result: &interpolation_coeffs_ ];
   CGFloat* interpolation_coeffs_start_ = &interpolation_coeffs_.at( 0 );
   
   
   CGFloat_vt& segments_x_data_ = result_->xPoints;
   segments_x_data_.resize( segments_count_ );
   CGFloat* segments_x_data_start_ = &segments_x_data_.at( 0 );
   vDSP_vlint( x_points_,
              interpolation_coeffs_start_, 1,
              segments_x_data_start_     , 1,
              segments_count_               ,
              points_count_                 );   
   
   
   CGFloat_vt& segments_y_data_ = result_->yPoints;
   segments_y_data_.resize( segments_count_ );
   CGFloat* segments_y_data_start_ = &segments_y_data_.at( 0 );
   vDSP_vlint( y_points_,
               interpolation_coeffs_start_, 1,
               segments_y_data_start_     , 1,
               segments_count_               ,
               points_count_                 );
   
}

+(void)getBoundsForXDataXData:( CGFloat*   )x_points_
                        yData:( CGFloat*   )y_points_
                  pointsCount:( NSUInteger )points_count_
                         xMin:( CGFloat*   )p_x_min_
                         xMax:( CGFloat*   )p_x_max_
                         yMin:( CGFloat*   )p_y_min_
                         yMax:( CGFloat*   )p_y_max_
{
   NSAssert( x_points_, @"x_points_ - unexpected NIL passed" );
   NSAssert( y_points_, @"y_points_ - unexpected NIL passed" );
   NSAssert( p_x_min_ , @"p_x_min_  - unexpected NIL passed" );
   NSAssert( p_x_max_ , @"p_x_max_  - unexpected NIL passed" );
   NSAssert( p_y_min_ , @"p_y_min_  - unexpected NIL passed" );
   NSAssert( p_y_max_ , @"p_y_max_  - unexpected NIL passed" );
   
   //TODO : optimize if possible

   vDSP_minv( x_points_, 1  ,  
              p_x_min_      ,
              points_count_ );
   
   vDSP_maxv( x_points_, 1  ,  
              p_x_max_      ,
              points_count_ );
   
   vDSP_minv( y_points_, 1  ,  
              p_y_min_      ,
              points_count_ );
   
   vDSP_maxv( y_points_, 1  ,  
              p_y_max_      ,
              points_count_ );
   
}

+(void)normalizeXData:( CGFloat*   )x_points_
                yData:( CGFloat*   )y_points_
          pointsCount:( NSUInteger )points_count_
        segmentsCount:( NSUInteger )segments_count_
               result:( GRGraffitiRecognizerState* )result_
{
   NSAssert( x_points_, @"x_points_ - unexpected NIL passed" );
   NSAssert( y_points_, @"y_points_ - unexpected NIL passed" );
   NSAssert( result_  , @"result_   - unexpected NIL passed" );
   
   [ self interpolatexData:x_points_
                     yData:y_points_
               pointsCount: points_count_
             segmentsCount: segments_count_
                    result: result_ ];

   
   CGFloat x_min_ = 0.f;
   CGFloat x_max_ = 0.f;
   CGFloat y_min_ = 0.f;
   CGFloat y_max_ = 0.f;
   
   [ self getBoundsForXDataXData: x_points_
                           yData: y_points_
                     pointsCount: points_count_
                            xMin: &x_min_
                            xMax: &x_max_
                            yMin: &y_min_
                            yMax: &y_max_ ];
   
   CGFloat x_len_ = x_max_ - x_min_;
   CGFloat y_len_ = y_max_ - y_min_;
   CGFloat proportion_ = fabs( x_len_ / y_len_ );
   
   

   static const CGFloat should_zero_y_values_trashhold_ = 5.f ;
   static const CGFloat should_zero_x_values_trashhold_ = 1.f / should_zero_y_values_trashhold_;
   CGFloat tmp_multiplier_ = 0.f;
   CGFloat tmp_addend_     = 0.f;
   
   if ( proportion_ < should_zero_x_values_trashhold_ )
   {
      std::fill( result_->xPoints.begin(), result_->xPoints.end(), 0.f );
   }
   else
   {
      tmp_multiplier_ = 1.f / x_len_;
      tmp_addend_     = - tmp_multiplier_ * x_min_;
      CGFloat* p_result_x_beg_ = &result_->xPoints.at( 0 );
      
      vDSP_vsmsa( p_result_x_beg_ , 1, 
                  &tmp_multiplier_, 
                  &tmp_addend_    , 
                  p_result_x_beg_ , 1, 
                  segments_count_    );
   }

   
   if ( proportion_ > should_zero_y_values_trashhold_ )
   {
      std::fill( result_->yPoints.begin(), result_->yPoints.end(), 0.f );
   }
   else
   {
      tmp_multiplier_ = 1.f / y_len_;
      tmp_addend_     = - tmp_multiplier_ * y_min_;
      CGFloat* p_result_y_beg_ = &result_->yPoints.at( 0 );
      
      vDSP_vsmsa( p_result_y_beg_, 1, 
                 &tmp_multiplier_, 
                 &tmp_addend_    , 
                 p_result_y_beg_ , 1, 
                 segments_count_    );      
   }
}

+(CGFloat)getDistanceForX1:( CGFloat*   )x1_
                        Y1:( CGFloat*   )y1_
                        X2:( CGFloat*   )x2_
                        Y2:( CGFloat*   )y2_
                     count:( NSUInteger )count_
{
   CGFloat_vt single_distances_( 0, count_ );
   CGFloat* single_distances_start_ = &single_distances_.at( 0 );
   
   vDSP_vpythg( x1_                    , 1,
                y1_                    , 1,
                x2_                    , 1,
                y2_                    , 1, 
                single_distances_start_, 1,
                count_                    );


   CGFloat result_ = 0;
   vDSP_sve( single_distances_start_, 1,
             &result_,
             count_  );

   return result_;
}


@end
