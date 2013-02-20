//
//  HelpScreen.h
//  Cyprus Reports
//
//  Created by Menelaos on 20/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpScreen : UIViewController
- (IBAction)doneBtn:(id)sender;
@property (retain, nonatomic) IBOutlet UITextView *helpTextView;
@property (retain, nonatomic) IBOutlet UIToolbar *topToolBar;

@end
