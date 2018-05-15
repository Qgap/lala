//
//  GQSerVerAPIManager.m
//  lottery
//
//  Created by wayne on 2017/8/9.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "GQServerAPIManager.h"

NSString * const GQSerVerAPINameForAPIMain              = @"https://api.9595055.com/ios2";
//NSString * const GQSerVerAPINameForAPIMain              = @"https://cp89.c-p-a-p-p.net/ios2";
//NSString * const GQSerVerAPINameForAPIMain              = @"https://api.00CP55.COM/ios2";
//NSString * const GQSerVerAPINameForAPIMain              = @"https://api.9595055.com/ios2";
//NSString * const GQSerVerAPINameForAPIMain              = @"http://192.168.1.23:8080/lottery_admin/ios2";


NSString * const GQSerVerAPINameForAPIHall              = @"/api/hall";
NSString * const GQSerVerAPINameForAPIIndex             = @"/api/index";
NSString * const GQSerVerAPINameForAPILoginSubmit       = @"/api/login/submit";

NSString * const GQSerVerAPINameForAPINoticeNoTip       = @"/api/notice/noTip";


NSString * const GQSerVerAPINameForAPIDraw              = @"/api/draw";
NSString * const GQSerVerAPINameForAPIRegistPreInfo     = @"/api/reg/pre";
NSString * const GQSerVerAPINameForAPIKefu              = @"/api/kefu";
NSString * const GQSerVerAPINameForAPIRegLaw            = @"/api/reg/law";
NSString * const GQSerVerAPINameForAPIRegist            = @"/api/reg/submit";
NSString * const GQSerVerAPINameForAPIFreeUserCode      = @"/api/free/userCode";
NSString * const GQSerVerAPINameForAPIFreeUserSubmit    = @"/api/free/submit";
NSString * const GQSerVerAPINameForAPIPasswordVerify    = @"/api/password/verify";
NSString * const GQSerVerAPINameForAPIPasswordReset     = @"/api/password/reset";

//type:0余额+未读消息数 1余额
NSString * const GQSerVerAPINameForAPIUserAmount        = @"/api/user/amount";
NSString * const GQSerVerAPINameForAPIUserSpread        = @"/api/user/spread";
NSString * const GQSerVerAPINameForAPIUserSpreadList    = @"/api/user/spreadList";


NSString * const GQSerVerAPINameForAPIUserCheckin       = @"/api/user/checkin";
NSString * const GQSerVerAPINameForAPIUserCheckinList   = @"/api/user/checkinList";
NSString * const GQSerVerAPINameForAPIUsercheckinSubmit       = @"/api/user/checkinSubmit";

NSString * const GQSerVerAPINameForAPIUserMsg       = @"/api/user/msg";
NSString * const GQSerVerAPINameForAPIUserMsgDetail       = @"/api/user/msgDetail";


NSString * const GQSerVerAPINameForAPIUserBetList       = @"/api/user/betList";
NSString * const GQSerVerAPINameForAPIUserBetDetail       = @"/api/user/betDetail";

NSString * const GQSerVerAPINameForAPIUserAccountList       = @"/api/user/accountList";

NSString * const GQSerVerAPINameForAPIUserRechargeList      = @"/api/user/rechargeList";
NSString * const GQSerVerAPINameForAPIUserRechargeDetail      = @"/api/user/rechargeDetail";


NSString * const GQSerVerAPINameForAPIUserWithdrawList      = @"/api/user/withdrawList";
NSString * const GQSerVerAPINameForAPIUserWithdrawDetail     = @"/api/user/withdrawDetail";

NSString * const GQSerVerAPINameForAPISetting     = @"/api/setting";


NSString * const GQSerVerAPINameForAPISettingLoginPasswd     = @"/api/setting/loginPasswd";

NSString * const GQSerVerAPINameForAPISettingAboutUs     = @"/api/setting/aboutUs";

NSString * const GQSerVerAPINameForAPILogout     = @"/api/logout";


NSString * const GQSerVerAPINameForAPISettingGetQa     = @"/api/setting/getQa";
NSString * const GQSerVerAPINameForAPISettingQaSubmit     = @"/api/setting/qaSubmit";


NSString * const GQSerVerAPINameForAPISettingIsWithdrawPasswdSet     = @"/api/setting/isWithdrawPasswdSet";
NSString * const GQSerVerAPINameForAPISettingWithdrawPasswd     = @"/api/setting/withdrawPasswd";


NSString * const GQSerVerAPINameForAPISettingGetBank    = @"/api/setting/getBank";
NSString * const GQSerVerAPINameForAPISettingBindBank     = @"/api/setting/bindBank";


NSString * const GQSerVerAPINameForAPITrendTypeList     = @"/api/trend/typeList";


NSString * const GQSerVerAPINameForAPIUserWithdraw     = @"/api/user/withdraw";
NSString * const GQSerVerAPINameForAPIUserWithdrawSubmit     = @"/api/user/withdrawSubmit";

NSString * const GQSerVerAPINameForAPIUserRecharge     = @"/api/user/recharge";


NSString * const GQSerVerAPINameForAPIUserRbankList     = @"/api/user/rbankList";

NSString * const GQSerVerAPINameForAPIUserRonlineList     = @"/api/user/ronlineList";
NSString * const GQSerVerAPINameForAPIUserRqqpayList     = @"/api/user/rqqpayList";
NSString * const GQSerVerAPINameForAPIUserRotherList     = @"/api/user/rotherList";

NSString * const GQSerVerAPINameForAPIUserRwechatList     = @"/api/user/rwechatList";
NSString * const GQSerVerAPINameForAPIUserRalipayList     = @"/api/user/ralipayList";

NSString * const GQSerVerAPINameForAPIUserRbankNext     = @"/api/user/rbankNext";
NSString * const GQSerVerAPINameForAPIUserRbankSubmit     = @"/api/user/rbankSubmit";

NSString * const GQSerVerAPINameForAPIUserRqqpayNext     = @"/api/user/recharge/qqpayNext";
NSString * const GQSerVerAPINameForAPIUserRotherNext     = @"/api/user/recharge/otherNext";

NSString * const GQSerVerAPINameForAPIUserRwechatScanNext     = @"/api/user/rwechatScanNext";
NSString * const GQSerVerAPINameForAPIUserRalipayScanNext     = @"/api/user/ralipayScanNext";

NSString * const GQSerVerAPINameForAPIUserWechatNext     = @"/api/user/recharge/wechatNext";
NSString * const GQSerVerAPINameForAPIUserAlipayNext     = @"/api/user/recharge/alipayNext";


NSString * const GQSerVerAPINameForAPIUserRalipayBankNext     = @"/api/user/ralipayBankNext";
NSString * const GQSerVerAPINameForAPIUserWechatBankNext     = @"/api/user/rwechatBankNext";

NSString * const GQSerVerAPINameForAPIUserRalipayBankSubmit     = @"/api/user/ralipayBankSubmit";
NSString * const GQSerVerAPINameForAPIUserWechatBankSubmit     = @"/api/user/rwechatBankSubmit";


NSString * const GQSerVerAPINameForAPIUserRwechatScanSubmit     = @"/api/user/rwechatScanSubmit";
NSString * const GQSerVerAPINameForAPIUserRalipayScanSubmit     = @"/api/user/ralipayScanSubmit";


NSString * const GQSerVerAPINameForAPIBuy               = @"/api/buy";

NSString * const GQSerVerAPINameForAPIBetSubmit         = @"/api/bet/submit";

NSString * const GQSerVerAPINameForAPISendMessageCode       = @"/api/send/messageCode";
NSString * const GQSerVerAPINameForAPISendSubmit            = @"/api/send/submit";


//ronlineList
//rqqpayList
//rwechatList
//ralipayList


@implementation GQServerAPIManager

@end
