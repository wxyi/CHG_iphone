//
//  CHGNavigationController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/21.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "CHGNavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "SidebarMenuTableViewController.h"

#import "OrderQuryViewController.h"
@interface CHGNavigationController ()
@property (strong, readwrite, nonatomic) SidebarMenuTableViewController *SidebarMenuController;
@end

@implementation CHGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showMenu
{
    DLog(@"count = %d",[self.viewControllers count]);
    [self.frostedViewController presentMenuViewController];
}

-(void)skipPage
{
    DLog(@"搜索");
    OrderQuryViewController* OrderQueryView = [[OrderQuryViewController alloc] initWithNibName:@"OrderQuryViewController" bundle:nil];
    [self pushViewController:OrderQueryView animated:YES];
}
- (void)goback
{
    [self popToRootViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    DLog(@"count = %d",[self.viewControllers count]);
    if ([self.viewControllers count] == 1) {
        [self.frostedViewController panGestureRecognized:sender];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
