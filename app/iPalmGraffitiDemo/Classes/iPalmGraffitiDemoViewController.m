#import "iPalmGraffitiDemoViewController.h"

@implementation iPalmGraffitiDemoViewController


#pragma mark -
#pragma mark KeyboardHooks
-(void)viewDidAppear:( BOOL )animated_
{
   [ [ NSNotificationCenter defaultCenter ] addObserver: self 
                                               selector: @selector( modifyKeyboard: )
                                                   name: UIKeyboardWillShowNotification
                                                 object: nil ];

   [ super viewDidAppear: animated_ ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self 
                                                      name: UIKeyboardWillShowNotification 
                                                    object: nil];
}


#define GraffitiKeyboardView UIView
-(void)modifyKeyboard:( NSNotification* )notification_ 
{  
   //!! TODO : check this hook properly

   for (UIWindow *keyboardWindow in [ [ UIApplication sharedApplication ] windows ] )
   {
      for ( UIView *keyboard in [ keyboardWindow subviews ] )
      {
         if ( [ [ keyboard description ] hasPrefix: @"<UIKeyboard" ] == YES )
         {
            CGRect keyboard_frame_ = CGRectMake(0, 0, keyboard.frame.size.width, keyboard.frame.size.height);
            
            GraffitiKeyboardView *customKeyboard = [ [ GraffitiKeyboardView alloc ] initWithFrame: keyboard_frame_ ];
            [ keyboard addSubview: customKeyboard ];
            [ customKeyboard release ];
         }
      }
   }
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
