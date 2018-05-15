//
//  CPBuyLotteryVC.m
//  lottery
//
//  Created by wayne on 17/1/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "BuyLyVC.h"
#import "VoiceButton.h"
#import "GQBuyLotteryTableCell.h"
#import "GQBuyLotteryCollectionCell.h"
#import "BuyLyDetailVC.h"
#import "GQBuyLotteryRoomVC.h"

@interface BuyLyVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    IBOutlet UIScrollView *_mainScrollView;
    IBOutlet UIView *_headerView;
    
    IBOutlet UIView *_allLotteryItem;
    IBOutlet UIView *_highLotteryItem;
    IBOutlet UIView *_lowLotteryItem;
    
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UITableView *_tableView;
    
    NSArray *_lotteryInfos;
    
    NSArray *_allLotteryInfos;
    NSArray *_highLotteryInfos;
    NSArray *_lowLotteryInfos;
    
    IBOutlet VoiceButton *_allLotteryButton;
    IBOutlet VoiceButton *_highLotteryButton;
    IBOutlet VoiceButton *_lowLotteryButton;
    
    VoiceButton *_switchDataViewButton;

    
    NSTimer *_openDateTimer;
    
    BOOL _isQueryInfoIng;

    GQRequest *_buyLtyRequest;
}

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)UICollectionView *collectionView;

@property(nonatomic,retain)NSArray *currentLotterys;


@end

@implementation BuyLyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryBuyLotteryInfo) name:kNotificationNameForBuyLotteryReloadList object:nil];

    
    [_allLotteryButton setBackgroundImage:[UIImage imageNamed:@"goucai_navs_02"] forState:UIControlStateSelected];
    [_highLotteryButton setBackgroundImage:[UIImage imageNamed:@"goucai_navs_03"] forState:UIControlStateSelected];
    [_lowLotteryButton setBackgroundImage:[UIImage imageNamed:@"goucai_navs_04"] forState:UIControlStateSelected];

    
    [_tableView registerNib:[UINib nibWithNibName:@"GQBuyLotteryTableCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GQBuyLotteryTableCell class])];
    [_collectionView registerNib:[UINib nibWithNibName:@"GQBuyLotteryCollectionCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([GQBuyLotteryCollectionCell class])];
    self.lotteryKind = CPBuyLotteryKindAll;
    self.showKind = CPBuyLotteryShowKindTable;
    
    _mainScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryBuyLotteryInfo];
    }];
    
    [_mainScrollView.mj_header beginRefreshing];
    
    _switchDataViewButton = [VoiceButton buttonWithType:UIButtonTypeCustom];
    _switchDataViewButton.frame = CGRectMake(0, 0, 65, 30);
    [_switchDataViewButton setBackgroundImage:[UIImage imageNamed:@"goucai_qiehua_03"] forState:UIControlStateNormal];
    [_switchDataViewButton setBackgroundImage:[UIImage imageNamed:@"goucai_qiehua_07"] forState:UIControlStateSelected];
    [_switchDataViewButton addTarget:self action:@selector(switchShowDataView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_switchDataViewButton];
    
    [[ShiJianManager shareTimeManager] cookBook_reloadBeiJingTime];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_openDateTimer) {
        _openDateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadOpenDate) userInfo:nil repeats:YES];
    }
    if (!_tableView.mj_header.isRefreshing) {
        [self queryBuyLotteryInfo];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_openDateTimer.isValid) {
        [_openDateTimer invalidate];
        _openDateTimer = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_buyLtyRequest) {
        [_buyLtyRequest stop];
        _buyLtyRequest = nil;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_openDateTimer invalidate];
    _openDateTimer = nil;

}

-(void)reloadOpenDate
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForBuyLotteryCountTime object:nil];
    
}

#pragma mark- network

-(void)queryBuyLotteryInfo
{
 
    @synchronized (self) {
        if (_isQueryInfoIng) {
            return;
        }else{
            _isQueryInfoIng = YES;
        }
    }
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [GQRequest cookBook_startWithDomainString:[DataCenter shareGlobalData].domainUrlString
                              apiName:GQSerVerAPINameForAPIHall
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof GQRequest *request) {
               
               _isQueryInfoIng = NO;
               
               if (_mainScrollView.mj_header.isRefreshing) {
                   [_mainScrollView.mj_header endRefreshing];
               }
               
               if (request.resultIsOk) {
                   
                   _allLotteryInfos = [DWParsers getObjectListByName:@"GQLotteryModel" fromArray: [request.businessData DWArrayForKey:@"all"]];
                   _highLotteryInfos = [DWParsers getObjectListByName:@"GQLotteryModel" fromArray: [request.businessData DWArrayForKey:@"gpc"]];
                   _lowLotteryInfos = [DWParsers getObjectListByName:@"GQLotteryModel" fromArray: [request.businessData DWArrayForKey:@"dpc"]];;
                   
                   [self reloadDataView];
                   
               }else{
                   
                   [WSProgressHUD showErrorWithStatus:request.requestDescription];
               }
               
           } failure:^(__kindof GQRequest *request) {
               
               _isQueryInfoIng = NO;

               if (_mainScrollView.mj_header.isRefreshing) {
                   [_mainScrollView.mj_header endRefreshing];
               }
           }];
}

#pragma mark- extension

-(void)reloadDataView
{
    if (self.showKind == CPBuyLotteryShowKindTable) {
        [_tableView reloadData];
    }else{
        [_collectionView reloadData];
    }
}


#pragma mark- action

-(void)switchShowDataView
{
    self.showKind = _showKind == CPBuyLotteryShowKindTable?CPBuyLotteryShowKindCollection:CPBuyLotteryShowKindTable;
}

- (IBAction)headerViewItemAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
        {
            //全部
            self.lotteryKind = CPBuyLotteryKindAll;
            
        }break;
        case 11:
        {
            //高频
            self.lotteryKind = CPBuyLotteryKindHighFrequency;
            
        }break;
        case 12:
        {
            //低频
            self.lotteryKind = CPBuyLotteryKindLowFrequency;
            
        }break;
            
        default:
            break;
    }
    
    [self reloadDataView];
    
}


#pragma mark- getter

-(NSArray *)currentLotterys
{
    switch (self.lotteryKind) {
        case CPBuyLotteryKindAll:
        {
            return _allLotteryInfos;
        }break;
        case CPBuyLotteryKindHighFrequency:
        {
            return _highLotteryInfos;
        }break;
        case CPBuyLotteryKindLowFrequency:
        {
            return _lowLotteryInfos;
        }break;
        default:
            break;
    }
    return [NSArray new];
}

#pragma mark- setter

-(void)setShowKind:(CPBuyLotteryShowKind)showKind
{
    _showKind = showKind;
    if (_showKind == CPBuyLotteryShowKindTable) {
        
        _tableView.hidden = NO;
        _collectionView.hidden = YES;
        _switchDataViewButton.selected = NO;
        
    }else{
        
        _tableView.hidden = YES;
        _collectionView.hidden = NO;
        _switchDataViewButton.selected = YES;

    }
    
    [self reloadDataView];
}


-(void)setLotteryKind:(CPBuyLotteryKind)lotteryKind
{
    _lotteryKind = lotteryKind;
    switch (_lotteryKind) {
        case CPBuyLotteryKindAll:
        {
            _allLotteryItem.backgroundColor = kCOLOR_R_G_B_A(202, 31, 37, 1);
            _highLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);
            _lowLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);

            _allLotteryButton.selected = YES;
            _highLotteryButton.selected = NO;
            _lowLotteryButton.selected = NO;
            
        }break;
        case CPBuyLotteryKindHighFrequency:
        {
            _highLotteryItem.backgroundColor = kCOLOR_R_G_B_A(202, 31, 37, 1);
            _allLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);
            _lowLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);
            
            _allLotteryButton.selected = NO;
            _highLotteryButton.selected = YES;
            _lowLotteryButton.selected = NO;
        }break;
        case CPBuyLotteryKindLowFrequency:
        {
            _lowLotteryItem.backgroundColor = kCOLOR_R_G_B_A(202, 31, 37, 1);
            _highLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);
            _allLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);
            
            _allLotteryButton.selected = NO;
            _highLotteryButton.selected = NO;
            _lowLotteryButton.selected = YES;
        }break;
            
        default:
            break;
    }
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
    
    GQLotteryModel *model = self.currentLotterys[indexPath.row];
    return [GQBuyLotteryTableCell cellHeightByLotteryModel:model cellWidth:kScreenSize.width];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentLotterys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GQBuyLotteryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GQBuyLotteryTableCell class])];
    GQLotteryModel *model = self.currentLotterys[indexPath.row];
    cell.lotteryModel = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [DataCenter cookBook_playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GQLotteryModel *model = self.currentLotterys[indexPath.row];
    if ([model.status intValue] == -1) {
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"该彩种维护中，请选择其他彩种下注！"];
        return;
    }
    [self queryBuyLotteryInfoWithGid:model.num lotteryName:model.name];
}

#pragma mark- collectionView Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.currentLotterys.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GQBuyLotteryCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GQBuyLotteryCollectionCell class]) forIndexPath:indexPath];
    GQLotteryModel *model = self.currentLotterys[indexPath.row];
    cell.lotteryModel = model;
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = CGSizeMake((_collectionView.width)/3.0f, (_collectionView.width)/3.0f);
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [DataCenter cookBook_playButtonClickVoice];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GQLotteryModel *model = self.currentLotterys[indexPath.row];
    if ([model.status intValue] == -1) {
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"该彩种维护中，请选择其他彩种下注！"];
        return;
    }
    [self queryBuyLotteryInfoWithGid:model.num lotteryName:model.name];
}

#pragma mark- network

-(void)queryBuyLotteryInfoWithGid:(NSString *)gid
                      lotteryName:(NSString *)lotteryName
{

    @synchronized (self) {
        if (_buyLtyRequest) {
            [_buyLtyRequest stop];
            _buyLtyRequest = nil;
        }
        NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
        [paramsDic setObject:@"2" forKey:@"deviceType"];
        [paramsDic setObject:gid forKey:@"gid"];

        NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
        
        _buyLtyRequest = [GQRequest cookBook_startRequestWithDomainString:[DataCenter shareGlobalData].domainUrlString
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

                   }else{
                       
                       [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];

                   }
                   _buyLtyRequest = nil;

               } failure:^(__kindof GQRequest *request) {
                   [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
                   _buyLtyRequest = nil;

               }];
    }

}

@end
