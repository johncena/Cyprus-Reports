//
//  SelectedDetailView.h
//  Cyprus Reports
//
//  Created by Menelaos on 17/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "CJSONDeserializer.h"
#import "HJObjManager.h"
#import "HJMOFileCache.h"
#import "HJManagedImageV.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CustomURLConnection.h"

@interface SelectedDetailView : UIViewController<MKMapViewDelegate, MKAnnotation>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTxtView;
@property (retain, nonatomic) IBOutlet UILabel *titleLbl;
@property (retain, nonatomic) NSString *latitudeStr;
@property (retain, nonatomic) NSString *longitudeStr;
@property (retain, nonatomic) NSString *titleStr;
@property (retain, nonatomic) NSString *descriptionStr;
@property (retain, nonatomic) NSString *userIdStr;
@property (retain, nonatomic) NSString *fbIdString;
@property (retain, nonatomic) NSString *fbNameString;
@property (retain, nonatomic) MKPointAnnotation *annot;
@property (retain,nonatomic)    NSMutableData *getData;
@property (retain,nonatomic)NSMutableArray *imageNameArray;
@property (retain,nonatomic)NSMutableData *getImageData;
@property (strong, nonatomic) FBProfilePictureView *profilePic;
@property (retain, nonatomic)HJObjManager *objManager;
-(void)zoomToFitMapAnnotations:(MKMapView*)mV;
-(void)getDetails;
@property (retain, nonatomic) IBOutlet UIView *detailView;
@property (retain, nonatomic) IBOutlet UILabel *userNameLbl;
@property (retain, nonatomic) IBOutlet UIButton *likeBtn;
- (IBAction)likeBtn:(id)sender;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSMutableData *disresponseData;

@property (retain, nonatomic) NSString *fbString;
@property (retain, nonatomic) IBOutlet UIButton *dislikeBtn;
- (IBAction)dislikeBtn:(id)sender;
-(void)likeDislike;
@property(retain, nonatomic) NSMutableData *likeDislikeData;
@property (retain, nonatomic) IBOutlet UILabel *likeLbl;
@property (retain, nonatomic) IBOutlet UILabel *dislikeLbl;


@end
