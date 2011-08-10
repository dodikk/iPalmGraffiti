#import "GRPointsDumper.h"


@implementation GRPointsDumper

+(void)dumpToFileXPoints:( CGFloat* )x_points_
                 yPoints:( CGFloat* )y_points_
                   count:( NSUInteger )points_count_
{
   static NSUInteger invocations_count_ = 0;
   ++invocations_count_;
   
   NSArray* documents_dirs_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   
   if ( 0 == [ documents_dirs_ count ] )
   {
      NSLog( @"GRPointsDumper->unable to find root dir" );
      return;
   }

   NSMutableString* result_string_ = [ NSMutableString string ];
   [ result_string_ appendFormat: @"%d", points_count_ ];
   
   // dump x points
   for ( NSUInteger point_index_ = 0; point_index_ < points_count_; ++point_index_ )
   {
      [ result_string_ appendFormat: @"\t%f", x_points_ ];
   }

   // dump y points
   for ( NSUInteger point_index_ = 0; point_index_ < points_count_; ++point_index_ )
   {
      [ result_string_ appendFormat: @"\t%f", y_points_ ];
   }
   

   NSString* root_path_ = [ documents_dirs_ objectAtIndex: 0 ];
   
   NSString* file_name_ = [ NSString stringWithFormat: @"RecognitionSession-%d.dat", invocations_count_ ];
   NSData* result_data_ = [ result_string_ dataUsingEncoding: NSUTF8StringEncoding ];

   NSLog( @"GRPointsDumper -- dumpint to the root path : %@", root_path_ );
   NSLog( @"file name      -- %@"                           , file_name_ );
   NSLog( @"Result         --"  );
   NSLog( @"%@", result_string_ );
   
   BOOL file_created_ = [ [ NSFileManager defaultManager ] createFileAtPath: file_name_
                                                                   contents: result_data_
                                                                 attributes: nil ];
   
   if ( !file_created_ )
   {
      NSLog( @"An error has occured while dumping to the file" );
   }
}


@end
