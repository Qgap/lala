//
//  CPLoginViewController.m
//  lottery
//
//  Created by wayne on 2017/8/4.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPLoginViewController.h"
#import "GQRegistViewController.h"
#import "CPTryPlayViewController.h"
#import "GQLookForPasswordVC.h"
#import "WXApi.h"

@interface CPLoginViewController ()
{
    IBOutlet UITextField *_tfName;
    IBOutlet UITextField *_tfPassword;
    
    IBOutlet UIButton *_tryPlayButton;
}
@end

@implementation CPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:@"topbar_icon_back_n"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"topbar_icon_back_n"] forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    [btn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if ([DataCenter shareGlobalData].isReviewVersion) {
        _tryPlayButton.hidden = YES;
    }
    
    if (self.isPushToRegistViewController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            GQRegistViewController *registVC = [GQRegistViewController new];
            [self.navigationController pushViewController:registVC animated:NO];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)loadKefuWebView
{
    
   
    GQWebViewController *toWebVC = [[GQWebViewController alloc] cookBook_WebWithURLString:[[NSString alloc]initWithString:[DataCenter shareGlobalData].kefuUrlString]];
    
    toWebVC.title = @"客服";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}

-(void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- button Actions

- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:
        {
            //客服
            if ([DataCenter shareGlobalData].kefuUrlString) {
                [self loadKefuWebView];
            }else{
                [self queryKefuUrlString];
            }
        }break;
        case 102:
        {
            //忘记密码
            GQLookForPasswordVC *registVC = [GQLookForPasswordVC new];
            [self.navigationController pushViewController:registVC animated:YES];
            
        }break;
        case 103:
        {
            //登录
            if (_tfName.text.length == 0) {
                [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入账号" dismissAfterInterval:1.5 onView:self.view];
                return;
            }
            if (_tfPassword.text.length == 0) {
                [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入密码" dismissAfterInterval:1.5 onView:self.view];
                return;
            }
            [self.view endEditing:YES];
            [self queryLoginWithUserName:_tfName.text password:_tfPassword.text];
            
        }break;
        case 104:
        {
            //注册
            GQRegistViewController *registVC = [GQRegistViewController new];
            [self.navigationController pushViewController:registVC animated:YES];
            
        }break;
        case 105:
        {
            //试玩
            CPTryPlayViewController *tryPlayVC = [CPTryPlayViewController new];
            [self.navigationController pushViewController:tryPlayVC animated:YES];

        }break;
        case 108:
        {
            //试玩
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"GSTDoctorApp";
            [WXApi sendReq:req];
            
        }break;
            
        default:
            break;
    }
}


-(void)queryKefuUrlString
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];

    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPIKefu
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSString *urlString = [request.resultInfo DWStringForKey:@"data"];
                   [DataCenter shareGlobalData].kefuUrlString = urlString;
                   [self loadKefuWebView];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof GQRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
               [self.navigationController popViewControllerAnimated:YES];
               
           }];

}

-(void)queryLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    NSDictionary *paramsDic = @{@"userName":userName,@"password":password,@"deviceType":@"2"};
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPILoginSubmit
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSString *token = [request.resultInfo DWStringForKey:@"token"];
                   [[GQUser shareUser]cookBook_addToken:token];
                   [self dismissAction];
                   alertMsg = @"登录成功";
                   [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForLoginSucceed object:nil];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];

           } failure:^(__kindof GQRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

@end
