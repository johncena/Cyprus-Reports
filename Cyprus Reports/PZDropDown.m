//
//  PZDropDown.m
//  SpiritPhaseOne
//
//  Created by Menelaos on 9/6/11.
//  Copyright 2011 Menelaos. All rights reserved.
//

#import "PZDropDown.h"


@implementation PZDropDown
@synthesize contentViewController,popoverController,contents;

- (id)initWithFrame:(CGRect)frame {
    if ((self=[super initWithFrame:frame])) {
        self.hidden = YES;
    }
    
    
    return self;
}

-(void) dealloc{
    [contents release];
    [popoverController release];
    [contentViewController release];
    [super dealloc];
}

-(void) setContents:(NSMutableArray*) content
{
    [self setTitle:[NSString stringWithFormat:@"%@",[content objectAtIndex:0]] forState:UIControlStateNormal];
    contents = [content mutableCopy];
}

- (id) initWithCoder:(NSCoder *)decoder
{
    if (!(self = [super initWithCoder:decoder]))
        return nil;
    
    NSLog(@"Init with coder called.");
    UIImage *backgroundImage = [UIImage imageNamed:@"arrow_down.png"] ;

 //   self.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;

   // [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 35.0)];

    [self addTarget:self action:@selector(dropDownClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    arrowImageView.frame = CGRectMake(self.frame.size.width-28, (self.frame.size.height-10)/2, 10, 10);
    [self addSubview:arrowImageView];
    [arrowImageView release];
    return self;
}

-(IBAction) dropDownClicked:(UIButton*) sender
{
    NSLog(@"Drop Down Clicked!");
    
    //if (self.popoverController) {
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    //[button setTitle:@"Show Popover" forState:UIControlStateNormal];
	//} else {
    contentViewController = [[WEPopoverContentViewController alloc] initWithStyle:UITableViewStylePlain];
    contentViewController.delegate = self;
    [contentViewController setPopOverSize:sender.frame.size];
    NSLog(@"contents r %@",contents);
    contentViewController.contents = contents;
    
    self.popoverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
    [self.popoverController presentPopoverFromRect:sender.frame 
                                            inView:self.superview 
                          permittedArrowDirections:UIPopoverArrowDirectionUp
                                          animated:YES];
    [contentViewController release];
    //[button setTitle:@"Hide Popover" forState:UIControlStateNormal];
    //contentViewController.popButton=button;
    
    
	//}

}

-(WEPopoverController *) WEPopoverIndexSelected:(NSDictionary*) info
{
    
    NSLog(@"Index selected: %@",[info objectForKey:@"Index"]);
    NSLog(@"Value selected: %@",[info objectForKey:@"Value"]);
        
    [self setTitle:[info objectForKey:@"Value"] forState:UIControlStateNormal];
    return self.popoverController;
    
}

@end
