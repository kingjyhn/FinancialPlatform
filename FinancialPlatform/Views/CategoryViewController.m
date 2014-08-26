//
//  CategoryViewController.m
//  FinancialPlatform
//
//  Created by  on 14-8-24.
//  Copyright (c) 2014年 yuanxin. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CategoryViewController ()
{
    NSMutableArray *imgArray;
}
@end

@implementation CategoryViewController

@synthesize selectedIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.semiTableView.scrollEnabled = NO;
    self.semiTableView.layer.borderWidth = 1;
    self.semiTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    self.titleLabelHeight = 0.0;
    self.semiTableView.alpha = 1.0f;
    [self.dateSourceArray addObject:@"主页"];
    [self.dateSourceArray addObject:@"我的账户"];
    [self.dateSourceArray addObject:@"我的组合"];
    [self.dateSourceArray addObject:@"关注"];
    [self.dateSourceArray addObject:@"投资顾问"];
    [self.dateSourceArray addObject:@"我的圈子"];
    imgArray = [[NSMutableArray alloc] init];
    [imgArray addObject:[UIImage imageNamed:@"category1"]];
    [imgArray addObject:[UIImage imageNamed:@"category2"]];
    [imgArray addObject:[UIImage imageNamed:@"category3"]];
    [imgArray addObject:[UIImage imageNamed:@"category4"]];
    [imgArray addObject:[UIImage imageNamed:@"category5"]];
    [imgArray addObject:[UIImage imageNamed:@"category6"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dateSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCellIdentifier";

    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.dateSourceArray[indexPath.row];
    if (indexPath.row == selectedIndex) {
        cell.titleLabel.textColor = [UIColor blackColor];
    }else{
        cell.titleLabel.textColor = [UIColor grayColor];
    }
    cell.imageView.image = imgArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = (int)indexPath.row;
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"SelectIndex" object:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",selectedIndex] forKey:@"index"]];
    [self dismissSemi:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
