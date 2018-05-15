//
//  CPHomePageHotLotteryItem.h
//  lottery
//
//  Created by wayne on 2017/6/12.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CPHomePageHotLotteryItemClickAction)(GQLotteryModel *lotteryModel);

@interface CPHomePageHotLotteryItem : UIView

@property(nonatomic,assign)BOOL isShowRightGapLine;

-(instancetype)initWithFrame:(CGRect)frame
                     lottery:(GQLotteryModel*)lottery
                 clickAction:(CPHomePageHotLotteryItemClickAction)action;

@end
