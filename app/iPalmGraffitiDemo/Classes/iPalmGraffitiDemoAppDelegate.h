#import <UIKit/UIKit.h>

@class iPalmGraffitiDemoViewController;

@interface iPalmGraffitiDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iPalmGraffitiDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iPalmGraffitiDemoViewController *viewController;

@end

