#import "GRMseSample.h"
#import "GRPointsDumper.h"


@implementation GRMseSample

@synthesize sampleData = _sample_data;
@synthesize constraint = _constraint ;
@synthesize answer     = _answer     ;

-(void)dealloc
{
   [ _answer release ];
   
   [ super dealloc ];
}

-(NSString*)description
{
   NSMutableString* result_ = [ NSMutableString stringWithFormat: @"%@\t%d\t", self.answer, self.constraint ];
   NSString* data_string_ = [ GRPointsDumper dumpToStringXPoints: &self.sampleData.xPoints.at(0)
                                                         yPoints: &self.sampleData.yPoints.at(0)
                                                           count: self.sampleData.xPoints.size() ];

   [ result_ appendString: data_string_ ];
   return result_;

}


#pragma mark -
#pragma mark deserialize
-(void)deserializeFromDescriptionString:( NSString* )str_
{
   // TODO : add range checking
   static const NSUInteger metadata_items_count_ = 3;
   
   NSArray* items_ = [ str_ componentsSeparatedByString: @"\t" ];
   
   NSUInteger components_count_ = [ items_ count ];
   NSAssert( components_count_ >= metadata_items_count_, @"Metadata is missing." );
   
   NSString* str_answer_       = [ items_ objectAtIndex: 0 ];
   NSString* str_constraint_   = [ items_ objectAtIndex: 1 ];
   NSString* str_points_count_ = [ items_ objectAtIndex: 2 ];
   
   self.answer     = str_answer_;
   self.constraint = [ str_constraint_ intValue ];
   
   // Parse points
   NSUInteger points_count_ = [ str_points_count_ intValue ];
   
   self.sampleData.xPoints.clear();
   self.sampleData.yPoints.clear();
   
   if ( 0 == points_count_ )
   {
      return;
   }

   
   self.sampleData.xPoints.reserve( points_count_ );
   self.sampleData.yPoints.reserve( points_count_ );
   for ( NSUInteger point_index_ = 0; point_index_ < points_count_; ++point_index_ )
   {
      NSString* str_x_ = [ items_ objectAtIndex: point_index_ + metadata_items_count_                 ];
      NSString* str_y_ = [ items_ objectAtIndex: point_index_ + metadata_items_count_ + points_count_ ];
      
      CGFloat x_ = [ str_x_ floatValue ];
      CGFloat y_ = [ str_y_ floatValue ];
      
      self.sampleData.xPoints.push_back( x_ );
      self.sampleData.yPoints.push_back( y_ );      
   }
}

+(NSArray*)deserializeMultipleFromString:( NSString* )str_
{
   NSArray* str_items_ = [ str_ componentsSeparatedByString: @"\n" ];
   NSMutableArray* result_ = [ NSMutableArray array ];

   for ( NSString* str_item_ in str_items_ )
   {
      GRMseSample* sample_item_ = [ GRMseSample new ];
      [ sample_item_ deserializeFromDescriptionString: str_item_ ];
      
      [ result_ addObject: sample_item_ ];
   }

   return result_;
}

+(NSArray*)deserializeMultipleFromFileNoLoad:( NSString* )file_path_
{
   NSAssert( NO, @"deserializeMultipleFromFileNoLoad -- not implemented" );
   return nil;
}


+(NSArray*)deserializeMultipleFromFile:( NSString* )file_path_
{
   static const NSUInteger max_file_size_ = 4 * 1024 * 1024; // 4K

   NSError* file_error_ = nil;
  
   NSFileManager* fm_ = [ NSFileManager defaultManager ];
   NSDictionary* file_attributes_ = [ fm_ attributesOfItemAtPath: file_path_
                                                           error: &file_error_ ];

   [ GRLogUtils dumpError: file_error_
              withMessage: @"GRMseSample->deserializeMultipleFromFile" ];

   
   if ( [ file_attributes_ fileSize ] >= max_file_size_ )
   {
      return [ self deserializeMultipleFromFileNoLoad: file_path_ ];
   }
   

   NSString* file_string_ = [ NSString stringWithContentsOfFile: file_path_
                                                       encoding: NSUTF8StringEncoding
                                                          error: &file_error_ ];
   
   [ GRLogUtils dumpError: file_error_
              withMessage: @"GRMseSample->deserializeMultipleFromFile" ];
   
   
   return [ self deserializeMultipleFromString: file_string_ ];
}

@end
