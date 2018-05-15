//
//  CPBuyLotteryRoomVC.m
//  lottery
//
//  Created by wayne on 2017/9/20.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "GQBuyLotteryRoomVC.h"
#import "BuyLyDetailVC.h"

@interface GQBuyLotteryRoomVC ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    
    GQRequest *_buyLtyRequest;

}

@end

@implementation GQBuyLotteryRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.lotteryName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_buyLtyRequest) {
        [_buyLtyRequest stop];
        _buyLtyRequest = nil;
    }
}

#pragma mark- tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *markReused = @"markReused";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReused];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:markReused];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *info = _roomList[indexPath.row];
    NSString *imageUrlString = [[DataCenter shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[info DWStringForKey:@"image"]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil options:SDWebImageRetryFailed];
    cell.textLabel.text = [info DWStringForKey:@"name"];
    cell.detailTextLabel.text = [info DWStringForKey:@"remark"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [DataCenter cookBook_playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = _roomList[indexPath.row];
    [self queryBuyLotteryInfoWithRoomId:[info DWStringForKey:@"id"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _roomList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark- network

-(void)queryBuyLotteryInfoWithRoomId:(NSString *)roomId
{
    
    @synchronized (self) {
        if (_buyLtyRequest) {
            [_buyLtyRequest stop];
            _buyLtyRequest = nil;
        }
        NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[GQUser shareUser].token}];
        [paramsDic setObject:@"2" forKey:@"deviceType"];
        [paramsDic setObject:roomId forKey:@"roomId"];
        [paramsDic setObject:_gid forKey:@"gid"];
        
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
                           vc.lotteryName = _lotteryName;
                           vc.hidesBottomBarWhenPushed = YES;
                           [self.navigationController pushViewController:vc animated:YES];
                           
                       }else{
                           
                       }
                       [SVProgressHUD way_dismissThenShowInfoWithStatus:nil];
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
