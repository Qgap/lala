//
//  CPBusinessControllerManager.m
//  lottery
//
//  Created by wayne on 2017/9/6.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "GQBusinessControllerManager.h"
#import "CPBankCardInfoVC.h"
#import "CPWithdrawViewController.h"

static GQBusinessControllerManager *shareManager;

@interface GQBusinessControllerManager ()
@property(nonatomic,weak)UIViewController *currentBusinessViewController;
@property(nonatomic,weak)UINavigationController *currentBusinessNavigationController;

@end

@implementation GQBusinessControllerManager

+(GQBusinessControllerManager *)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareManager = [GQBusinessControllerManager new];
    });
    
    return shareManager;
}

-(UINavigationController *)currentBusinessNavigationController
{
    return [self.currentBusinessViewController isKindOfClass:[UINavigationController class]]?(UINavigationController *)self.currentBusinessViewController:self.currentBusinessViewController.navigationController;
}


#pragma mark- public

+(void)cookBook_pushToWithdrawControllerOnViewController:(UIViewController *)onViewController
{
    [GQBusinessControllerManager shareManager].currentBusinessViewController = onViewController;
    [GQBusinessControllerManager queryWithdrawInfo];
}

#pragma mark- private

+(void)goToBankCardViewControllerWithBankInfo:(NSDictionary *)bankInfo
                     fromNavigationController:(UINavigationController *)navigationController
{
    CPBankCardInfoVC *vc = [CPBankCardInfoVC new];
    vc.bankInfo = bankInfo;
    vc.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:vc animated:YES];
}

+(void)goToWithdrawViewControllerWithInfo:(NSDictionary *)withdrawInfo
                 fromNavigationController:(UINavigationController *)navigationController
{
    CPWithdrawViewController *vc = [CPWithdrawViewController new];
    vc.withdrawInfo = withdrawInfo;
    vc.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:vc animated:YES];
}

#pragma mark- network

+(void)queryWithdrawInfo
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPIUserWithdraw
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *info = request.businessData;
                   int status = [[info DWStringForKey:@"status"]intValue];
                   if (status == -1) {
                       
                       [UIAlertView showWithTitle:@"提醒" message:@"请先绑定提款银行卡信息" cancelButtonTitle:@"取消" otherButtonTitles:@[@"好的"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                           NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
                           if ([title isEqualToString:@"好的"]) {
                               [GQBusinessControllerManager queryGetBank];
                           }
                       }];
                       
                   }else{
                       
                       [GQBusinessControllerManager goToWithdrawViewControllerWithInfo:info fromNavigationController:[GQBusinessControllerManager shareManager].currentBusinessNavigationController];
                   }
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof GQRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];

}

+(void)queryGetBank
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPISettingGetBank
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *bankInfoMessage = [request.resultInfo DWDictionaryForKey:@"data"];
                   [GQBusinessControllerManager goToBankCardViewControllerWithBankInfo:bankInfoMessage fromNavigationController:[GQBusinessControllerManager shareManager].currentBusinessNavigationController];
                   /*
                    {
                    "bankName":"浦发银行",银行名称
                    "accountCode":"354***211",--银行账号
                    "accountName":"123",--开户人姓名
                    "provice":"12",--省份
                    "city":"12",--城市
                    "expand":{
                    "isWithdrawPasswdSet":1--是否已经设置提款密码 1已设置 0未设置
                    }
                    }
                    
                    */
                   
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof GQRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
    
}

@end
