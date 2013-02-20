//
//  CategoryReportTable.m
//  Cyprus Reports
//
//  Created by Menelaos on 19/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import "CategoryReportTable.h"

@interface CategoryReportTable ()

@end

@implementation CategoryReportTable

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
    
    _categoryArray = [[NSMutableArray alloc]initWithObjects:@"Accident", @"Bad weather", @"PotHoles", @"Police", @"Traffic Lights", @"Abandoned cars", @"Heavy Traffic", @"Other", nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_categoryArray release];
    [_categoryTbl release];
    [super dealloc];
}
#pragma mark Tableview delegate method

- (NSInteger)tableView:(UITableView *)tableView

 numberOfRowsInSection:(NSInteger)section
{
    return [_categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [_categoryArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19.0];
    
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ArrowBtn.png"]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailsScreen *screen = [[DetailsScreen alloc]initWithNibName:@"DetailsScreen" bundle:nil];
    screen.catId = indexPath.row + 1;
    screen.title = @"Report Lists";
    screen.fbString = _fbString;
    NSLog(@"fb String is %@ Second %@", screen.fbString, _fbString);
    [self.navigationController pushViewController:screen animated:YES];
    [screen release];
    
}

@end
