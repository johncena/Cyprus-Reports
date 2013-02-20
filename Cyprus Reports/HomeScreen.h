//
//  HomeScreen.h
//  Cyprus Reports
//
//  Created by Menelaos on 12/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAlertView.h"
#import "addReportScreen.h"
#import <MapKit/MapKit.h>
#import "DisplayMap.h"
#import "WToast.h"
#import "MyAlertView1.h"
#import "HJObjManager.h"
#import "HJManagedImageV.h"
#import "CategoryReportTable.h"
#import "HelpScreen.h"
#import <Social/Social.h>
#import "Appirater.h"
#import <StoreKit/StoreKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AllReports.h"

@interface HomeScreen : UIViewController<MKMapViewDelegate, MKAnnotation, UINavigationControllerDelegate, CLLocationManagerDelegate>
{
    int categoryNumber;
    BOOL isCurrentLocation;
}
@property (retain, nonatomic) IBOutlet UIButton *menuBtn;
- (IBAction)menuBtn:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *reportBtn;
- (IBAction)reportBtn:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *menuView;
@property (retain, nonatomic) IBOutlet UIView *reportView;
@property (retain, nonatomic) IBOutlet UIButton *menuBtn1;
@property (retain, nonatomic) MyAlertView *alert;
@property (retain, nonatomic) MyAlertView1 *reportAlert;
- (IBAction)menuBtn1:(id)sender;
- (IBAction)menuBtn2:(id)sender;
- (IBAction)menuBtn3:(id)sender;
- (IBAction)menuBtn4:(id)sender;
- (IBAction)menuBtn5:(id)sender;
- (IBAction)menuBtn6:(id)sender;
- (IBAction)menuViewCloseBtn:(id)sender;

- (IBAction)reportBtn1:(id)sender;
- (IBAction)reportBtn2:(id)sender;


@property (retain, nonatomic) IBOutlet MKMapView *locationMapView;
@property (retain, nonatomic) MKPointAnnotation *annot;
@property(retain,nonatomic)HJObjManager *objManager;
@property (retain,nonatomic)NSMutableData *getData;
@property(retain,nonatomic)NSMutableArray *mapArray;
@property (retain, nonatomic) IBOutlet UIImageView *tabBarImageView;
-(void)getDetails;


@property (retain, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D myCoordinat;
@property (retain, nonatomic)MKPointAnnotation *annot1;
@property (retain, nonatomic) NSString *fbString;
@property (retain, nonatomic) NSString *fbNameString;
@end
