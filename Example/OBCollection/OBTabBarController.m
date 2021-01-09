//
//  OBTabBarController.m
//  ForORTest
//
//  Created by orange on 2020/11/20.
//

#import "OBTabBarController.h"
#import "HomeController.h"
#import "TestController.h"

@interface OBTabBarController ()

@end

@implementation OBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeController * homeVC = [[HomeController alloc]init];
    homeVC.title = @"配置页";
    UINavigationController * homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    UITabBarItem *homeIt = [[UITabBarItem alloc] init];
    homeIt.title = @"配置页";
    homeIt.image = [UIImage imageNamed:@"首页-未选中"];
    homeIt.selectedImage = [UIImage imageNamed:@"首页-选中"];
    homeNav.tabBarItem = homeIt;
    
    TestController * testVC = [[TestController alloc]init];
    testVC.title = @"测试页";
    UINavigationController * testNav = [[UINavigationController alloc]initWithRootViewController:testVC];
    UITabBarItem *testIt = [[UITabBarItem alloc] init];
    testIt.title = @"测试页";
    testIt.image = [UIImage imageNamed:@"我的-未选中"];
    testIt.selectedImage = [UIImage imageNamed:@"我的-选中"];
    testNav.tabBarItem = testIt;
    
    NSArray *viewController = [[NSArray alloc]initWithObjects:homeNav, testNav, nil];
    self.viewControllers = viewController;
}

@end
