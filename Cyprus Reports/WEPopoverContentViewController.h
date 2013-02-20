//
//  WEPopoverContentViewController.h
//  WEPopover
//
//  Created by Werner Altewischer on 06/11/10.
//  Copyright 2010 Werner IT Consultancy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"

@protocol WEPopoverItemDelegate<NSObject>
-(WEPopoverController *) WEPopoverIndexSelected:(NSDictionary*) info;
@end

@interface WEPopoverContentViewController : UITableViewController {
    
    id<WEPopoverItemDelegate> delegate;
}

@property(nonatomic,retain) NSMutableArray *contents;

@property(retain,nonatomic) id<WEPopoverItemDelegate> delegate; 

-(void) setPopOverSize:(CGSize) size;
@end
  



