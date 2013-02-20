//
//  CategoryReportTable.h
//  Cyprus Reports
//
//  Created by Menelaos on 19/12/12.
//  Copyright (c) 2012 Menelaos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsScreen.h"

@interface CategoryReportTable : UIViewController<UITableViewDataSource, UITableViewDelegate>
{

}
@property (retain, nonatomic) IBOutlet UITableView *categoryTbl;
@property (retain, nonatomic) NSMutableArray *categoryArray;
@property (retain, nonatomic) NSString *fbString;

@end
