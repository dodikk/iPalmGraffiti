#import "GRImageRecognizer.h"
#import <Foundation/Foundation.h>

//http://home.comcast.net/~urbanjost/canvas/graffiti/graffiti.html

@interface GRMseRecognizer : NSObject< GRImageRecognizer >

@property ( nonatomic, assign ) NSUInteger segmentsCount;
@property ( nonatomic, retain, readonly ) NSArray* samples;

@end
