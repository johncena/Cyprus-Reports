//
//  MyAlertView.h
//  LoanCalCap
//
//  Created by Menelaos on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//MyAlertView *alert = [[MyAlertView alloc] initWithFrame:CGRectMake(10, 150, 300, 180)];
//[self.view addSubview:alert];
//[alert.SendButton addTarget:self action:@selector(ComposeMail) forControlEvents:UIControlEventTouchUpInside];
//alert.Agentlabel.text= NameString;
//alert.Agencylabel.text= AgencyString;
//alert.Phonelabel.text= PhoneString;
//alert.Pricelabel.text=PriceString;
//alert.DetailText.text= DetailString;
//alert.Subrublabel.text=SuburbString;
//[alert release];
//[alert show];


#import <UIKit/UIKit.h>

@interface MyAlertView : UIView{
    CGPoint lastTouchLocation;
    CGRect originalFrame;
    BOOL isShown;
}

@property (nonatomic) BOOL isShown;
//@property(retain, nonatomic) UIButton *menuBtn1;
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
