//
//  IntroViewController.m
//  FinancialPlatform
//
//  Created by  on 14-8-23.
//  Copyright (c) 2014年 yuanxin. All rights reserved.
//

#import "IntroViewController.h"
#import "Intro1ViewController.h"
#import "Intro2ViewController.h"
#import "AppDelegate.h"

@interface IntroViewController ()<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *baseView;
    IBOutlet UIPageControl *pageCtl;
}

- (IBAction)cancelAction:(id)sender;

@end

@implementation IntroViewController

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
    [self initBaseViews:2];
    // Do any additional setup after loading the view.
}

- (void)initBaseViews:(NSInteger)introNum
{
    baseView.bounces = NO;
    baseView.pagingEnabled = YES;
    baseView.delegate = self;
    pageCtl.numberOfPages = introNum;
    pageCtl.currentPage = 0;
     [pageCtl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [baseView setContentSize:CGSizeMake(baseView.frame.size.width * introNum, baseView.frame.size.height) ];
    for (int index = 1; index <= introNum; index++) {
        switch (index) {
            case 1:{
                Intro1ViewController *intro1 = [[Intro1ViewController alloc] init];
                intro1.view.frame = CGRectMake(baseView.frame.size.width * (index - 1), 0, intro1.view.frame.size.width, intro1.view.frame.size.height);
                [baseView addSubview:intro1.view];
            }
                break;
            case 2:{
                Intro2ViewController *intro2 = [[Intro2ViewController alloc] init];
                intro2.view.frame = CGRectMake(baseView.frame.size.width * (index - 1), 0, intro2.view.frame.size.width, intro2.view.frame.size.height);
                [baseView addSubview:intro2.view];
            }
                break;
            default:
                break;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = baseView.contentOffset.x / baseView.frame.size.width;
    pageCtl.currentPage = page;
}

- (IBAction)changePage:(id)sender {
    int page = pageCtl.currentPage;
    [baseView setContentOffset:CGPointMake(baseView.frame.size.width * page, 0)];
}

- (IBAction)cancelAction:(id)sender
{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveIntro" object:nil];
    [self performSelector:@selector(dissoveView) withObject:nil afterDelay:0];
    //[self performSelector:@selector(removeView) withObject:nil afterDelay:0.8];
}

- (void)dissoveView
{
    [UIView animateWithDuration:0.8
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         [self removeView];
                     }];
}

- (void)removeView
{
    [self.view removeFromSuperview];
    
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
