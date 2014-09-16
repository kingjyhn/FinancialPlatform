//
//  TrendView.h
//  FinancialPlatform
//
//  Created by  on 14-8-31.
//  Copyright (c) 2014年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrendDelegate <NSObject>

- (void)didSelectedTrendCellAt:(NSIndexPath*)indexPath forTrendNum:(int)trendIndex;

@end

@interface TrendView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic) NSArray *data;
@property (retain,nonatomic) NSString *title;
@property (nonatomic) int  trendIndex;
@property (retain,nonatomic) id<TrendDelegate> trendDelegate;

@end
