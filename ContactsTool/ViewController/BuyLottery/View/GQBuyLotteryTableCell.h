//
//  CPBuyLotteryTableCell.h
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQBuyLotteryTableCell : UITableViewCell

@property(nonatomic,retain)GQLotteryModel *lotteryModel;

+(CGFloat)cellHeightByLotteryModel:(GQLotteryModel *)lotteryModel
                         cellWidth:(CGFloat)cellWidth;
@end
