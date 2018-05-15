//
//  CPLookForPasswordVC.m
//  lottery
//
//  Created by wayne on 2017/8/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "GQLookForPasswordVC.h"
#import "CPModifyQAMessageVC.h"

@interface CPModifyQAMessageVC ()
{
    IBOutlet UITextField *_tfUserName;
    IBOutlet UITextField *_tfQuestion;
    IBOutlet UITextField *_tfAnswer;
}
@end

@implementation CPModifyQAMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密保";
    _tfUserName.text = self.question;
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
    

    if (_tfQuestion.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入旧答案" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    if (_tfAnswer.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请再次输新答案" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    
    
    if ([_tfAnswer.text isEqualToString:_tfQuestion.text]) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"旧答案和新答案不能一样" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    
    [self.view endEditing:YES];
    [self queryVerify];
}


-(void)queryVerify
{
    
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"question":_tfUserName.text,@"answer":_tfQuestion.text,@"nAnswer":_tfAnswer.text,@"token":[GQUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPISettingQaSubmit
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   alertMsg = @"修改密保成功";
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
