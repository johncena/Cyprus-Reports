//
//  MyAlertView.m
//  LoanCalCap
//
//  Created by Menelaos on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView
@synthesize isShown;
@synthesize  menuBtn2, menuBtn3, menuBtn4;
@synthesize menuBtn5, menuBtn6, menuBtn7, menuBtn8;
@synthesize menuBtn9, menuCloseBtn, backgroundImageView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        originalFrame = frame;
        
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
        backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MenuBackground.png"]];
        
        [self addSubview:backgroundImageView];

        
//        menuBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        menuBtn1.frame = CGRectMake(52, 30, 196, 57);
//        [menuBtn1 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
//        [menuBtn1 setTitle:@"Reports" forState:UIControlStateNormal];
//        [menuBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [menuBtn1 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:menuBtn1];

        menuBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        menuBtn2.frame = CGRectMake(52, 80 ,196, 57);
        [menuBtn2 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
        [menuBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [menuBtn2 setTitle:@"Facebook" forState:UIControlStateNormal];
        [menuBtn2 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn2];

        menuBtn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        menuBtn3.frame = CGRectMake(52, 140, 196, 57);
        [menuBtn3 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
        [menuBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [menuBtn3 setTitle:@"Twitter" forState:UIControlStateNormal];
        [menuBtn3 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn3];

//        menuBtn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        menuBtn4.frame = CGRectMake(52, 180, 196, 57);
//        [menuBtn4 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
//        [menuBtn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//        [menuBtn4 setTitle:@"Rate" forState:UIControlStateNormal];
//        [menuBtn4 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:menuBtn4];

        menuBtn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        menuBtn5.frame = CGRectMake(52, 200, 196, 57);
        [menuBtn5 setTitle:@"Help" forState:UIControlStateNormal];
        [menuBtn5 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
        [menuBtn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [menuBtn5 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn5];

        menuBtn6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        menuBtn6.frame = CGRectMake(52, 260, 196, 57);
        [menuBtn6 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
        [menuBtn6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [menuBtn6 setTitle:@"Sign Out" forState:UIControlStateNormal];
        [menuBtn6 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn6];


//        menuBtn9 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        menuBtn9.frame = CGRectMake(10, 198, 196, 57);
//        [menuBtn9 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
//
//        [menuBtn9 setTitle:@"9" forState:UIControlStateNormal];
//        [menuBtn9 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:menuBtn9];
        
        menuCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuCloseBtn.frame = CGRectMake(275, 5, 25, 25);
      
        [menuCloseBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuCloseBtn];
    }
    return self;
}
#pragma mark Custom alert methods


- (void)show
{
    NSLog(@"show");
    isShown = YES;
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [UIView beginAnimations:@"showAlert" context:nil];
    [UIView setAnimationDelegate:self];
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.alpha = 1;
    [UIView commitAnimations];
}

- (void)hide
{
    NSLog(@"hide");
    isShown = NO;
    [UIView beginAnimations:@"hideAlert" context:nil];
    [UIView setAnimationDelegate:self];
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [UIView commitAnimations];
    
}

- (void)toggle
{
    if (isShown) {
        [self hide];
    } else {
        [self show];
    }
}

#pragma mark Animation delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"showAlert"]) {
        if (finished) {
            [UIView beginAnimations:nil context:nil];
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [UIView commitAnimations];
        }
    } else if ([animationID isEqualToString:@"hideAlert"]) {
        if (finished) {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.frame = originalFrame;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
