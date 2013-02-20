//
//  DisplayMap.h
//  SocialTagApp
//
//  Created by Menelaos on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>

@interface DisplayMap : NSObject <MKAnnotation,CLLocationManagerDelegate> {
    
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
  
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic,copy)NSDictionary *dict;
@property(nonatomic,copy)NSString *image;
@property(assign)int index;
@end
