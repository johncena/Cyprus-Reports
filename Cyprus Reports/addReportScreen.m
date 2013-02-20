//
//  addReportScreen.m
//  Cyprus Reports
//
//  Created by Menelaos on 14/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import "addReportScreen.h"

@interface addReportScreen ()

@end

@implementation addReportScreen
@synthesize responseData, perf;
@synthesize imageData, imageArray ;

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
    perf = [NSUserDefaults standardUserDefaults];
   
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (screenRect.size.height == 480) {
        NSLog(@"480");
        _mainScrollView.frame = CGRectMake(0, 88, 320, 450);
        [_mainScrollView setContentSize:CGSizeMake(320, 530)];
        _photoScrollView.frame = CGRectMake(14, 251, 291, 107);
        _saveBtn.center = CGPointMake(self.view.center.x, 387);
    }

//    _mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    NSLog(@"fbstring %@ ,%@",_fbString, _fbNameString);
    imageArray = [[NSMutableArray alloc] init];
    imageValue =0;
    imageButtonTag = 0;
    imageMethodCall = 0;
    imageNumber = 0;
    _imageNameArray = [[NSMutableArray alloc] init];
    _categoryArray = [[NSMutableArray alloc] initWithObjects:@"Accident", @"Bad weather", @"PotHoles", @"Police", @"Traffic Lights", @"Abandoned cars", @"Heavy Traffic", @"Other", nil];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [_locationManager startUpdatingLocation];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [_categoryBtn setContents:_categoryArray];
    
//    [self getData];
}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    _mainScrollView.contentSize=CGSizeMake(200.0,420.0);
//}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSString *lati = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    NSString *longi = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude ];

    
    [[NSUserDefaults standardUserDefaults] setObject:lati forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:longi forKey:@"longitude"];
       
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_locationManager stopUpdatingLocation];
    
}
//-(void)getData{
//    int userId = [[perf stringForKey:@"userId"] intValue];
//    NSLog(@"userId %d",userId);
//    if (responseData !=nil) {
//        [responseData release];
//    }
//    responseData = [[NSMutableData alloc] init];
//    
//    NSString *post =[NSString stringWithFormat:@"model="];
//    
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    
//    //set up the request to the website
//    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
//    
//    NSString *urlString=[NSString stringWithFormat:@"http://ipissarides.com/necixy/reportOutput.php"];
//    
//    [request setURL:[NSURL URLWithString:urlString]];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    
//    
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [conn start];
//}
-(void)imageSave{
    
    
    imageMethodCall = 1;
    NSData *images = UIImagePNGRepresentation((UIImage *)[imageArray objectAtIndex:imageValue]);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddhhmmss"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    
    NSLog(@"\n""theDate:%@ ", theDate);
    [_imageNameArray addObject:theDate];
    [dateFormat release];
    [timeFormat release];
    [now release];
    _hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * hudString = [@"Loading image " stringByAppendingFormat:@"%d...", imageValue+1];
    _hud.labelText = hudString;
    
//    if (imageData !=nil) {
//        [imageData release];
//    }
//    imageData= [[[NSMutableData alloc]init ]autorelease];
    NSString *urlString=[NSString stringWithFormat:@"http://ipissarides.com/necixy/saveImages.php"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;

       
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]   dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.png\"\r\n;",theDate] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:images];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [request setHTTPBody:body];
        imageValue++; 
        CustomURLConnection *conn = [[CustomURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES tag:@"2"];
        [conn start];
   
}

-(void)SendImageData{

    if (_sendImageData !=nil) {
        [_sendImageData release];
    }
    _sendImageData = [[NSMutableData alloc] init];
    NSString *finalStr = @"";
    //    NSString *post =[NSString stringWithFormat:@"model="];
    for (int i = 0; i< [_imageNameArray count]; i++) {
        NSLog(@"_IMAGE DATA %@",[_imageNameArray objectAtIndex:i]);

       NSString *str = [@"image" stringByAppendingFormat:@"%d=%@.png&",i+1,[_imageNameArray objectAtIndex:i]];
        NSLog(@"_Istr %@",str);
        finalStr=[finalStr stringByAppendingFormat:@"%@", str];
//               finalStr = [finalStr stringByAppendingString:str];
    }
    NSLog(@"FINAL STR %@",finalStr);
    NSString *post = [finalStr stringByAppendingString:[NSString stringWithFormat:@"reportId=%d&count=%d",userId,_imageNameArray.count]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //set up the request to the website
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSString *urlString=[NSString stringWithFormat:@"http://ipissarides.com/necixy/imageInput.php"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    CustomURLConnection *conn = [[CustomURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:@"3"];
    [conn start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark textfiled and textview delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark Close & Add Buttons 

- (IBAction)closeBtn:(id)sender {
    DetailsScreen *screen = [[DetailsScreen alloc]initWithNibName:@"DetailsScreen" bundle:nil];
    screen.title = @"Report Lists";

    [self.navigationController pushViewController:screen animated:YES];
    [screen release];
    NSLog(@"latitude_perf %@, longitude_perf %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"], [[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"]);
}

- (IBAction)addBtn:(id)sender {
//    [self imageSave];
    if ([_descriptionTxt.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please make sure description field is fill up." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if (imageArray.count == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please add minimum one image." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else{
        [self imageSave];
    }
}
- (IBAction)addImageBtn:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }
}
#pragma mark Imagepicker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    
    NSLog(@"image %f %f",image.size.width,image.size.height);
    float oldWidth = image.size.width;
    float scaleFactor = 320 / oldWidth;
    
    float newHeight = image.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSLog(@"newImage %f %f",newImage.size.width,newImage.size.height);
    
    
    
    
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [imageButton addTarget:self
//               action:@selector(imageButtonTap:)
//     forControlEvents:UIControlEventTouchUpInside];
    
    imageButton.tag = imageButtonTag;
    [imageButton setBackgroundImage:newImage forState:UIControlStateNormal];
    
    [imageArray addObject:newImage];
    imageButton.layer.cornerRadius=5.0;
    imageButton.layer.masksToBounds=YES;
    imageButton.layer.borderWidth=2.5;
    imageButton.layer.borderColor=[UIColor whiteColor].CGColor;
    imageButton.frame = self.addImageBtn.frame;
    CGRect frame = self.addImageBtn.frame;
    frame.origin.x += 120;
    self.addImageBtn.frame = frame;

    [self.photoScrollView setContentSize:CGSizeMake(frame.origin.x + 120, 105)];
    
    [self.photoScrollView setContentOffset:CGPointMake(self.addImageBtn.frame.origin.x -120,0) animated:YES];
    [self.photoScrollView addSubview:imageButton];
    [picker dismissModalViewControllerAnimated:YES];
    imageButtonTag++;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    
//    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark Send Data

- (IBAction)sendBtn:(id)sender {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //Set the AM and PM symbols
    [dateFormatter setAMSymbol:@"AM"];
    [dateFormatter setPMSymbol:@"PM"];
    //Specify only 1 M for month, 1 d for day and 1 h for hour
    [dateFormatter setDateFormat:@"M/d/yyyy h:mm:ss a"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [dateFormatter stringFromDate:now];
    
    
    NSLog(@"current date: %@", theDate);
    _hud.labelText = @"Loading details...";
    
    
    if (responseData !=nil) {
        [responseData release];
    }
    responseData = [[NSMutableData alloc] init];
    
    int type = [_categoryArray indexOfObject:[[_categoryBtn titleLabel]text]]+1;
   
    NSString *post =[NSString stringWithFormat:@"model=%@&title=%@&desc=%@&latitude=%@&longitude=%@&category=%d&imageName=%@.png&time=%@&login_id=%@&fb_name=%@", @"User", @"", self.descriptionTxt.text, [[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"], [[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"],type,[_imageNameArray objectAtIndex:0],theDate,_fbString,_fbNameString];

    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //set up the request to the website
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSString *urlString=[NSString stringWithFormat:@"http://ipissarides.com/necixy/reportInput.php"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [dateFormatter release];
    [now release];
    
    CustomURLConnection *conn = [[CustomURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:@"1"];
    [conn start];
}

- (IBAction)mapBtn:(id)sender {
    MapViewScreen *mapView = [[MapViewScreen alloc]initWithNibName:@"MapViewScreen" bundle:nil];
    [self presentViewController:mapView animated:YES completion:nil];

}

#pragma mark Connection delegate Methods

-(void)connection: (CustomURLConnection*) connection didReceiveData: (NSData*)data
{
	
    if ([connection.tag isEqualToString:@"1"]) {
        [responseData appendData:data];
        NSLog(@"Call 1");
    }
    else if([connection.tag isEqualToString:@"2"]) {
        [imageData appendData:data];
        
    }
    else if([connection.tag isEqualToString:@"3"]) {
        [_sendImageData appendData:data];
        
    }

}
-(void)connection:(CustomURLConnection *)connection didFailWithError:(NSError *)error
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
-(void) connectionDidFinishLoading:(CustomURLConnection *)connection
{
    if ([connection.tag isEqualToString:@"1"]) {
        NSString *result=[[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]autorelease];
        NSLog(@"Coming");
        NSLog(@"result si %@",result);
        userId = [result intValue];
       [self SendImageData];
         }
    
    else if ([connection.tag isEqualToString:@"2"]) {
        if (imageMethodCall == 1 ) {
            NSLog(@"imageVAlue %d, Image Count %d",imageValue, [imageArray count]);
            if (imageValue == [imageArray count]) {
                imageMethodCall = 0;
                [self sendBtn:self];
            }
            else{
                [self imageSave];
            }
        }
    }
    else if ([connection.tag isEqualToString:@"3"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [WToast showWithText:@"Successfully registered"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latitude"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longitude"];
        NSString *result=[[[NSString alloc]initWithData:_sendImageData encoding:NSUTF8StringEncoding]autorelease];
        NSLog(@"result si %@",result);
//        DetailsScreen *screen = [[DetailsScreen alloc] initWithNibName:@"DetailsScreen" bundle:nil];
//        screen.catId=0;
//        screen.title = @"Report Lists";
        [self.navigationController popViewControllerAnimated:YES];
//        [screen release];
    }
    
//    if([result isEqualToString:@"0"])
//    {
//        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        //        [WToast showWithText:@"Unknown Error Ocurred"];
//    }
//    else
//    {
//        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error1 = nil;
//        NSDictionary *details = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error1];
//        NSLog(@"details %@",details);
//    }
   }
- (void)dealloc {
    [imageArray release];
    [responseData release];
    [_titleTxt release];
    [_descriptionTxt release];
    [_photoScrollView release];
    [_addImageBtn release];
    [_fullView release];
    [_fullImageView release];
    [_fullCloseBtn release];
    [_categoryBtn release];
    [_saveBtn release];
    [_mainScrollView release];
    [super dealloc];
}

@end
