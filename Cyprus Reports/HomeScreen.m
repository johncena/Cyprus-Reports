//
//  HomeScreen.m
//  Cyprus Reports
//
//  Created by Menelaos on 12/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import "HomeScreen.h"
#import "DetailsScreen.h"
#import "SelectedDetailView.h"

@interface HomeScreen ()

@end

@implementation HomeScreen
@synthesize alert, annot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [self.navigationItem setHidesBackButton:YES];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"nslog %@ , %@",_fbString, _fbNameString);
    
    isCurrentLocation = FALSE;
        _tabBarImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin ;
        _menuBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin ;
        _reportBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin ;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading...";
    _annot1 = [[MKPointAnnotation alloc] init];
    [_locationMapView addAnnotation:_annot1];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    _myCoordinat = _locationManager.location.coordinate;
    if (TARGET_IPHONE_SIMULATOR) {
        _myCoordinat.latitude = 35.1667;
        _myCoordinat.longitude = 33.3500;
    }
    [self CurrentLocation];
}



-(void)viewDidAppear:(BOOL)animated{
    self.title = @"Cyprus Reports";
    
    _objManager = [[HJObjManager alloc] init];
    
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/flickr/"] ;
	HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
	_objManager.fileCache = fileCache;
    
    
    
    alert = [[MyAlertView alloc]init];
    alert.backgroundImageView.image = [UIImage imageNamed:@"MenuBackground.png"];
    [self.view addSubview:alert];
    
    
    _reportAlert = [[MyAlertView1 alloc]init];
    _reportAlert.backgroundImageView.image = [UIImage imageNamed:@"MenuBackground.png"];
    [self.view addSubview:_reportAlert];
    
    self.reportBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.menuBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _mapArray = [[NSMutableArray alloc] init];
    [self getDetails];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [alert release];
    [_menuBtn release];
    [_reportBtn release];
    [_menuView release];
    [_reportView release];
    [_menuBtn1 release];
    [_locationMapView release];
    [_tabBarImageView release];
    [_annot1 release];

    [super dealloc];
}

/*
 
*/

-(void)getDetails
{
    if (_getData!=nil) {
        [_getData release];
    }
    _getData=[[NSMutableData alloc] init];


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

#pragma mark Connection delegate Methods

-(void)connection: (NSURLConnection*) connection didReceiveData: (NSData*)data
{
	[_getData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please check you are connected to the internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    NSLog(@"Error is %@",error);
    
    //[WToast showWithText:@"Connection Failed,"];
    
    //    if ([[connection tag]isEqualToString:@"getData" ]) {
    //        NSLog(@"error--- %@",error);
    //        //[connection release];
    //    }
    
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *result=[[[NSString alloc]initWithData:_getData encoding:NSUTF8StringEncoding]autorelease];
    NSLog(@"result si %@",result);
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error1 = nil;
        NSDictionary *details = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error1];
    
        NSLog(@"details %@",details);
    
        self.mapArray = [[details valueForKey:@"userDetails"] mutableCopy];
    if (_mapArray.count!=0) {
        [_locationMapView setMapType:MKMapTypeStandard];
        [_locationMapView setZoomEnabled:YES];
        [_locationMapView setScrollEnabled:YES];
        MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
        for (int j=0; j<_mapArray.count; j++) {
            
            NSDictionary *dict=[_mapArray objectAtIndex:j];
            region.center.latitude = [[dict objectForKey:@"latitude"] floatValue];
            region.center.longitude = [[dict objectForKey:@"longitude"] floatValue];
            
            //        region.span.longitudeDelta = 0.10f;
            //        region.span.latitudeDelta = 0.10f;
            
            NSMutableArray *catArray = [[NSMutableArray alloc] initWithObjects:@"Accident", @"Bad weather", @"PotHoles", @"Police", @"Traffic Lights", @"Abandoned cars", @"Heavy Traffic", @"Other", nil];

            DisplayMap *ann = [[DisplayMap alloc] init];
            int type = [[dict valueForKey:@"category"] intValue]-1;

            ann.title = [catArray objectAtIndex:type];
//            ann.subtitle=[catArray objectAtIndex:type];
            ann.coordinate = region.center;
            ann.image= [@"http://ipissarides.com/necixy/uploaded_image/thumbnail_image/" stringByAppendingFormat:@"%@",[dict valueForKey:@"imageName"]];
            ann.dict=dict;
            ann.index=j;
        
            [_locationMapView addAnnotation:ann];
        }
    }
       else{
        [WToast showWithText:@"No reports"];
    }
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
        
        aView.leftCalloutAccessoryView = [[HJManagedImageV alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    if ([annotation isKindOfClass:[DisplayMap class]]) {
        DisplayMap *a = (DisplayMap*) annotation;
        [(HJManagedImageV *)aView.leftCalloutAccessoryView setUrl:[NSURL URLWithString:a.image]];
        [_objManager manage:(HJManagedImageV *)aView.leftCalloutAccessoryView];
        [(UIButton *)aView.rightCalloutAccessoryView setTag:a.index];
        [(UIButton *)aView.rightCalloutAccessoryView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
       aView.annotation = annotation;
    return aView;
}
-(IBAction)buttonPressed:(id)sender
{
    int myTag = [(UIButton *)sender tag];
    NSMutableDictionary *dict = [_mapArray objectAtIndex:myTag];
   int userId = [[dict objectForKey:@"id"] intValue];
    NSLog(@"mytag %d",myTag);
    NSLog(@"userId %d",userId);
    
    SelectedDetailView *screen = [[SelectedDetailView alloc]initWithNibName:@"SelectedDetailView" bundle:nil];
    screen.title = @"Report Details";
    screen.descriptionStr = [dict valueForKey:@"description"];
    int type = [[dict valueForKey:@"category"] intValue]-1;
    
   NSMutableArray *catArray = [[NSMutableArray alloc] initWithObjects:@"Accident", @"Bad weather", @"PotHoles", @"Police", @"Traffic Lights", @"Abandoned cars", @"Heavy Traffic", @"Other", nil];
//    ann.title = 
    screen.titleStr = [catArray objectAtIndex:type];
    screen.latitudeStr = [dict valueForKey:@"latitude"];
    screen.longitudeStr = [dict valueForKey:@"longitude"];
    screen.userIdStr = [dict valueForKey:@"id"];
    screen.fbIdString = [dict valueForKey:@"login_id"];
    screen.fbNameString = [dict valueForKey:@"fbusername"];
    screen.fbString = _fbString;

    
    
    
    
//    screen.title = @"Report Details";
//    NSLog(@"fb String is %@ Second %@", screen.fbString, _fbString);
//    NSMutableDictionary *dict = [getDetailArray objectAtIndex:indexPath.row];
//    
//    int type = [[dict valueForKey:@"category"] intValue]-1;
//    NSString *str  = [_categoryArray objectAtIndex:type];
//    
//    screen.titleStr = str;
    
    [self.navigationController pushViewController:screen animated:YES];
    [screen release];

}

- (IBAction)menuBtn:(id)sender {
    [_reportAlert hide];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
         alert.frame = CGRectMake(10, 0, 301, 350);
    }
    else{
        alert.frame = CGRectMake(10, 20 , 301, 407);
    }
    alert.clipsToBounds = YES;
//    [alert.menuBtn1 addTarget:self action:@selector(menuBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [alert.menuBtn2 addTarget:self action:@selector(menuBtn2:) forControlEvents:UIControlEventTouchUpInside];
    [alert.menuBtn3 addTarget:self action:@selector(menuBtn3:) forControlEvents:UIControlEventTouchUpInside];
//    [alert.menuBtn4 addTarget:self action:@selector(menuBtn4:) forControlEvents:UIControlEventTouchUpInside];
    [alert.menuBtn5 addTarget:self action:@selector(menuBtn5:) forControlEvents:UIControlEventTouchUpInside];
    [alert.menuBtn6 addTarget:self action:@selector(menuBtn6:) forControlEvents:UIControlEventTouchUpInside];
    [alert.menuCloseBtn addTarget:self action:@selector(menuViewCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:alert];
    [alert show];
    
//    [self.menuBtn setUserInteractionEnabled:NO];
//    [self.reportBtn setUserInteractionEnabled:NO];

}

- (IBAction)reportBtn:(id)sender {
    [alert hide];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        _reportAlert.frame = CGRectMake(10, 0, 301, 350);
    }
    else{
        _reportAlert.frame = CGRectMake(10, 20 , 301, 407);
    }
    _reportAlert.clipsToBounds = YES;
    [_reportAlert.menuBtn1 setTitle:@"Add Report" forState:UIControlStateNormal];
    [_reportAlert.menuBtn2 setTitle:@"Report by Category" forState:UIControlStateNormal];
    [_reportAlert.menuBtn3 setTitle:@"All Reports" forState:UIControlStateNormal];
    
//    [_reportAlert.menuBtn2 setTitle:@"Bad Weather" forState:UIControlStateNormal];
//    [_reportAlert.menuBtn3 setTitle:@"PotHoles" forState:UIControlStateNormal];
//    [_reportAlert.menuBtn4 setTitle:@"Police" forState:UIControlStateNormal];
//    [_reportAlert.menuBtn5 setTitle:@"Traffic Lights" forState:UIControlStateNormal];
//    [_reportAlert.menuBtn6 setTitle:@"Abondoned Cars" forState:UIControlStateNormal];
//    [_reportAlert.menuBtn7 setTitle:@"Heavy Traffic" forState:UIControlStateNormal];
//    [_reportAlert.menuBtn8 setTitle:@"Others" forState:UIControlStateNormal];
    
    [_reportAlert.menuBtn1 addTarget:self action:@selector(reportBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [_reportAlert.menuBtn2 addTarget:self action:@selector(reportBtn2:) forControlEvents:UIControlEventTouchUpInside];
    [_reportAlert.menuBtn3 addTarget:self action:@selector(reportBtn3:) forControlEvents:UIControlEventTouchUpInside];
//    [_reportAlert.menuBtn4 addTarget:self action:@selector(reportBtn4:) forControlEvents:UIControlEventTouchUpInside];
//    [_reportAlert.menuBtn5 addTarget:self action:@selector(reportBtn5:) forControlEvents:UIControlEventTouchUpInside];
//    [_reportAlert.menuBtn6 addTarget:self action:@selector(reportBtn6:) forControlEvents:UIControlEventTouchUpInside];
//    [alert.menuBtn7 addTarget:self action:@selector(reportBtn7:) forControlEvents:UIControlEventTouchUpInside];
//    [alert.menuBtn8 addTarget:self action:@selector(reportBtn8:) forControlEvents:UIControlEventTouchUpInside];
//    [alert.menuBtn9 addTarget:self action:@selector(reportBtn9:) forControlEvents:UIControlEventTouchUpInside];
    
//    [_reportAlert.menuCloseBtn addTarget:self action:@selector(reportViewCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:_reportAlert];
    [_reportAlert show];
//    [self.menuBtn setUserInteractionEnabled:NO];
//    [self.reportBtn setUserInteractionEnabled:NO];

}


#pragma mark Report View Buttons

- (IBAction)menuBtn1:(id)sender {

//    addReportScreen *screen = [[addReportScreen alloc]initWithNibName:@"addReportScreen" bundle:nil];
//    screen.title = @"Add Report";
//
//    [self.navigationController pushViewController:screen animated:YES];
//    [screen release];
    
    //    SelectedDetailView *ds =[[SelectedDetailView alloc]initWithNibName:@"SelectedDetailView" bundle:nil];
//    [self.navigationController pushViewController:ds animated:YES];


}

- (IBAction)menuBtn2:(id)sender {
//    NSLog(@"menu2");
//    
//    NSArray *activityItems;
//    
//    if (_tabBarImageView.image != nil) {
//        activityItems = @[@"fiuh", _tabBarImageView.image];
//    } else {
//        activityItems = @[@"My text is"];
//    }
//    
//    UIActivityViewController *activityController =
//    [[UIActivityViewController alloc]
//     initWithActivityItems:activityItems
//     applicationActivities:nil];
//    
//    [self presentViewController:activityController
//                       animated:YES completion:nil];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            NSLog(@"Cancelled");
            
        } else
            
        {
            NSLog(@"Done");
        }
        
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler =myBlock;
    
    [controller setInitialText:@"Try this awesome App"];
//    [controller addURL:[NSURL URLWithString:@"http://www.mobile.safilsunny.com"]];
//    [controller addImage:[UIImage imageNamed:@"fb.png"]];
    
    [self presentViewController:controller animated:YES completion:Nil];

}

- (IBAction)menuBtn3:(id)sender {
    NSLog(@"menu3");
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            NSLog(@"Cancelled");
            
        } else
            
        {
            NSLog(@"Done");
        }
        
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler =myBlock;
    
    [controller setInitialText:@"Try this awesome App"];
//    [controller addURL:[NSURL URLWithString:@"http://www.mobile.safilsunny.com"]];
//    [controller addImage:[UIImage imageNamed:@"fb.png"]];
    
    [self presentViewController:controller animated:YES completion:Nil];
  
}

- (IBAction)menuBtn4:(id)sender {
    NSLog(@"menu4");
//   [Appirater rateApp];
}

- (IBAction)menuBtn5:(id)sender {
    NSLog(@"menu5");
    HelpScreen *screen = [[HelpScreen alloc] initWithNibName:@"HelpScreen" bundle:nil];
    [self presentViewController:screen animated:YES completion:nil];
    [screen release];

}

- (IBAction)menuBtn6:(id)sender {
    NSLog(@"menu6");
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } 
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self ToastShow];

//    [self.menuBtn setUserInteractionEnabled:YES];
//    [self.reportBtn setUserInteractionEnabled:YES];
}

- (IBAction)menuViewCloseBtn:(id)sender {
    NSLog(@"menu1close");
    [self ToastShow];

//    [self.menuBtn setUserInteractionEnabled:YES];
//    [self.reportBtn setUserInteractionEnabled:YES];
}
-(void)ToastShow{
//    [WToast showWithText:@"Will be under next milestones."];
}

#pragma mark Report View Buttons

- (IBAction)reportBtn1:(id)sender {
    
    addReportScreen *screen = [[addReportScreen alloc]initWithNibName:@"addReportScreen" bundle:nil];
    screen.title = @"Add Report";
    screen.fbString = _fbString;
    screen.fbNameString = _fbNameString;
    [self.navigationController pushViewController:screen animated:YES];
    [screen release];
    


}

- (IBAction)reportBtn2:(id)sender {
    
    CategoryReportTable *Screen = [[CategoryReportTable alloc]initWithNibName:@"CategoryReportTable" bundle:nil];
    Screen.title = @"Report Lists";
    Screen.fbString = _fbString;
    NSLog(@"fb String is %@ Second %@", Screen.fbString, _fbString);
    [self.navigationController pushViewController:Screen animated:YES];
    [Screen release];


}

- (IBAction)reportBtn3:(id)sender {
    
    AllReports *Screen = [[AllReports alloc]initWithNibName:@"AllReports" bundle:nil];
    Screen.title = @"All Reports";
    Screen.fbString = _fbString;
    NSLog(@"fb String is %@ Second %@", Screen.fbString, _fbString);
    [self.navigationController pushViewController:Screen animated:YES];
    [Screen release];
    
}
#pragma mark Location Upadate Method

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (TARGET_IPHONE_SIMULATOR) {
        
    }
    else{
        if (newLocation.coordinate.latitude != oldLocation.coordinate.latitude  && newLocation.coordinate.longitude != oldLocation.coordinate.longitude) {
            
            //        NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
            //        NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            
            _myCoordinat = newLocation.coordinate;
            [self CurrentLocation];
        }
    }

}
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//}
- (void)locationManager:(CLLocationManager *)inManager didFailWithError:(NSError *)inError{
    if (inError.code ==  kCLErrorDenied) {
        NSLog(@"Location manager denied access - kCLErrorDenied");
        
        _myCoordinat.latitude = 35.1667;
        _myCoordinat.longitude = 33.3500;
        
        [self CurrentLocation];
    }
}

#pragma  mark Current Location
-(void)CurrentLocation{

    MKCoordinateRegion extentsRegion = MKCoordinateRegionMakeWithDistance(_myCoordinat, 800, 800);
    
    [_locationMapView setRegion:extentsRegion animated:YES];
    
    _annot1.coordinate = _myCoordinat;
}

@end
