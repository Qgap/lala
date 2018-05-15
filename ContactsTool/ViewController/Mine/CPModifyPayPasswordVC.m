//
//  CPLookForPasswordVC.m
//  lottery
//
//  Created by wayne on 2017/8/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "GQLookForPasswordVC.h"
#import "CPModifyPayPasswordVC.h"

@interface CPModifyPayPasswordVC ()
{
    IBOutlet UITextField *_tfUserName;
    IBOutlet UITextField *_tfQuestion;
}
@end

@implementation CPModifyPayPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改提款密码";
    if (!_isSeted) {
        _tfUserName.text = @"1111";
        _tfUserName.userInteractionEnabled = NO;
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

#pragma mark-

- (IBAction)submitAction:(UIButton *)sender {
    
    if (_tfUserName.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入旧提款密码" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    if (_tfQuestion.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入新提款密码" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    
    if ([_tfUserName.text isEqualToString:_tfQuestion.text]) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"旧提款密码和新提款密码不能一样" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    
    
    [self.view endEditing:YES];
    [self queryVerify];
}


-(void)queryVerify
{
    
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"oPasswd":_tfUserName.text,@"passwd":_tfQuestion.text,@"token":[GQUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPISettingWithdrawPasswd
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   alertMsg = _isSeted?@"修改提款密码成功":@"设置提款密码成功";
                   [self.navigationController popViewControllerAnimated:YES];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof GQRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
    
}


@end
