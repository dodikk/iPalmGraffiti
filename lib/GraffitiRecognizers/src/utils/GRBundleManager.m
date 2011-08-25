#import "GRBundleManager.h"


@implementation GRBundleManager

+(NSBundle*)mseSamplesBundle
{
   NSBundle* result_ = [ NSBundle bundleForClass: [ self class ] ];
   return result_;
}

+(NSString*)pathForMseSampleNamed:( NSString* )sample_name_
{
   return [ [ self mseSamplesBundle ] pathForResource: sample_name_
                                               ofType: @"csv"       ];
}

@end
