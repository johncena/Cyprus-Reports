//
//  FacebookScreen.m
//  Cyprus Reports
//
//  Created by necixy on 31/01/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "FacebookScreen.h"

@interface FacebookScreen ()

@end

@implementation FacebookScreen

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
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
//    _profilePic = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(20, 20, 75, 75)];
//    [self.view addSubview:_profilePic];
//    [self.view bringSubviewToFront:_profilePic];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_authButton release];
    [_twitterBtn release];
    [_twitterImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAuthButton:nil];
    [self setTwitterBtn:nil];
    [self setTwitterImage:nil];
    [super viewDidUnload];
}
- (IBAction)authButtonAction:(id)sender {
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        NSLog(@"Active");
        [appDelegate closeSession];
    } else {
        NSLog(@"Close");
        appDelegate.isLogin = TRUE;
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}
- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        //        self.userInfoTextView.hidden = NO;
        
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"fetch Data";
        
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             if (!error) {
                 NSLog(@"error");
                 NSString *userInfo = @"";
                 
                 // Example: typed access (name)
                 // - no special permissions required
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Name: %@\n\n",
                              user.name]];
                 
                 // Example: typed access, (birthday)
                 // - requires user_birthday permission
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Birthday: %@\n\n",
                              user.birthday]];
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"UserName: %@\n\n",
                              user.username]];
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Link: %@\n\n",
                              user.link]];
                 // Example: partially typed access, to location field,
                 // name key (location)
                 // - requires user_location permission
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Location: %@\n\n",
                              [user.location objectForKey:@"name"]]];
                 _nameString = user.first_name;
                 _nameString = [_nameString stringByAppendingString:user.last_name];
                 _fbIdString = user.id;
                 HomeScreen *screen = [[HomeScreen alloc] initWithNibName:@"HomeScreen" bundle:nil];
                 screen.fbString = _fbIdString;
                 screen.fbNameString = _nameString;
                 // Example: access via key (locale)
                 // - no special permissions required
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Locale: %@\n\n",
                              [user objectForKey:@"locale"]]];
                 
                 // Example: access via key for array (languages)
                 // - requires user_likes permission
                 if ([user objectForKey:@"languages"]) {
                     NSArray *languages = [user objectForKey:@"languages"];
                     NSMutableArray *languageNames = [[NSMutableArray alloc] init];
                     for (int i = 0; i < [languages count]; i++) {
                         [languageNames addObject:[[languages
                                                    objectAtIndex:i]
                                                   objectForKey:@"name"]];
                     }
                     userInfo = [userInfo
                                 stringByAppendingString:
                                 [NSString stringWithFormat:@"Languages: %@\n\n",
                                  languageNames]];
                 }

                 // Display the user info
                 //                 self.userInfoTextView.text = userInfo;
                 NSLog(@"User Info %@", userInfo);
                 
                 if ([_fbIdString isEqualToString:@""] || [_nameString isEqualToString:@""]){
                 }
                 else{
                     [self SendLoginData];
                 }
             }
         }];
    }

}


- (IBAction)twitterBtn:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	// Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            
			// Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
			
			// For the sake of brevity, we'll assume there is only one Twitter account present.
			// You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
			if ([accountsArray count] > 0) {
				// Grab the initial Twitter account to tweet from.
				ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
//				NSString *username = twitterAccount.username;
                NSLog(@"UserName:%@",twitterAccount.username);
                NSString *userID = [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"];
                NSString *fullName = [[twitterAccount valueForKey:@"properties"] valueForKey:@"fullName"];
                NSLog(@"userId:%@ fullName:%@",userID,fullName);
                NSLog(@"%@",twitterAccount);
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com//user?screen_name=%@",username]]];
                NSURL *url =
                [NSURL URLWithString:@"http://api.twitter.com/1/users/show.json"];
                
//                NSDictionary *params = [NSDictionary dictionaryWithObject:username
//                                        
//                                                                   forKey:@"screen_name"];
                
                NSDictionary *params = [NSDictionary dictionaryWithObject:userID
                                                                   forKey:@"user_id"];

                
                TWRequest *request = [[TWRequest alloc] initWithURL:url
                                      
                                                         parameters:params
                                      
                                                      requestMethod:TWRequestMethodGET];
                
                
                
                [request performRequestWithHandler:
                 
                 ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     
                     if (responseData) {
                         
                         NSDictionary *user =
                         
                         [NSJSONSerialization JSONObjectWithData:responseData
                          
                                                         options:NSJSONReadingAllowFragments
                          
                                                           error:NULL];
                         
                         
                         
                         NSString *profileImageUrl = [user objectForKey:@"profile_image_url"];
                         
                         
                         
                         //  As an example we could set an image's content to the image
                         
                         dispatch_async
                         
                         (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                             
                             NSData *imageData =
                             
                             [NSData dataWithContentsOfURL:
                              
                              [NSURL URLWithString:profileImageUrl]];
                             
                             
                             
                             UIImage *image = [UIImage imageWithData:imageData];
                             
                             
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 self.twitterImage.image = image;
                                 
                             });
                             
                         });
                         
                     }
                     
                 }];
			}
        }
        else
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] == 5.0)
            {
                
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
                
            }
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] == 6.0)
            {
                
                _tweetViewController = [[TWTweetComposeViewController alloc] init];
                
                
                // Create the completion handler block.
                [_tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result)
                 {
                     
                     [self dismissModalViewControllerAnimated:YES];
                 }];
                
                // Present the tweet composition view controller modally.
                [self performSelectorOnMainThread:@selector(myMethod) withObject:nil waitUntilDone:NO];            }
        }
	}];
   
}
-(void)myMethod
{
    
    [self presentModalViewController:_tweetViewController animated:YES];
    for (UIView *view in _tweetViewController.view.subviews)
    {
        NSLog(@"111");
        [view removeFromSuperview];
        
    }
    
}
#pragma mark Connection delegate Methods

-(void)connection: (CustomURLConnection*) connection didReceiveData: (NSData*)data
{
        [_responseData appendData:data];
    
}
-(void)connection:(CustomURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please check you are connected to the internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    NSLog(@"Error is %@",error);
    
}
-(void) connectionDidFinishLoading:(CustomURLConnection *)connection
{
    HomeScreen *screen = [[HomeScreen alloc] initWithNibName:@"HomeScreen" bundle:nil];
    screen.fbString = _fbIdString;
    screen.fbNameString = _nameString;
    NSLog(@"Print is %@", screen.fbString);
    if ([connection.tag isEqualToString:@"1"]) {
        NSString *result=[[[NSString alloc]initWithData:_responseData encoding:NSUTF8StringEncoding]autorelease];
        
        NSLog(@"result si %@",result);
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   
    [self.navigationController pushViewController:screen animated:YES];
//    [screen release];

    
}
-(void)SendLoginData{
    
    if (_responseData !=nil) {
        [_responseData release];
    }
    _responseData = [[NSMutableData alloc] init];
    NSString *post =[NSString stringWithFormat:@"model=%@&id=%@&name=%@", @"User", _fbIdString, _nameString];
    _hud.labelText = @"Loading details...";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    //set up the request to the website
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSString *urlString=[NSString stringWithFormat:@"http://ipissarides.com/necixy/Login.php"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    
    CustomURLConnection *conn = [[CustomURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:@"1"];
    [conn start];
}

@end
