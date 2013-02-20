//
//  AllReports.h
//  Cyprus Reports
//
//  Created by necixy on 02/02/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedDetailView.h"

@interface AllReports : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *allReportList;
@property (retain, nonatomic) NSString *fbString;
@property (retain, nonatomic) NSMutableArray *getDetailArray;
@property (retain, nonatomic) NSMutableArray *categoryArray;
-(void)getData;
@property (retain, nonatomic) NSMutableData *responseData;

@end
