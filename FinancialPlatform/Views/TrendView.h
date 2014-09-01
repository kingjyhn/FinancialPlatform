//
//  TrendView.h
//  FinancialPlatform
//
//  Created by  on 14-8-31.
//  Copyright (c) 2014年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic) NSArray *data;
@property (retain,nonatomic) NSString *title;

@end
