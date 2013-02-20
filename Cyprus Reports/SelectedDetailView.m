//
//  SelectedDetailView.m
//  Cyprus Reports
//
//  Created by Menelaos on 17/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import "SelectedDetailView.h"

@interface SelectedDetailView ()

@end

@implementation SelectedDetailView
@synthesize latitudeStr, longitudeStr, annot;
@synthesize descriptionStr, titleStr;

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
        _detailView.frame = CGRectMake(0, 0, 320, 409);
    }
//    _profilePic = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(270, 450, 70, 70)];
//    
//    [self.view addSubview:_profilePic];
//    _profilePic.profileID = _fbIdString;
    _userNameLbl.text = _fbNameString;
    _objManager = [[HJObjManager alloc] init];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/flickr/"] ;
	HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
	_objManager.fileCache = fileCache;
    annot = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D theCoordinate1;
    theCoordinate1.latitude = [latitudeStr doubleValue];
    theCoordinate1.longitude = [longitudeStr doubleValue];
    annot.coordinate=theCoordinate1;
    [self.mapView addAnnotation:annot];
    [self zoomToFitMapAnnotations:_mapView];
    self.titleLbl.text = self.titleStr;
    
    self.descriptionTxtView.text = self.descriptionStr;
    _imageNameArray = [[NSMutableArray alloc]init];
//    [self.view bringSubviewToFront:_profilePic];
    [self getDetails];
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"ImageMapView"];
    if (!aView)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ImageMapView"];
        aView.canShowCallout = YES;
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        UIImage *flagImage = [UIImage imageNamed:@"Map_pin3.png"];
        // You may need to resize the image here.
        aView.image = flagImage;
        
        
    }
    aView.annotation = annotation;
    return aView;
}
-(void)zoomToFitMapAnnotations:(MKMapView*)mV
{
    if([mV.annotations count] == 0)
        return;
//	float l= [[[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] floatValue];
//    float g= [[[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] floatValue];
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
	
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
	
    //    for(DisplayMap *annotation in mV.annotations)
    //    {
    // annotation.coordinate.longitude
    //annotation.coordinate.latitude
    topLeftCoord.longitude = fmin(topLeftCoord.longitude, [longitudeStr doubleValue]);
    topLeftCoord.latitude = fmax(topLeftCoord.latitude,[latitudeStr doubleValue]);
    
    bottomRightCoord.longitude = fmax(bottomRightCoord.longitude,[longitudeStr doubleValue]);
    bottomRightCoord.latitude = fmin(bottomRightCoord.latitude,[latitudeStr doubleValue]);
    // }
	NSLog(@"%f,%f",topLeftCoord.latitude, bottomRightCoord.latitude);
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude)*0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude)*0.5;
    //    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    //    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    region.span.latitudeDelta=30/69.0f;
    region.span.longitudeDelta=30/69.0f;
	NSLog(@"%f,%f",region.span.latitudeDelta,region.span.longitudeDelta);
    region = [mV regionThatFits:region];
    [mV setRegion:region animated:YES];
}
-(void)getDetails
{
    if (_getData!=nil) {
        [_getData release];
    }
    _getData=[[NSMutableData alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading...";
    
        //_userIdStr
    NSString *post =[NSString stringWithFormat:@"count=%d",[_userIdStr intValue]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //set up the request to the website
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSString *urlString=[NSString stringWithFormat:@"http://ipissarides.com/necixy/imageOutput.php"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    CustomURLConnection *conn = [[CustomURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:@"1"];
    [conn start];
}
-(void)likeDislike
{
    if (_likeDislikeData !=nil) {
        [_likeDislikeData release];
    }
    _likeDislikeData = [[NSMutableData alloc] init];
    
    NSString *post =[NSString stringWithFormat:@"catId=%d",[_userIdStr intValue]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //set up the request to the website
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSString *urlString=[NSString stringWithFormat:@"http://ipissarides.com/necixy/Like-Dislike.php"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    CustomURLConnection *conn = [[CustomURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:@"4"];
    [conn start];
}
#pragma mark Connection delegate Methods

-(void)connection: (CustomURLConnection*) connection didReceiveData: (NSData*)data
{
    if ([connection.tag isEqualToString:@"1"]) {
        [_getData appendData:data];
        NSLog(@"Call 1");
    }
    else if ([connection.tag isEqualToString:@"2"]) {
        [_responseData appendData:data];
        NSLog(@"Call 2");
    }
    else if ([connection.tag isEqualToString:@"3"]) {
        [_disresponseData appendData:data];
        NSLog(@"Call 3");
    }
    else if ([connection.tag isEqualToString:@"4"]) {
        [_likeDislikeData appendData:data];
        NSLog(@"Call 4");
    }

}
-(void)connection:(CustomURLConnection *)connection didFailWithError:(NSError *)error
{
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please check you are connected to the internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    NSLog(@"Error is %@",error);

    
}

-(void) connectionDidFinishLoading:(CustomURLConnection *)connection
{
     if ([connection.tag isEqualToString:@"1"]) {
    NSString *result=[[[NSString alloc]initWithData:_getData encoding:NSUTF8StringEncoding]autorelease];
    NSLog(@"result si %@",result);
    
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error1 = nil;
    
    // In "real" code you should surround this with try and catch
    
    NSMutableArray *array  = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error1] mutableCopy];
    for (int i = 0; i<array.count; i++) {
        NSMutableDictionary *dict = [array objectAtIndex:i];
        [_imageNameArray addObject:[dict valueForKey:@"imageName"]];
        NSLog(@"Image NAme is%@", [_imageNameArray objectAtIndex:i]);
        }
    
    [self LoadImage];
     }
     else if ([connection.tag isEqualToString:@"2"]) {
         NSString *result=[[[NSString alloc]initWithData:_responseData encoding:NSUTF8StringEncoding]autorelease];
         NSLog(@"result si %@",result);

         int p = [result intValue];
         if (p==1) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You already like this report." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             [alert release];
         }
         [self likeDislike];

     }
     else if ([connection.tag isEqualToString:@"3"]) {
         NSString *result=[[[NSString alloc]initWithData:_disresponseData encoding:NSUTF8StringEncoding]autorelease];
         NSLog(@"result si %@",result);
         
         int p = [result intValue];
         if (p==1) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You already dislike this report." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             [alert release];
         }
         [self likeDislike];
     }
     else if ([connection.tag isEqualToString:@"4"]) {
         NSString *result=[[[NSString alloc]initWithData:_likeDislikeData encoding:NSUTF8StringEncoding]autorelease];
         NSLog(@"result si %@",result);
         
         
         NSScanner *scanner = [NSScanner scannerWithString:result];
         [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@":"]];
         
         NSString *str = nil;
         //  int max;
         NSMutableArray *likeDislike=[[NSMutableArray alloc]init];
         while ([scanner scanUpToString:@":" intoString:&str])
         {
             [likeDislike addObject:str];
         }
         _likeLbl.text = [likeDislike objectAtIndex:0];
         _dislikeLbl.text = [likeDislike objectAtIndex:1];
         NSLog(@"Value is %@", likeDislike);
         
     }

    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)LoadImage{
    float x;
    
    for (int i = 0; i<_imageNameArray.count; i++) {
        if (i==0) {
            x = 7;
        }
        else{
            x = 7+98*i;
        }
         HJManagedImageV *image = [[HJManagedImageV alloc]initWithFrame:CGRectMake(x, 5, 88, 88)];
        NSString *urlString = [@"http://ipissarides.com/necixy/uploaded_image/thumbnail_image/" stringByAppendingFormat:@"%@",[_imageNameArray objectAtIndex:i]];
        image.url = [NSURL URLWithString:urlString];
        image.layer.cornerRadius=5.0;
        image.layer.masksToBounds=YES;
        image.layer.borderWidth=2.5;
        image.layer.borderColor=[UIColor blackColor].CGColor;
        [_objManager manage:image];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [_imageScrollView addSubview:image];
        
    }
    [_imageScrollView setContentSize:CGSizeMake(7+88*(_imageNameArray.count+1), 97)];
    [self likeDislike];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [annot release];
    [_mapView release];
    [_imageScrollView release];
    [_descriptionTxtView release];
    [_titleLbl release];
    [_detailView release];
    [_userNameLbl release];
    [_likeBtn release];
    [_dislikeBtn release];
    [_likeLbl release];
    [_dislikeLbl release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDetailView:nil];
    [self setUserNameLbl:nil];
    [self setLikeBtn:nil];
    [self setDislikeBtn:nil];
    [self setLikeLbl:nil];
    [self setDislikeLbl:nil];
    [super viewDidUnload];
}
- (IBAction)likeBtn:(id)sender {
    if (_responseData !=nil) {
        [_responseData release];
    }
    _responseData = [[NSMutableData alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Sending Data...";
    NSLog(@"Last calling report_id=%@&user_id=%@ ",_userIdStr ,_fbString);
    NSString *post =[NSString stringWithFormat:@"model=%@&report_id=%@&user_id=%@", @"User", _userIdStr ,_fbString];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //set up the request to the website
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSString *urlString=[NSString stringWithFormat:@"http://ipissarides.com/necixy/like.php"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    CustomURLConnection *conn = [[CustomURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:@"2"];
    [conn start];
}
- (IBAction)dislikeBtn:(id)sender {
    if (_disresponseData !=nil) {
        [_disresponseData release];
    }
    _disresponseData = [[NSMutableData alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Sending Data...";
    NSLog(@"Last calling report_id=%@&user_id=%@ ",_userIdStr ,_fbString);
    NSString *post =[NSString stringWithFormat:@"model=%@&report_id=%@&user_id=%@", @"User", _userIdStr ,_fbString];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //set up the request to the website
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSString *urlString=[NSString stringWithFormat:@"http://ipissarides.com/necixy/dislike.php"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    CustomURLConnection *conn = [[CustomURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:@"3"];
    [conn start];

}
@end
