//
//  CPBetRecordVC.m
//  lottery
//
//  Created by wayne on 2017/8/30.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBetRecordVC.h"
#import "CPBetRecordCell.h"
#import "SelectedOptionsAgoView.h"

@interface CPBetRecordVC ()
{
    
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_titleView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIButton *_titleButton;
    IBOutlet UIImageView *_titleArrowImageView;
    
    NSMutableArray *_dataList;
    NSArray *_typeList;
    int _page;
    int _totalPage;
}

@property(nonatomic,assign)NSInteger selectedType;

@end

@implementation CPBetRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = _titleView;
    
    _typeList = @[@"全部订单",@"我的中奖",@"待开奖",@"我的撤单"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CPBetRecordCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPBetRecordCell class])];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self queryDataForReferesh];
    }];
    
    _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self queryDataMore];
    }];
    
    if (self.onlyShowWinRecord) {
        
        self.selectedType = 1;
        _titleButton.hidden = YES;
        _titleArrowImageView.hidden = YES;
        
    }else{
        _titleButton.layer.cornerRadius = 3.0f;
        _titleButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _titleButton.layer.borderWidth = kGlobalLineWidth;
        _titleButton.layer.masksToBounds = YES;
        self.selectedType = 0;

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setSelectedType:(NSInteger)selectedType
{
    _selectedType = selectedType;
    _titleLabel.text = _typeList[_selectedType];
    
    _dataList = [NSMutableArray new];
    [_tableView reloadData];
    [_tableView endUpdates];
    [_tableView.mj_header beginRefreshing];
}

#pragma mark-
- (IBAction)titleButtonAction:(id)sender {
    
    [SelectedOptionsAgoView showWithOnView:self.navigationController.view title:@"选择投注类型" options:_typeList selectedIndex:self.selectedType selected:^(NSInteger index) {
        
        if (index != self.selectedType) {
            self.selectedType = index;
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPBetRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPBetRecordCell class])];
    NSDictionary *info = _dataList[indexPath.row];
    [cell addBetRecordInfo:info];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [DataCenter cookBook_playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = _dataList[indexPath.row];
    [self queryDetailInfoWithId:[info DWStringForKey:@"id"]];
    
//    CPPersonalMessageDetailVC *vc = [CPPersonalMessageDetailVC new];
//    vc.msgTitle = [info DWStringForKey:@"title"];
//    vc.msgId = [info DWStringForKey:@"id"];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- network

-(void)queryDetailInfoWithId:(NSString *)infoId
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
    [paramsDic setObject:infoId forKey:@"id"];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPIUserBetDetail
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               NSString *htmlString = request.responseString;
               GQWebViewController *toWebVC = [[GQWebViewController alloc]cookBook_WebWithURLString:nil];
               toWebVC.title = @"详情";
               toWebVC.showPageTitles = NO;
               toWebVC.showActionButton = NO;
               toWebVC.navigationButtonsHidden = YES;
               toWebVC.hidesBottomBarWhenPushed = YES;
               [self.navigationController pushViewController:toWebVC animated:YES];
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [toWebVC.webView loadHTMLString:htmlString baseURL:nil];
               });
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:nil];
               
               
           } failure:^(__kindof GQRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
               [self.navigationController popViewControllerAnimated:YES];
               
           }];
    
}


-(void)queryDataForReferesh
{
    _page = 1;
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    [paramsDic setObject:[NSString stringWithFormat:@"%ld",(long)_selectedType] forKey:@"type"];

    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPIUserBetList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               [_tableView.mj_header endRefreshing];
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   NSArray *items = [dataInfo DWArrayForKey:@"items"];
                   
                   /*
                   items = @[
                             @{@"title":@"消息1",@"status":@"0",@"id":@"1",@"addTime":@"2017-07-22 10:15:21"},
                             @{@"title":@"消息2",@"status":@"1",@"id":@"2",@"addTime":@"2017-07-22 10:15:21"}
                             
                             ];
                    */
                   if (items.count>0) {
                       _dataList = [[NSMutableArray alloc]initWithArray:items];
                       [_tableView reloadData];
                       _totalPage = [[dataInfo DWStringForKey:@"totalPage"]intValue];
                       if (_totalPage>_page) {
                           _page++;
                       }
                   }else{
                       alertMsg = @"暂无相关记录";
                   }
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               if (alertMsg.length >0) {
                   [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:alertMsg];
               }
               
           } failure:^(__kindof GQRequest *request) {
               
               [_tableView.mj_header endRefreshing];
               [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"网络异常"];
           }];
    
    
}

-(void)queryDataMore
{
    if (_page>=_totalPage) {
        
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD way_dismissThenShowInfoWithStatus:@"无更多相关记录"];
        return;
        
    }
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    [paramsDic setObject:[NSString stringWithFormat:@"%ld",(long)_selectedType] forKey:@"type"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPIUserBetList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   NSArray *items = [dataInfo DWArrayForKey:@"items"];
                   
                   _totalPage = [[dataInfo DWStringForKey:@"totalPage"]intValue];
                   if (_totalPage>_page) {
                       _page++;
                   }
                   
                   if (items.count>0) {
                       
                       [_dataList addObjectsFromArray:items];
                       [_tableView reloadData];
                       [_tableView.mj_footer endRefreshing];
                       
                   }else{
                       alertMsg = @"无更多相关记录";
                       [_tableView.mj_footer endRefreshingWithNoMoreData];
                   }
                   
               }else{
                   [_tableView.mj_footer endRefreshing];
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof GQRequest *request) {
               
               [_tableView.mj_footer endRefreshing];
               [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"网络异常"];
           }];
}


@end
