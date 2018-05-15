//
//  MainViewController.m
//  Contact
//
//  Created by gap on 2018/5/8.
//  Copyright © 2018年 gq. All rights reserved.
//

#import "GQMainViewController.h"
#import "GQContactViewController.h"
#import "GQManagerViewController.h"
#import <LocalAuthentication/LAContext.h>

@interface GQMainViewController ()

@property (nonatomic, assign)BOOL lock;
@property (nonatomic, strong)UIView *lockView;

@end

@implementation GQMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *contactVC = [[UINavigationController alloc] initWithRootViewController:[[GQContactViewController alloc] init]];
    contactVC.tabBarItem.title = NSLocalizedString(@"contacts", nil);
    contactVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"contact_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contactVC.tabBarItem.image = [[UIImage imageNamed:@"contact_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
    
    UINavigationController *manageVC = [[UINavigationController alloc] initWithRootViewController:[[GQManagerViewController alloc] init]];
    manageVC.tabBarItem.title = NSLocalizedString(@"clean", nil);
    manageVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"manage_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    manageVC.tabBarItem.image = [[UIImage imageNamed:@"manage_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers = @[contactVC,manageVC];
    
//    self.lockView = [[UIView alloc] initWithFrame:self.view.frame];
//    self.lockView.backgroundColor = [UIColor whiteColor];
//    self.lockView.hidden = YES;
//    [self.view addSubview:self.lockView];
//    
//    [self checkLock];

    
}

- (void)checkLock {
    self.lock = [[NSUserDefaults standardUserDefaults] boolForKey:kPrivateContact];
    
    if (self.lock) {
        self.lockView.hidden = NO;
    
        LAContext *context = [[LAContext alloc] init];
        NSError *error;
        
        [self.tabBarController presentViewController:[[GQManagerViewController alloc] init] animated:YES completion:^{
            
        }];
        
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Touch Id Test" reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    NSLog(@"success to evaluate");
                    dispatch_main_sync_safe(^{
                        self.lockView.hidden = YES;
                    });
                    
                }
                if (error) {
                    NSLog(@"---failed to evaluate---error: %@---", error.description);
                }
            }];
        } else {
            NSLog(@"Not support :%@",error.description);
        }
    } else {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
