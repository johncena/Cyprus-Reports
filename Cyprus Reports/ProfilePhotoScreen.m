//
//  ProfilePhotoScreen.m
//  SocialTagApp
//
//  Created by Kshitiz Godara on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfilePhotoScreen.h"

@implementation ProfilePhotoScreen
@synthesize photoImageView;
@synthesize photoScrollView,imageName,objManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return photoImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",imageName);
   
        self.navigationController.navigationBarHidden=TRUE;
 	objManager = [[HJObjManager alloc] init];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/flickr/"] ;
	HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
	objManager.fileCache = fileCache;
	
	
	photoScrollView.contentSize = CGSizeMake(photoImageView.frame.size.width, photoImageView.frame.size.height);
	photoScrollView.maximumZoomScale = 4.0;
	photoScrollView.minimumZoomScale = 1.0;
	photoScrollView.clipsToBounds = YES;
	
	photoImageView.imageView.contentMode = UIViewContentModeCenter;
    
 [self showRemotePhoto:[NSURL URLWithString:imageName]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
   
    [self setPhotoImageView:nil];
    [self setPhotoScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
       [photoImageView release];
    [photoScrollView release];
    [super dealloc];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) showRemotePhoto:(NSURL*) photoURL
{
    
    //  ratingBarButtonItem.title=[NSString stringWithFormat:@"%0.2f/5",rating];    
    photoImageView.loadingWheel.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
	[photoImageView showLoadingWheel];
    photoImageView.loadingWheel.center=CGPointMake(160, 160); // so that loadingwheel comes in middle
	photoImageView.url = photoURL;
    photoImageView.contentMode=UIViewContentModeScaleAspectFit;
    //photoImageView.imageView.frame=photoImageVi
	[self.objManager manage:photoImageView];
    
}


@end
