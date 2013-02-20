//
//  DetailsScreen.h
//  Cyprus Reports
//
//  Created by Menelaos on 17/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import "SelectedDetailView.h"
#import "MBProgressHUD.h"
#import "WToast.h"

@interface DetailsScreen : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@property (retain, nonatomic) NSMutableArray *getDetailArray;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSUserDefaults *perf;
-(void)getData;
@property(assign)int catId;
@property (retain, nonatomic) NSString *fbString;
@property (retain, nonatomic) NSMutableArray *categoryArray;

@end
