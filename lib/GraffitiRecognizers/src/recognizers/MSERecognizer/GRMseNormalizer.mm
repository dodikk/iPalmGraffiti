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

+(void)normalizeXData:( CGFloat*   )x_points_
                yData:( CGFloat*   )y_points_
          pointsCount:( NSUInteger )points_count_
        segmentsCount:( NSUInteger )segments_count_
               result:( GRGraffitiRecognizerState* )result_
{
   // TODO : check the range

   CGFloat_vt accumulated_sizes_( 0, points_count_ );
   CGFloat* accumulated_sizes_start_ = &accumulated_sizes_.at( 0 );
   
   [ self getSegmentsAccumulatedLengthVector: accumulated_sizes_start_
                                   fromXData: x_points_
                                       yData: y_points_
                                       count: points_count_ ];
   
   
   
   
   
   CGFloat_vt segments_x_data_( 0, segments_count_ );
   CGFloat* segments_x_data_start_ = &segments_x_data_.at( 0 );
   static CGFloat bias_ = 0;
   static CGFloat multiplier_ = 1.f / segments_count_;
   vDSP_vramp( &bias_                , &multiplier_,
               segments_x_data_start_, 1          ,
               segments_count_                    );
   
   
//   vDSP_vgenp
   
//   vDSP_vlint (
//               float *__vDSP_A,
//               float *__vDSP_B,
//               vDSP_Stride __vDSP_J,
//               float *__vDSP_C,
//               vDSP_Stride __vDSP_K,
//               vDSP_Length __vDSP_N,
//               vDSP_Length __vDSP_M
//               );   
   
   NSAssert( NO, @"Not implemented" );
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
