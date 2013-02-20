//
//  addReportScreen.h
//  Cyprus Reports
//
//  Created by Menelaos on 14/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON/JSON.h"
#import "CJSONDeserializer.h"
#import "MapViewScreen.h"
#import "DetailsScreen.h"
#import "MBProgressHUD.h"
#import "WToast.h"
#import "CustomURLConnection.h"
#import "PZDropDown.h"
#import <CoreLocation/CoreLocation.h>
#import "FacebookScreen.h"

@interface addReportScreen : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>{
    int imageValue;
    int imageButtonTag;
    int userId;
    BOOL imageMethodCall;
    int imageNumber;
}
- (IBAction)sendBtn:(id)sender;
- (IBAction)mapBtn:(id)sender;
- (IBAction)addBtn:(id)sender;
-(void)imageSave;
-(void)SendImageData;
- (IBAction)addImageBtn:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *titleTxt;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTxt;
@property (retain, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (retain, nonatomic) CLLocationManager *locationManager;


@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSUserDefaults *perf;
//-(void)getData;

@property (retain, nonatomic) IBOutlet UIButton *addImageBtn;
@property (retain, nonatomic) NSMutableData *imageData;
@property (retain, nonatomic) NSMutableData *sendImageData;
@property (retain, nonatomic) NSMutableArray *imageNameArray;

@property (retain, nonatomic) NSMutableArray *imageArray;
@property (retain, nonatomic) IBOutlet UIView *fullView;
@property (retain, nonatomic) IBOutlet UIImageView *fullImageView;
@property (retain, nonatomic) IBOutlet UIButton *fullCloseBtn;
@property (retain, nonatomic) IBOutlet PZDropDown *categoryBtn;
@property (retain, nonatomic) NSMutableArray *categoryArray;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) IBOutlet UIButton *saveBtn;
@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (retain, nonatomic) NSString *fbString;
@property (retain, nonatomic) NSString *fbNameString;

@end
