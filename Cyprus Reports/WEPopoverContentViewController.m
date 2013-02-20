//
//  WEPopoverContentViewController.m
//  WEPopover
//
//  Created by Werner Altewischer on 06/11/10.
//  Copyright 2010 Werner IT Consultancy. All rights reserved.
//

#import "WEPopoverContentViewController.h"


@implementation WEPopoverContentViewController
@synthesize contents,delegate;


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		self.contentSizeForViewInPopover = CGSizeMake(100, 4 * 25 - 1);
    }
    //(100, 1 * 44 - 1);

    return self;
}

-(void) setPopOverSize:(CGSize) size
{
    self.contentSizeForViewInPopover = CGSizeMake((size.width/100)*85, self.contentSizeForViewInPopover.height);
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.tableView.rowHeight = 35.0;
	//self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:0];
   
   
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return contents.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    //	rgb(249, 238, 218)
	myBackView.backgroundColor = [UIColor colorWithRed:(15/255.0) green:(46/255.0) blue:(72/255.0) alpha:255];
	//cell.selectedBackgroundView = myBackView;
    cell.backgroundView=myBackView;
	[myBackView release];
    
    // Configure the cell...
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
    //cell.textLabel.font=[UIFont fontWithName:@"Marker Felt" size:15];
    
    cell.textLabel.backgroundColor = [UIColor colorWithRed:135 green:206 blue:250 alpha:0];
	cell.textLabel.text = [NSString stringWithFormat:@"%@", [contents objectAtIndex:indexPath.row]];
	cell.textLabel.textColor =[UIColor whiteColor];//  [UIColor colorWithRed:(135/255.0) green:(205/255.0) blue:(250/255.0) alpha:255]; 
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.    
   
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"Index"];
    [dict setValue:[contents objectAtIndex:indexPath.row] forKey:@"Value"];
                          
      WEPopoverController *pop= [self.delegate WEPopoverIndexSelected:dict];
    [pop dismissPopoverAnimated:YES];
    //[pop release];
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    delegate = nil;
    [contents release];
        [super dealloc];
}


@end

