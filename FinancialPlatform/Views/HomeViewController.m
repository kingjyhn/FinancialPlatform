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

@interface HomeViewController ()
{
    IntroViewController *introVC;
    BOOL isShowStatusBar;
    BOOL isShowCategoryView;
    int categorySelectedIndex;
}
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
    isShowStatusBar = NO;
    isShowCategoryView = NO;
    categorySelectedIndex = 0;
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(removeIntro) name:@"RemoveIntro" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(categoryViewDismiss) name:@"CategoryViewDismiss" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(selectIndex:) name:@"SelectIndex" object:nil];
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
    [self setBarItem];


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
