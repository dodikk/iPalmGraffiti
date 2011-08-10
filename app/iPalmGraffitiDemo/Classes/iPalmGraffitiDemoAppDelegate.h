//
//  iPalmGraffitiDemoAppDelegate.h
//  iPalmGraffitiDemo
//
//  Created by Oleksandr Dodatko on 8/10/11.
//  Copyright 2011 EPAM systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iPalmGraffitiDemoViewController;

@interface iPalmGraffitiDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iPalmGraffitiDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iPalmGraffitiDemoViewController *viewController;

@end

