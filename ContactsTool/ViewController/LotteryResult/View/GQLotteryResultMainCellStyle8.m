//
//  CPLotteryResultMainCellStyle8.m
//  lottery
//
//  Created by wayne on 2017/7/18.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "GQLotteryResultMainCellStyle8.h"
@interface GQLotteryResultMainCellStyle8 ()
{
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_contentLabel;
    
}
@end

@implementation GQLotteryResultMainCellStyle8


-(void)addTitle:(NSString *)title content:(NSString *)content result:(NSArray *)result
{
    super.titleLabel = _titleLabel;
    super.contentLabel = _contentLabel;
    [super addTitle:title content:content result:result];
}


@end
