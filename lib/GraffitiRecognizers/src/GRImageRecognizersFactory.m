#import "GRImageRecognizersFactory.h"
#import "GRImageRecognizer.h"

@implementation GRImageRecognizersFactory

+(GRImageRecognizer*)englishAlphabet
{
   return nil;
}

+(GRImageRecognizer*)arabicNumbersAlphabet
{
   return nil;
}

+(GRImageRecognizer*)alphabetById:( GRGraffitiAlphabets )alphabet_id_
{
   switch ( alphabet_id_ ) 
   {
      case GREnglishAlphabet:
         return [ self englishAlphabet ];
         
      case GRArabicNumbersAlphabet:
         return [ self arabicNumbersAlphabet ];
         
      default:
         break;
   }

   return nil;
}

@end
