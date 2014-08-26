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

@interface HomeViewController ()<UIScrollViewDelegate>
{
    IntroViewController *introVC;
    BOOL isShowStatusBar;
    BOOL isShowCategoryView;
    int categorySelectedIndex;
    NSMutableArray *recommendedViewsArray;
}

@property (weak, nonatomic) IBOutlet UIView *recommendedView;
@property (weak, nonatomic) IBOutlet UIScrollView *recommendedScrollView;


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
    [self initStatus];
    [self loadIntroView];
    [self setBarItem];
    [self loadRecommendedView];

}

- (void)initStatus
{
    isShowStatusBar = NO;
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
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
        [self setNeedsStatusBarAppearanceUpdate];
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
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)selectIndex:(NSNotification*)notify
{
    NSDictionary *data = notify.object;
    int index = [[data valueForKey:@"index"] intValue];
    categorySelectedIndex = index;
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
