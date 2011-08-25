#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <GraffitiRecognizers/GRGraffitiAlphabets.h>
#include <GraffitiRecognizers/GRRecognitionMethods.h>

@interface GRGraffitiGestureRecognizer : UIGestureRecognizer

-(id)initWithLanguage:( GRGraffitiAlphabets )language_id_
    recognitionMethod:( GRRecognitionMethods )method_id_
               target:( id )target_
               action:( SEL )action_;



//@@ ItemType : NSString
@property ( nonatomic, retain, readonly ) NSArray* detectedLetters;
@property ( nonatomic, assign ) GRGraffitiAlphabets languageId;
@property ( nonatomic, assign ) GRRecognitionMethods methodId;

@property ( nonatomic, assign ) BOOL shouldDumpPointsToFile;

@end
