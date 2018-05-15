//
//  CPLotteryResultVC.m
//  lottery
//
//  Created by wayne on 2017/6/25.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPLotteryResultVC.h"

#import "GQLotteryResultMainCellStyle1.h"
#import "GQLotteryResultMainCellStyle2.h"
#import "GQLotteryResultMainCellStyle3.h"
#import "GQLotteryResultMainCellStyle4.h"
#import "GQLotteryResultMainCellStyle5.h"
#import "GQLotteryResultMainCellStyle6.h"
#import "GQLotteryResultMainCellStyle7.h"
#import "GQLotteryResultMainCellStyle8.h"

#import "GQLotteryResultDetailWebVC.h"


@interface CPLotteryResultVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    IBOutlet UITableView *_tableView;
    
    NSArray *_dataList;
    
    IBOutlet UIWebView *_webView;
    
}

@end

@implementation CPLotteryResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开奖大厅";
    _isLoadView = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryLotteryResultInfo];
    }];
    
    [_tableView registerClass:[GQLotteryResultMainCellStyle0 class] forCellReuseIdentifier:NSStringFromClass([GQLotteryResultMainCellStyle0 class])];
    
    [_tableView registerNib:[UINib nibWithNibName:@"GQLotteryResultMainCellStyle1" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GQLotteryResultMainCellStyle1 class])];
    [_tableView registerNib:[UINib nibWithNibName:@"GQLotteryResultMainCellStyle2" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GQLotteryResultMainCellStyle2 class])];

    [_tableView registerNib:[UINib nibWithNibName:@"GQLotteryResultMainCellStyle3" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GQLotteryResultMainCellStyle3 class])];

    [_tableView registerNib:[UINib nibWithNibName:@"GQLotteryResultMainCellStyle4" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GQLotteryResultMainCellStyle4 class])];

    [_tableView registerNib:[UINib nibWithNibName:@"GQLotteryResultMainCellStyle5" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GQLotteryResultMainCellStyle5 class])];

    [_tableView registerNib:[UINib nibWithNibName:@"GQLotteryResultMainCellStyle6" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GQLotteryResultMainCellStyle6 class])];

    [_tableView registerNib:[UINib nibWithNibName:@"GQLotteryResultMainCellStyle7" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GQLotteryResultMainCellStyle7 class])];

    [_tableView registerNib:[UINib  nibWithNibName:@"GQLotteryResultMainCellStyle8" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GQLotteryResultMainCellStyle8 class])];

    
    [_tableView.mj_header beginRefreshing];
    
    _tableView.hidden = YES;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadWebViewData];
    }];
    
    [_webView.scrollView.mj_header beginRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _isLoadView = YES;
}

-(void)goToResultDetailWithGid:(NSString *)gid
                       dayType:(int)dayType
            isShowPushAnimated:(BOOL)animated
{

    NSString *urlString = [[DataCenter shareGlobalData].domainUrlString wayStringByAppendingPathComponent: [NSString stringWithFormat:@"/api/draw/single?gid=%@",gid]];
    GQLotteryResultDetailWebVC *vc = [[GQLotteryResultDetailWebVC alloc]init];
    vc.urlString = urlString;
    vc.dayType = dayType;
    [self.navigationController pushViewController:vc animated:animated];
    
}

#pragma mark- web

-(void)reloadWebViewData
{
    NSString *urlString = [[DataCenter shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/api/draw1"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString rangeOfString:@"draw/single"].length>0) {
        
        GQLotteryResultDetailWebVC *vc = [[GQLotteryResultDetailWebVC alloc]init];
        vc.urlString = urlString;
        vc.dayType = 99;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    NSLog(@"%@",webView);
    return YES;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_webView.scrollView.mj_header.isRefreshing) {
        [_webView.scrollView.mj_header endRefreshing];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (_webView.scrollView.mj_header.isRefreshing) {
        [_webView.scrollView.mj_header endRefreshing];
    }
}


#pragma mark- network

-(void)queryLotteryResultInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPIDraw
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
               
               if (request.resultIsOk) {
                   
                   _dataList = [DWParsers getObjectListByName:@"GQLotteryModel" fromArray:request.businessDataArray];
                   [_tableView reloadData];
                   
               }else{
                   
                   [WSProgressHUD showErrorWithStatus:request.requestDescription];
               }
               
           } failure:^(__kindof GQRequest *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
           }];

}

#pragma mark- tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GQLotteryModel *model = [_dataList objectAtIndex:indexPath.row];
    
    NSString *reusedString = NSStringFromClass([GQLotteryResultMainCellStyle1 class]);
    reusedString = [NSString stringWithFormat:@"GQLotteryResultMainCellStyle%d",model.mainResultCellStyle];
    
    GQLotteryResultMainCellStyle0 *cell = [tableView dequeueReusableCellWithIdentifier:reusedString];
    
    [cell addTitle:model.name content:model.noteDes result:model.resultArray];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [DataCenter cookBook_playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*
    CPLotteryModel *model = [_dataList objectAtIndex:indexPath.row];
    CPLotteryResultDetailWebVC *vc = [[CPLotteryResultDetailWebVC alloc]init];
    vc.dayType = 0;
    vc.gid = [model.num integerValue];
    vc.title = model.name;
    vc.showPageTitles = NO;
    vc.showActionButton = NO;
    vc.navigationButtonsHidden = YES;
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    */
}

@end
