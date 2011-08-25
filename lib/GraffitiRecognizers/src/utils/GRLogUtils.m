#import "GRLogUtils.h"


@implementation GRLogUtils

+(void)dumpError:( NSError* )error_
     withMessage:( NSString* )str_message_
{
   if ( !error_ )
   {
      return;
   }
   
   NSLog( @"[!!! ERROR !!!] - %@ : %@", str_message_, error_ );
}

@end
