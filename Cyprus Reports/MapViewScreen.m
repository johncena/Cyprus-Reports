//
//  MapViewScreen.m
//  Cyprus Reports
//
//  Created by Menelaos on 14/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import "MapViewScreen.h"

@interface MapViewScreen ()

@end

@implementation MapViewScreen
@synthesize annot;


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
        NSLog(@"480");
        _TopToolBar.frame = CGRectMake(0, 88, 320, 44);
    }

    annot = [[MKPointAnnotation alloc] init];
    float l= [[[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] floatValue];
    float g= [[[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] floatValue];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
   
    NSLog(@"Didi Lat %f, long %f",l ,g);
    if (TARGET_IPHONE_SIMULATOR) {
        l=35.1667;
        g=33.3500;
        NSString *langi = [NSString stringWithFormat:@"%f", l];
        NSString *longi = [NSString stringWithFormat:@"%f", g];
        [[NSUserDefaults standardUserDefaults] setObject:langi forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:longi forKey:@"longitude"];
        NSLog(@"in zero  Lat %@, long %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] ,[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"]);
    }
    [self setLocation];
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.mapView addGestureRecognizer:tapRecognizer];
    tapRecognizer.delegate = self;
    [tapRecognizer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_locationManager release];
    [annot release];
    [_mapView release];
    [_TopToolBar release];
    [super dealloc];
}
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
//    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
//        return;
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint touchPoint = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        annot.coordinate = touchMapCoordinate;
        [self.mapView addAnnotation:annot];
        NSString *lati = [NSString stringWithFormat:@"%f", annot.coordinate.latitude];
        NSString *longi = [NSString stringWithFormat:@"%f", annot.coordinate.longitude ];
        [[NSUserDefaults standardUserDefaults] setObject:lati forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:longi forKey:@"longitude"];
        NSLog(@"latitude %f, longitude %f", annot.coordinate.latitude, annot.coordinate.longitude);
        NSLog(@"latitude_perf %@, longitude_perf %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"], [[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"]);
    }
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"ImageMapView"];
    if (!aView)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ImageMapView1"];
        UIImage *flagImage = [UIImage imageNamed:@"Map_pin3.png"];
        // You may need to resize the image here.
        aView.image = flagImage;
        
    }
    aView.annotation = annotation;
    return aView;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
//    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
//    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    if (TARGET_IPHONE_SIMULATOR) {
        
    }
    else{
        if (newLocation.coordinate.latitude != oldLocation.coordinate.latitude  && newLocation.coordinate.longitude != oldLocation.coordinate.longitude) {
            
            NSString *langi = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
            NSString *longi = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
            [[NSUserDefaults standardUserDefaults] setObject:langi forKey:@"latitude"];
            [[NSUserDefaults standardUserDefaults] setObject:longi forKey:@"longitude"];
            
            NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
            NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            
        }
    }
}

-(void)zoomToFitMapAnnotations:(MKMapView*)mV
{
    if([mV.annotations count] == 0)
        return;
	float l= [[[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] floatValue];
    float g= [[[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] floatValue];

    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
	
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
	
//    for(DisplayMap *annotation in mV.annotations)
//    {
//  annotation.coordinate.longitude
//  annotation.coordinate.latitude
    topLeftCoord.longitude = fmin(topLeftCoord.longitude, g);
    topLeftCoord.latitude = fmax(topLeftCoord.latitude,l);
    
    bottomRightCoord.longitude = fmax(bottomRightCoord.longitude,g);
    bottomRightCoord.latitude = fmin(bottomRightCoord.latitude,l);
//  }
	NSLog(@"%f,%f",topLeftCoord.latitude, bottomRightCoord.latitude);
     NSLog(@"Lati %f, longi %f",l ,g);
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude)*0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude)*0.5;

    region.span.latitudeDelta=30/69.0f;
    region.span.longitudeDelta=30/69.0f;
	NSLog(@"%f,%f",region.span.latitudeDelta,region.span.longitudeDelta);
    region = [mV regionThatFits:region];
    [mV setRegion:region animated:YES];
}

#pragma mark Location Upadate Method

-(void)setLocation{
    float l= [[[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] floatValue];
    float g= [[[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] floatValue];
     NSLog(@"Lat %f, long %f",l ,g);
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude=l;
    region.center.longitude=g;
    annot.coordinate = region.center;
    [self.mapView addAnnotation:annot];
    [self zoomToFitMapAnnotations:_mapView];
}
- (void)viewDidUnload {
    [self setTopToolBar:nil];
    [super viewDidUnload];
}
@end
