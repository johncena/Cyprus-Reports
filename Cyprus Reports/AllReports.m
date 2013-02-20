//
//  AllReports.m
//  Cyprus Reports
//
//  Created by necixy on 02/02/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "AllReports.h"

@interface AllReports ()

@end

@implementation AllReports

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
    _getDetailArray = [[NSMutableArray alloc]init];
    _categoryArray = [[NSMutableArray alloc] initWithObjects:@"Accident", @"Bad weather", @"PotHoles", @"Police", @"Traffic Lights", @"Abandoned cars", @"Heavy Traffic", @"Other", nil];
    
    [self getData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_responseData release];
    [_getDetailArray release];
    [_allReportList release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAllReportList:nil];
    [super viewDidUnload];
}
-(void)getData{
//    int userId = [[perf stringForKey:@"userId"] intValue];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText= @"Loading..";
    
//    NSLog(@"userId %d",userId);
    if (_responseData !=nil) {
        [_responseData release];
    }
    _responseData = [[NSMutableData alloc] init];
    
    NSString *post =[NSString stringWithFormat:@"catId=%d",0];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //set up the request to the website
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSString *urlString=[NSString stringWithFormat:@"http://ipissarides.com/necixy/reportOutput.php"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

#pragma mark Tableview delegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.getDetailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:CellIdentifier] autorelease];
        
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,8,200,18)];
//        titleLabel.tag=1;
//        titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:19.0];
//        titleLabel.backgroundColor= [UIColor clearColor];
//        titleLabel.textColor= [UIColor whiteColor];
//        [cell.contentView addSubview:titleLabel];
//        [titleLabel release];
        
        UILabel *categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,50,250,15)];
        categoryLabel.tag=2;
        categoryLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
        categoryLabel.backgroundColor= [UIColor clearColor];
        categoryLabel.textColor= [UIColor whiteColor];
        [cell.contentView addSubview:categoryLabel];
        [categoryLabel release];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,65,250,15)];
        timeLabel.tag=3;
        timeLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
        timeLabel.backgroundColor= [UIColor clearColor];
        timeLabel.textColor= [UIColor blackColor];
        [cell.contentView addSubview:timeLabel];
        [timeLabel release];
        
        UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,20,250,18)];
        descriptionLabel.tag=4;
        descriptionLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:19.0];
        descriptionLabel.backgroundColor= [UIColor clearColor];
        descriptionLabel.textColor= [UIColor whiteColor];
        [cell.contentView addSubview:descriptionLabel];
        [descriptionLabel release];
        
    }
    
    
    NSMutableDictionary *dict = [_getDetailArray objectAtIndex:indexPath.row];
    
//    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1];
//    titleLabel.textColor= [UIColor whiteColor];
//    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19.0];
//    titleLabel.text= [dict valueForKey:@"title"];
    
    int type = [[dict valueForKey:@"category"] intValue]-1;
    NSString *str  = [_categoryArray objectAtIndex:type];
    UILabel *categoryLabel = (UILabel *)[cell.contentView viewWithTag:2];
    categoryLabel.textColor= [UIColor whiteColor];
    categoryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:9.0];
    categoryLabel.text= [@"Category: " stringByAppendingFormat:@"%@", str];
    
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:3];
    timeLabel.textColor= [UIColor whiteColor];
    timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:9.0];
    timeLabel.text= [@"Date: " stringByAppendingFormat:@"%@", [dict valueForKey:@"timestamp"]];
    
    UILabel *descriptionLabel = (UILabel *)[cell.contentView viewWithTag:4];
    descriptionLabel.textColor= [UIColor whiteColor];
    descriptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19.0];
    descriptionLabel.text= [dict valueForKey:@"description"];
    
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ArrowBtn.png"]];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectedDetailView *screen = [[SelectedDetailView alloc]initWithNibName:@"SelectedDetailView" bundle:nil];
    screen.title = @"Report Details";
    screen.fbString = _fbString;
    NSLog(@"fb String is %@ Second %@", screen.fbString, _fbString);
    NSMutableDictionary *dict = [_getDetailArray objectAtIndex:indexPath.row];

    int type = [[dict valueForKey:@"category"] intValue]-1;
    NSString *str  = [_categoryArray objectAtIndex:type];
    
    screen.descriptionStr = [dict valueForKey:@"description"];
    screen.titleStr = str;
    screen.latitudeStr = [dict valueForKey:@"latitude"];
    screen.longitudeStr = [dict valueForKey:@"longitude"];
    screen.userIdStr = [dict valueForKey:@"id"];
    screen.fbIdString = [dict valueForKey:@"login_id"];
    screen.fbNameString = [dict valueForKey:@"fbusername"];
    [self.navigationController pushViewController:screen animated:YES];
    [screen release];
    
}
#pragma mark Connection delegate Methods

-(void)connection: (NSURLConnection*) connection didReceiveData: (NSData*)data
{
	[_responseData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please check you are connected to the internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    NSLog(@"Error is %@",error);
    //[WToast showWithText:@"Connection Failed,"];
    
    //    if ([[connection tag]isEqualToString:@"getData" ]) {
    //        NSLog(@"error--- %@",error);
    //        //[connection release];
    //    }
    
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *result=[[[NSString alloc]initWithData:_responseData encoding:NSUTF8StringEncoding]autorelease];
    NSLog(@"result si %@",result);
    
    if([result isEqualToString:@""])
    {
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [WToast showWithText:@"Unknown Error Ocurred"];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error1 = nil;
        NSDictionary *details = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error1];
        NSLog(@"details %@",details);
        if (details)
        {
            _getDetailArray= [[details objectForKey:@"userDetails"] retain];
        }
        
    }
    if (_getDetailArray.count == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Reports Found" message:@"No reports for now." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [self.allReportList reloadData];

}

@end
