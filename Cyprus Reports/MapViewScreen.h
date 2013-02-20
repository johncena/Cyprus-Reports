//
//  MapViewScreen.h
//  Cyprus Reports
//
//  Created by Menelaos on 14/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DisplayMap.h"

@interface MapViewScreen : UIViewController<MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) MKPointAnnotation *annot;
- (IBAction)backBtn:(id)sender;
- (void)handleTap:(UITapGestureRecognizer*)recognizer;
@property (retain, nonatomic) IBOutlet UIToolbar *TopToolBar;
-(void)zoomToFitMapAnnotations:(MKMapView*)mV;
-(void)setLocation;
@property (retain, nonatomic) CLLocationManager *locationManager;

@end
