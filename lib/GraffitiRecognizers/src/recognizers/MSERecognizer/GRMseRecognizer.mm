#import "GRMseRecognizer.h"
#import "GRMseSample.h"
#import "GRGraffitiRecognizerState.h"
#import "GRMseNormalizer.h"
#import "GRTypes.h"
#import "GRConstraintBuilder.h"

#pragma mark -
#pragma mark Private declarations
@interface GRMseRecognizer ()

@property ( nonatomic, retain ) NSArray* samples;
@property ( nonatomic, retain ) NSArray* normalizedSamples;

@end


#pragma mark -
#pragma mark -@implementation
@implementation GRMseRecognizer

@synthesize segmentsCount     = _segments_count    ;
@synthesize samples           = _samples           ;
@synthesize normalizedSamples = _normalized_samples;

-(void)dealloc
{
   [ self->_samples release ];
   [ self->_normalized_samples release ];

   [ super dealloc ];
}

#pragma mark -
#pragma mark GRImageRecognizer
-(NSArray*)recognizeLetterByXPoints:( CGFloat* )x_points_
                            yPoints:( CGFloat* )y_points_
                              count:( NSUInteger )points_count_
{  
   GRGraffitiRecognizerState normalized_input_;
   [ GRMseNormalizer normalizeXData: x_points_
                              yData: y_points_
                        pointsCount: points_count_
                      segmentsCount: self.segmentsCount 
                             result: &normalized_input_ ];
   
   GRStrokeConstraints input_constraint_ = [ GRConstraintBuilder getConstraintForxBeg: normalized_input_.xPoints.front() 
                                                                                 xFin: normalized_input_.xPoints.back () 
                                                                                 yBeg: normalized_input_.yPoints.front() 
                                                                                 yFin: normalized_input_.xPoints.back () ];

   CGFloat_vt distances_       ;
   CGFloat    tmp_distance_ = 0;
   distances_.reserve( [ self.normalizedSamples count ] );
   for ( GRMseSample* sample_ in self.normalizedSamples )
   {
      if ( ![ GRConstraintBuilder matchConstraint: input_constraint_
                            andExpectedConstraint: sample_.constraint ] )
      {
         continue;
      }

      tmp_distance_ = [ GRMseNormalizer getDistanceForX1: &normalized_input_.xPoints.at( 0 ) 
                                                      Y1: &normalized_input_.yPoints.at( 0 )  
                                                      X2: &sample_->sampleData.xPoints.at( 0 )
                                                      Y2: &sample_->sampleData.yPoints.at( 0 )
                                                   count: self.segmentsCount ];

      distances_.push_back( tmp_distance_ );
   }

   CGFloat_vt_i it_min_distance_ = std::min_element( distances_.begin(), distances_.end() );
   NSUInteger   result_index_    = std::distance   ( distances_.begin(), it_min_distance_ );
   
   GRMseSample* result_sample_ = [ self.normalizedSamples objectAtIndex: result_index_ ];
   NSArray* result_ = [ NSArray arrayWithObject: result_sample_.answer ];   
   
   return result_;
}


#pragma mark -
#pragma mark Factory methods
+(id<GRImageRecognizer>)englishAlphabet
{
   static NSArray* english_samples_ = nil;
   
   if ( !english_samples_ )
   {
      english_samples_ = [ GRMseSample deserializeMultipleFromFile: [ GRBundleManager pathForMseSampleNamed: @"english-letters" ] ];
   }
   
   GRMseRecognizer* result_ = [ GRMseRecognizer new ];
   result_.samples           = english_samples_      ;
   result_.segmentsCount    = 10                     ;
   
   return [ result_ autorelease ];
}

+(id<GRImageRecognizer>)arabicNumbersAlphabet
{
   static NSArray* english_samples_ = nil;
   
   if ( !english_samples_ )
   {
      english_samples_ = [ GRMseSample deserializeMultipleFromFile: @"arabic-numbers" ];
   }
   
   GRMseRecognizer* result_ = [ GRMseRecognizer new ];
   result_.samples          = english_samples_       ;
   result_.segmentsCount    = 10                     ;
   
   return [ result_ autorelease ];
}

+(id<GRImageRecognizer>)recognizerWithAlphabetId:( GRGraffitiAlphabets )alphabet_id_
{
   switch ( alphabet_id_ ) 
   {
      case GREnglishAlphabet:
         return [ self englishAlphabet ];
         
      case GRArabicNumbersAlphabet:
         return [ self arabicNumbersAlphabet ];
         
      default:
         NSAssert( NO, @"Unsupported alphabet" );
         break;
   }
   
   return nil;
}

#pragma mark -
#pragma mark Properties
-(void)setSegmentsCount:( NSUInteger )value_
{
   self->_segments_count = value_;
   
   NSMutableArray* normalized_samples_ = [ NSMutableArray arrayWithCapacity: [ self.samples count ] ] ;
   for ( GRMseSample* sample_ in self.samples )
   {
      GRMseSample* norm_sample_ = [ [ GRMseSample new ] autorelease ];
      norm_sample_.answer = [ [ sample_.answer copy ] autorelease ];
      norm_sample_.constraint = sample_.constraint;
      GRGraffitiRecognizerState normalized_data_;
      
      
      [ GRMseNormalizer normalizeXData: &sample_->sampleData.xPoints.at( 0 )
                                 yData: &sample_->sampleData.yPoints.at( 0 )
                           pointsCount: sample_->sampleData.xPoints.size()
                         segmentsCount: self->_segments_count
                                result: &normalized_data_ ];
      
      norm_sample_->sampleData.xPoints = normalized_data_.xPoints;
      norm_sample_->sampleData.yPoints = normalized_data_.yPoints;
      
      [ normalized_samples_ addObject: norm_sample_ ];
   }
   
   self.normalizedSamples = normalized_samples_;
}


@end
