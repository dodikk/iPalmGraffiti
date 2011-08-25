#import "GRImageRecognizersFactory.h"
#import "GRImageRecognizer.h"
#import "GRMseRecognizer.h"

@implementation GRImageRecognizersFactory

+(id<GRImageRecognizer>)englishAlphabet
{
   return nil;
}

+(id<GRImageRecognizer>)arabicNumbersAlphabet
{
   return nil;
}

+(id<GRImageRecognizer>)recognizerWithAlphabetId:( GRGraffitiAlphabets )alphabet_id_
                                        methodId:( GRRecognitionMethods )method_id_
{
   switch ( method_id_ ) 
   {
      case GRMseRecognition:
      {
         return [ GRMseRecognizer recognizerWithAlphabetId: alphabet_id_ ];
         break;
      }
      default:
      {
         NSAssert( NO, @"Unsupported recognition method" );
         break;
      }
   }

   return nil;
}

@end
