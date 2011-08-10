#import <Foundation/Foundation.h>
#include <GraffitiRecognizers/GRGraffitiAlphabets.h>

@class GRImageRecognizer;


@interface GRImageRecognizersFactory : NSObject 

+(GRImageRecognizer*)alphabetById:( GRGraffitiAlphabets )alphabet_id_;

+(GRImageRecognizer*)englishAlphabet;
+(GRImageRecognizer*)arabicNumbersAlphabet;

@end
