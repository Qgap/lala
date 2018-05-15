//
//  CPLotteryResultMainCellStyle0.m
//  lottery
//
//  Created by wayne on 2017/7/18.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "GQLotteryResultMainCellStyle0.h"

@interface GQLotteryResultMainCellStyle0()
{
}

@end

@implementation GQLotteryResultMainCellStyle0

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)addTitle:(NSString *)title
        content:(NSString *)content
         result:(NSArray *)result
{

    _titleLabel.text = title;
    _contentLabel.text = content;
    
    CGFloat width = [_titleLabel.text suitableFromMaxSize:CGSizeMake(self.width, _titleLabel.height) font:_titleLabel.font].width;
    NSLog(@"宽度有：%f",width);
//    _titleLabel.width = width;
//    _contentLabel.originX = _titleLabel.rightX+3.0f;
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
}

@end
