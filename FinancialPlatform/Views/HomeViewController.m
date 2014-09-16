//
//  HomeViewController.m
//  FinancialPlatform
//
//  Created by  on 14-8-23.
//  Copyright (c) 2014年 yuanxin. All rights reserved.
//

#import "HomeViewController.h"
#import "StateServices.h"
#import "IntroViewController.h"
#import "Intro1ViewController.h"
#import "Intro2ViewController.h"
#import "AppDelegate.h"
#import "CategoryViewController.h"
#import "DXSemiViewControllerCategory.h"
#import "TrendViewController.h"
#import "TrendView.h"
#import "MyAccountViewController.h"
#import "MyCombinationViewController.h"
#import "FocusViewController.h"
#import "ConsultantViewController.h"
#import "MyCycleViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate,TrendDelegate>
{
    IntroViewController *introVC;
    BOOL isShowStatusBar;
    BOOL isShowCategoryView;
    BOOL isLoadIntroStatus;
    int categorySelectedIndex;
    NSMutableArray *recommendedViewsArray;
    NSMutableArray *trendKindArray;
    MyAccountViewController *myAccountView;
    MyCombinationViewController *myCombinationView;
    FocusViewController *focusView;
    ConsultantViewController *consultantView;
    MyCycleViewController *myCycleView;
}

@property (weak, nonatomic) IBOutlet UIView *recommendedView;
@property (weak, nonatomic) IBOutlet UIScrollView *recommendedScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *trendScrollView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *homeView;

@end

@implementation HomeViewController

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
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(removeIntro) name:@"RemoveIntro" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(categoryViewDismiss) name:@"CategoryViewDismiss" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(selectIndex:) name:@"SelectIndex" object:nil];
    [self loadCategoryViews];
    [self initStatus];
    [self loadIntroView];
    [self setBarItem];
    [self loadRecommendedView];
    [self loadTrendView];
}

- (void)loadCategoryViews
{
    myAccountView = [[MyAccountViewController alloc] init];
    [self.baseView addSubview:myAccountView.view];
    
    myCombinationView = [[MyCombinationViewController alloc] init];
    [self.baseView addSubview:myCombinationView.view];
    
    focusView = [[FocusViewController alloc] init];
    [self.baseView addSubview:focusView.view];
    
    consultantView = [[ConsultantViewController alloc] init];
    [self.baseView addSubview:consultantView.view];
    
    myCycleView = [[MyCycleViewController alloc] init];
    [self.baseView addSubview:myCycleView.view];
    
    [self.baseView bringSubviewToFront:self.homeView];
}

- (void)initStatus
{
    
    isShowCategoryView = NO;
    categorySelectedIndex = 0;
}

- (void)loadIntroView
{
    BOOL isFirstEntrance = [StateServices isFirstEntrance];
    if (isFirstEntrance) {
        introVC = [[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:nil];
        //[self.view addSubview:introVC.view];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            //[self prefersStatusBarHidden];
            //[self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            //[self setNeedsStatusBarAppearanceUpdate];
        }
        
        [[appDelegate window] addSubview:introVC.view];
    }
}

- (void)setBarItem
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"category"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(showCategory)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc]
                                     initWithImage:[UIImage imageNamed:@"person"]
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(showCategory)];
    UIBarButtonItem *rightButton2 = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"search"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(showCategory)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightButton1,rightButton2, nil]];
}

- (void)loadRecommendedView
{
    self.recommendedScrollView.pagingEnabled = YES;
    self.recommendedScrollView.showsHorizontalScrollIndicator = FALSE;
    self.recommendedScrollView.delegate = self;
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    NSArray *arr = [NSArray arrayWithObjects:[UIImage imageNamed:@"recommended1"],[UIImage imageNamed:@"recommended2"],[UIImage imageNamed:@"recommended3"], nil];
    for (int i = 0; i < [arr count]; i ++)
    {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * self.recommendedView.frame.size.width, 0, self.recommendedView.frame.size.width, self.recommendedView.frame.size.height)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        imgView.image = [arr objectAtIndex:i];
        [view addSubview:imgView];
        [tmpArr addObject:view];
    }
    
    recommendedViewsArray = [[NSMutableArray alloc] initWithArray:tmpArr];
    UIView *viewFirst = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.recommendedView.frame.size.width, self.recommendedView.frame.size.height)];
    UIImageView *imgViewFirst = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewFirst.frame.size.width, viewFirst.frame.size.height)];
    imgViewFirst.image = [arr lastObject];
    [viewFirst addSubview:imgViewFirst];
    [recommendedViewsArray  insertObject:viewFirst atIndex:0];
    UIView *viewLast = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.recommendedView.frame.size.width, self.recommendedView.frame.size.height)];
    UIImageView *imgViewLast = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewLast.frame.size.width, viewLast.frame.size.height)];
    imgViewLast.image = [arr firstObject];
    [viewLast addSubview:imgViewLast];
    [recommendedViewsArray  addObject:viewLast];
    
    for (int i = 0;i< [recommendedViewsArray count];i++) {
        UIView *view = (UIView *)[recommendedViewsArray objectAtIndex:i];
        view.frame = CGRectMake(i * self.recommendedView.frame.size.width, 0, self.recommendedView.frame.size.width, self.recommendedView.frame.size.height);
    }
    for (int i = 0;i< [recommendedViewsArray count];i++) {
        UIView *view = (UIView *)[recommendedViewsArray objectAtIndex:i];
        NSLog(@"%f",view.frame.origin.x);
    }
    
    self.recommendedScrollView.contentSize = CGSizeMake([recommendedViewsArray count] * self.recommendedScrollView.frame.size.width, self.recommendedScrollView.frame.size.height);
    for (UIView *view in recommendedViewsArray) {
        [self.recommendedScrollView addSubview:view];
    }
    [self.recommendedScrollView setContentOffset:CGPointMake(self.recommendedScrollView.frame.size.width, 0)];
}

- (void)loadTrendView
{
    trendKindArray = [[NSMutableArray alloc] initWithObjects:@" 资产",@" 组合",@" 管理人",@" 热门搜索",nil];
    self.trendScrollView.contentSize = CGSizeMake([trendKindArray count] * self.trendScrollView.frame.size.width, self.trendScrollView.frame.size.height);
    self.trendScrollView.pagingEnabled = YES;
    for (int i = 0; i<[trendKindArray count]; i++) {
        TrendView *trendView = [[TrendView alloc] init];
        trendView.data = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
        trendView.title = [trendKindArray objectAtIndex:i];
        trendView.trendIndex = i;
        trendView.trendDelegate = self;
        trendView.delegate = trendView;
        trendView.dataSource = trendView;
//        trendView.bounces = NO;
        trendView.frame = CGRectMake(i * self.trendScrollView.frame.size.width, 0, self.trendScrollView.frame.size.width, self.trendScrollView.frame.size.height);
        [self.trendScrollView addSubview:trendView];
    }
}

- (void)showCategory
{
    if (!isShowCategoryView) {
        CategoryViewController *categoryVC = [[CategoryViewController alloc] init];
        categoryVC.selectedIndex = categorySelectedIndex;
        categoryVC.tableViewRowHeight = 80.0f;
        self.leftSemiViewController = categoryVC;
        isShowCategoryView = YES;
    }
}

- (void)categoryViewDismiss
{
    isShowCategoryView = NO;
}

- (BOOL)prefersStatusBarHidden
{
    if (isLoadIntroStatus) {
        
    }else{
        BOOL isFirstEntrance = [StateServices isFirstEntrance];
        if (isFirstEntrance){
            isShowStatusBar = NO;
        }else{
            isShowStatusBar = YES;
        }
        isLoadIntroStatus = YES;
    }
    
    if (isShowStatusBar) {
        isShowStatusBar = !isShowStatusBar;
        return NO;
    }else{
        isShowStatusBar = !isShowStatusBar;
        return YES;
    }
    
}

- (void)removeIntro
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        [self prefersStatusBarHidden];
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)selectIndex:(NSNotification*)notify
{
    NSDictionary *data = notify.object;
    int index = [[data valueForKey:@"index"] intValue];
    categorySelectedIndex = index;
    switch (categorySelectedIndex) {
        case 0:
            [self.baseView bringSubviewToFront:self.homeView];
            break;
        case 1:
            [self.baseView bringSubviewToFront:myAccountView.view];
            break;
        case 2:
            [self.baseView bringSubviewToFront:myCombinationView.view];
            break;
        case 3:
            [self.baseView bringSubviewToFront:focusView.view];
            break;
        case 4:
            [self.baseView bringSubviewToFront:consultantView.view];
            break;
        case 5:
            [self.baseView bringSubviewToFront:myCycleView.view];
            break;
        default:
            [self.baseView bringSubviewToFront:self.homeView];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    introVC = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offset = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (offset == 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width*([recommendedViewsArray count]-2), 0) animated:NO];
    }else if(offset == [recommendedViewsArray count] - 1){
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
    }
}


//TrendDelegate

- (void)didSelectedTrendCellAt:(NSIndexPath*)indexPath forTrendNum:(int)trendIndex
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Selected" message:[NSString stringWithFormat:@"Selected No.%d trendView at indexPath %d",trendIndex,indexPath.row]delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
    [av show];
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
