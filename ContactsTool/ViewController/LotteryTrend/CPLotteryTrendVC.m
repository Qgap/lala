//
//  CPLotteryTrendVC.m
//  lottery
//
//  Created by wayne on 17/1/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPLotteryTrendVC.h"
#import "SelectedOptionsAgoView.h"
#import "BuyLyDetailVC.h"
#import "GQBuyLotteryRoomVC.h"

@interface CPLotteryTrendVC ()<UIWebViewDelegate>
{
    IBOutlet UIWebView *_webView;
    NSArray *_typeList;
    
    IBOutlet UIView *_navigationView;
    IBOutlet UIButton *_titleButton;
    NSMutableArray *_typeNameList;
    IBOutlet UILabel *_bottomNameLabel;
    
    IBOutlet UIButton *_betButton;

    IBOutlet UIView *_trendGuideView;
    
}

@property(nonatomic,assign)NSInteger selectedTypeIndex;

@end

@implementation CPLotteryTrendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"走势";
    self.navigationItem.titleView = _navigationView;
    _titleButton.layer.cornerRadius = 3.0f;
    _titleButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _titleButton.layer.borderWidth = kGlobalLineWidth;
    _titleButton.layer.masksToBounds = YES;
    
    _betButton.layer.cornerRadius = 3.0f;
    _betButton.layer.masksToBounds = YES;
    
    
    _trendGuideView.hidden = YES;
    
//    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
    _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_typeList.count>0) {
            [_webView reload];
        }else{
            [self queryTrendInfo];
        }
    }];

    [_webView.scrollView.mj_header beginRefreshing];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.showInfoByGid.length>0 && _typeList.count>0) {
        NSInteger selectedIndex = 0;
        for (int i=0;i<_typeList.count; i++) {
            NSDictionary *info = _typeList[i];
            if ([self.showInfoByGid isEqualToString:[info DWStringForKey:@"num"]]) {
                selectedIndex = i;
            }
        }
        self.showInfoByGid = @"";
        self.selectedTypeIndex = selectedIndex;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadRightItem
{
    UIImage *rightItemImage = [UIImage imageNamed:@"zoushi_you_anniu_03"];
    VoiceButton *btn = [VoiceButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, rightItemImage.size.width, rightItemImage.size.height);
    [btn addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:rightItemImage forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

-(void)rightItemAction
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [SelectedOptionsAgoView showWithOnView:app.window title:@"选择彩票类型" options:_typeNameList selectedIndex:self.selectedTypeIndex selected:^(NSInteger index) {
        
        if (index != self.selectedTypeIndex) {
            self.selectedTypeIndex = index;
        }
    }];
}

-(void)setSelectedTypeIndex:(NSInteger)selectedTypeIndex
{
    _selectedTypeIndex = selectedTypeIndex;
    NSDictionary *info = _typeList[_selectedTypeIndex];
    _bottomNameLabel.text = [info DWStringForKey:@"name"];
    [self loadWebViewWithGid:[info DWStringForKey:@"num"]];
    
}

-(void)loadWebViewWithGid:(NSString *)gid
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[[DataCenter shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/api/trend?gid="],gid];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

#pragma mark- webView Delegate

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

#pragma mark- button action
- (IBAction)goToBetAction:(UIButton *)sender {
    
    NSDictionary *info = _typeList[_selectedTypeIndex];
    [self queryBuyLotteryInfoWithGid:[info DWStringForKey:@"num"] lotteryName:[info DWStringForKey:@"name"]];
}

- (IBAction)titleButtonAction
{
    _trendGuideView.hidden = _trendGuideView.hidden?NO:YES;
}

#pragma mark- network


-(void)queryBuyLotteryInfoWithGid:(NSString *)gid
                      lotteryName:(NSString *)lotteryName
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:gid forKey:@"gid"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPIBuy
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               if (request.resultIsOk) {
                   NSLog(@"%@",request.businessData);
                   NSString *page = [request.businessData DWStringForKey:@"page"];
                   if ([page isEqualToString:@"buy"]) {
                       //购买
                       BuyLyDetailVC *vc = [BuyLyDetailVC new];
                       vc.playInfo = request.businessData;
                       vc.lotteryName = lotteryName;
                       vc.hidesBottomBarWhenPushed = YES;
                       [self.navigationController pushViewController:vc animated:YES];
                   }else{
                       
                       GQBuyLotteryRoomVC *vc = [GQBuyLotteryRoomVC new];
                       vc.lotteryName = lotteryName;
                       vc.roomList = [request.businessData DWArrayForKey:@"roomList"];
                       vc.gid = gid;
                       vc.hidesBottomBarWhenPushed = YES;
                       [self.navigationController pushViewController:vc animated:YES];
                   }
                   [SVProgressHUD way_dismissThenShowInfoWithStatus:nil];
               }else{
                   
                   [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
                   
               }
               
           } failure:^(__kindof GQRequest *request) {
               [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
               
           }];
    
}

-(void)queryTrendInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"type":@"0"}];
    
    [paramsDic setObject:[GQUser shareUser].token forKey:@"token"];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPITrendTypeList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               if (_webView.scrollView.mj_header.isRefreshing) {
                   [_webView.scrollView.mj_header endRefreshing];
               }
               if (request.resultIsOk) {
                   _typeList = [request.resultInfo DWArrayForKey:@"data"];
                   if (_typeList.count>0) {
                       
                       NSInteger selectedIndex = 0;
                       _typeNameList = [NSMutableArray new];
                       for (int i=0;i<_typeList.count; i++) {
                           NSDictionary *info = _typeList[i];
                           [_typeNameList addObject:[info DWStringForKey:@"name"]];
                           if ([self.showInfoByGid isEqualToString:[info DWStringForKey:@"num"]]) {
                               self.showInfoByGid = @"";
                               selectedIndex = i;
                           }
                       }
                       [self loadRightItem];
                       self.selectedTypeIndex = selectedIndex;
                       
                   }else{
                       [SVProgressHUD way_showInfoCanTouchWithStatus:@"网络异常" dismissAfterInterval:1.5f onView:self.view];
                   }
                   
               }else{
                   [SVProgressHUD way_showInfoCanTouchWithStatus:request.requestDescription dismissAfterInterval:1.5f onView:self.view];

               }
               
               
           } failure:^(__kindof GQRequest *request) {
               
               if (_webView.scrollView.mj_header.isRefreshing) {
                   [_webView.scrollView.mj_header endRefreshing];
               }
               [SVProgressHUD way_showInfoCanTouchWithStatus:@"网络异常" dismissAfterInterval:1.5f onView:self.view];
           }];

}

@end
