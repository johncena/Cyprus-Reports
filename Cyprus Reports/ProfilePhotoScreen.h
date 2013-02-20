//
//  ProfilePhotoScreen.h
//  SocialTagApp
//
//  Created by Kshitiz Godara on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "HJObjManager.h"

@interface ProfilePhotoScreen : UIViewController<UIScrollViewDelegate>
{

}

@property (retain, nonatomic) IBOutlet HJManagedImageV *photoImageView;
@property (retain, nonatomic) IBOutlet UIScrollView *photoScrollView;
- (IBAction)backButtonPressed:(id)sender;
@property(retain,nonatomic)NSString *imageName;
@property(retain,nonatomic)HJObjManager *objManager;
-(void) showRemotePhoto:(NSURL*) photoURL;
@end
