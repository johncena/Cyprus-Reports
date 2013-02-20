//
//  MyAlertView1.h
//  Cyprus Reports
//
//  Created by Menelaos on 19/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertView1 : UIView
{
CGPoint lastTouchLocation;
CGRect originalFrame;
BOOL isShown;
}

@property (nonatomic) BOOL isShown;
@property(retain, nonatomic) UIButton *menuBtn1;
@property(retain, nonatomic) UIButton *menuBtn2;
@property(retain, nonatomic) UIButton *menuBtn3;
@property(retain, nonatomic) UIButton *menuBtn4;
@property(retain, nonatomic) UIButton *menuBtn5;
@property(retain, nonatomic) UIButton *menuBtn6;
@property(retain, nonatomic) UIButton *menuBtn7;
@property(retain, nonatomic) UIButton *menuBtn8;
@property(retain, nonatomic) UIButton *menuBtn9;
@property(retain, nonatomic) UIButton *menuCloseBtn;
@property(retain, nonatomic) UIImageView *backgroundImageView;

@property(retain, nonatomic) UITextView *DetailText;
- (void)show;
- (void)hide;

@end
