//
//  HelpScreen.m
//  Cyprus Reports
//
//  Created by Menelaos on 20/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import "HelpScreen.h"

@interface HelpScreen ()

@end

@implementation HelpScreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if (screenRect.size.height == 480) {
        NSLog(@"480");
        _topToolBar.frame = CGRectMake(0, 88, 320, 44);
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    [_helpTextView release];
    [_topToolBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTopToolBar:nil];
    [super viewDidUnload];
}
@end
