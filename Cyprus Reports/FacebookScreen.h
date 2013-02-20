//
//  FacebookScreen.h
//  Cyprus Reports
//
//  Created by necixy on 31/01/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"
#import "WToast.h"
#import "HomeScreen.h"
#import "addReportScreen.h"

@interface FacebookScreen : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *authButton;
- (IBAction)authButtonAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *twitterImage;
@property (retain, nonatomic) IBOutlet UIButton *twitterBtn;
- (IBAction)twitterBtn:(id)sender;
@property (strong, nonatomic) FBProfilePictureView *profilePic;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSString *fbIdString;
@property (retain, nonatomic) NSString *twitterIdString;
@property (retain, nonatomic) NSString *nameString;
-(void)SendLoginData;
@property(retain,nonatomic) TWTweetComposeViewController *tweetViewController;

@end
