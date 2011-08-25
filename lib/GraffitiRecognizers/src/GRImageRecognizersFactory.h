#import <Foundation/Foundation.h>
#include <GraffitiRecognizers/GRGraffitiAlphabets.h>
#include <GraffitiRecognizers/GRRecognitionMethods.h>

@protocol GRImageRecognizer;


@interface GRImageRecognizersFactory : NSObject 

+(id<GRImageRecognizer>)recognizerWithAlphabetId:( GRGraffitiAlphabets )alphabet_id_
                                        methodId:( GRRecognitionMethods )method_id_;

+(id<GRImageRecognizer>)englishAlphabet;
+(id<GRImageRecognizer>)arabicNumbersAlphabet;

@end
