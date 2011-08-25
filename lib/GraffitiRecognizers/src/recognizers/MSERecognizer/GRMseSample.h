#import "GRGraffitiRecognizerState.h"
#import "GRStrokeConstraints.h"
#import <Foundation/Foundation.h>


@interface GRMseSample : NSObject 

@property ( nonatomic, assign ) GRGraffitiRecognizerState sampleData;
@property ( nonatomic, assign ) GRStrokeConstraints       constraint;
@property ( nonatomic, copy   ) NSString*                 answer    ;

-(void)deserializeFromDescriptionString:( NSString* )str_;
+(NSArray*)deserializeMultipleFromString:( NSString* )str_;
+(NSArray*)deserializeMultipleFromFile:( NSString* )file_path_;

@end
