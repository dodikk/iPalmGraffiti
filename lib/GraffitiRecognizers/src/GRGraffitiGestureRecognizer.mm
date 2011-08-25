#import "GRGraffitiGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#include "GRGraffitiRecognizerState.h"
#import  "GRImageRecognizersFactory.h"
#import  "GRImageRecognizer.h"
#import  "GRPointsDumper.h"

@interface GRGraffitiGestureRecognizer ()

@property ( nonatomic, retain ) NSMutableArray*           mDetectedLetters;
@property ( nonatomic, assign ) GRGraffitiRecognizerState graffitiState   ;

@end


@implementation GRGraffitiGestureRecognizer

@dynamic detectedLetters;
@synthesize languageId             = _language_id               ;
@synthesize methodId               = _method_id                 ;
@synthesize shouldDumpPointsToFile = _should_dump_points_to_file;
@synthesize mDetectedLetters       = _m_detected_letters        ;
@synthesize graffitiState          = _graffiti_state            ;

-(void)dealloc
{
   [ _m_detected_letters release ];

   [ super dealloc ];
}


#pragma mark -
#pragma mark Initialization
-(id)initWithLanguage:( GRGraffitiAlphabets )language_id_
    recognitionMethod:( GRRecognitionMethods )method_id_
               target:( id )target_
               action:( SEL )action_
{
   self = [ super initWithTarget: target_
                          action: action_ ];
   
   if ( nil == self )
   {
      return nil;
   }
   
   self.languageId = language_id_;
   self.methodId   = method_id_  ;
   
   return self;
}


#pragma mark -
#pragma mark Properties
-(NSArray*)detectedLetters
{
   return self.mDetectedLetters;
}

#pragma mark -
#pragma mark GesturesPrevention
-(void)reset
{
   self.mDetectedLetters = [ NSMutableArray array ];

   self.graffitiState.xPoints.clear();
   self.graffitiState.yPoints.clear();
}

-(BOOL)canPreventGestureRecognizer:( UIGestureRecognizer* )prevented_gesture_recognizer_
{
   return NO;
}

-(BOOL)canBePreventedByGestureRecognizer:( UIGestureRecognizer* )prevented_gesture_recognizer_
{
   if ( [ prevented_gesture_recognizer_ numberOfTouches ] > 1 ) 
   {
      return YES;
   }

   return NO;
}

-(void)assertSingleTouch:( NSSet* )touches_ 
               withEvent:( UIEvent* )event_
{
   if ( [ touches_ count ] > 1 )
   {
      self.state = UIGestureRecognizerStateFailed;
   }   
}


#pragma mark - 
#pragma mark TouchEvents
-(void)touchesBegan:( NSSet* )touches_ 
          withEvent:( UIEvent* )event_
{
   [ self assertSingleTouch: touches_
                  withEvent: event_ ];
}

-(void)touchesMoved:( NSSet* )touches_
          withEvent:( UIEvent* )event_
{
   NSAssert( [ touches_ count ] == 1, @"GRGraffitiGestureRecognizer->Unexpected count of touches" );

   CGPoint touch_position_ = [ self locationOfTouch: 0
                                             inView: self.view ];
   
   self.graffitiState.xPoints.push_back( touch_position_.x );
   self.graffitiState.yPoints.push_back( touch_position_.y );
}

-(void)touchesEnded:( NSSet* )touches_
          withEvent:( UIEvent* )event_
{
   NSLog( @"[BEGIN] : GRGraffitiGestureRecognizer->touchesEnded:withEvent:" );

   NSAssert( self.graffitiState.xPoints.size() == self.graffitiState.yPoints.size(),
             @"Point arrays dimensions do not match" );


   size_t points_count_ = self.graffitiState.xPoints.size();
   
   if ( 0 == points_count_ )
   {
      self.state = UIGestureRecognizerStateFailed;

      NSLog( @">>> GRGraffitiGestureRecognizer->touchesEnded:withEvent: -- no points collected so far" );      
      NSLog( @"[END] : GRGraffitiGestureRecognizer->touchesEnded:withEvent:" );
      return;
   }
   
   CGFloat* raw_x_data_ = &self.graffitiState.xPoints.at(0);
   CGFloat* raw_y_data_ = &self.graffitiState.yPoints.at(0);

   if ( self.shouldDumpPointsToFile )
   {
      [ GRPointsDumper dumpToFileXPoints: raw_x_data_
                                 yPoints: raw_y_data_
                                   count: points_count_ ];
   }

   id<GRImageRecognizer> image_recognizer_ = [ GRImageRecognizersFactory recognizerWithAlphabetId: self.languageId 
                                                                                         methodId: self.methodId  ];
   NSArray* recognized_letters_ = [ image_recognizer_ recognizeLetterByXPoints: raw_x_data_
                                                                       yPoints: raw_y_data_
                                                                         count: points_count_ ];
   

   if ( [ recognized_letters_ count ] != 0 )
   {
      self.state = UIGestureRecognizerStateRecognized;
   }
   else
   {
      self.state = UIGestureRecognizerStateFailed;
   }
   
   NSLog( @"[END] : GRGraffitiGestureRecognizer->touchesEnded:withEvent:" );
}

-(void)touchesCancelled:( NSSet* )touches_
              withEvent:( UIEvent* )event_
{
   //IDLE
}
                           

@end
