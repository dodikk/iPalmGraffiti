#import "GRMseRecognizer.h"
#import "GRMseSample.h"
#import "GRGraffitiRecognizerState.h"
#import "GRMseNormalizer.h"

#pragma mark -
#pragma mark Private declarations
@interface GRMseRecognizer ()

@property ( nonatomic, retain ) NSArray* samples;

@end


#pragma mark -
#pragma mark -@implementation
@implementation GRMseRecognizer

@synthesize segmentsCount = _segments_count;
@synthesize samples       = _samples       ;

-(void)dealloc
{
   [ self->_samples release ];
   [ super dealloc ];
}

#pragma mark -
#pragma mark GRImageRecognizer
-(NSArray*)recognizeLetterByXPoints:( CGFloat* )x_points_
                            yPoints:( CGFloat* )y_points_
                              count:( NSUInteger )points_count_
{
   NSArray* result_ = [ NSArray arrayWithObject: @"A" ];
   
   GRGraffitiRecognizerState normalized_input_;
   [ GRMseNormalizer normalizeXData: x_points_
                              yData: y_points_
                        pointsCount: points_count_
                      segmentsCount: self.segmentsCount 
                             result: &normalized_input_ ];

   
   
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
   result_.samples          = english_samples_       ;
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

@end
