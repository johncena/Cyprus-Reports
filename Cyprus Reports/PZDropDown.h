//
//  PZDropDown.h
//  SpiritPhaseOne
//
//  Created by Menelaos on 9/6/11.
//  Copyright 2011 Menelaos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WEPopoverContentViewController.h"
@class WEPopoverController;

@interface PZDropDown : UIButton 
<WEPopoverItemDelegate>

-(IBAction) dropDownClicked:(UIButton*) sender;
-(void) setContents:(NSMutableArray*) content;
@property (nonatomic, retain) NSMutableArray *contents;
@property (nonatomic, retain) WEPopoverController *popoverController;
@property (nonatomic, retain)  WEPopoverContentViewController *contentViewController;

@end
