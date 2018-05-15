//
//  CPBuyLotteryCollectionCell.m
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "GQBuyLotteryCollectionCell.h"

@interface GQBuyLotteryCollectionCell()
{
    IBOutlet UIImageView *_pictureImageView;
    IBOutlet UILabel *_nameLabel;
    
}
@end

@implementation GQBuyLotteryCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setLotteryModel:(GQLotteryModel *)lotteryModel
{
    _lotteryModel = lotteryModel;
    [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:_lotteryModel.fullPicUrlString] placeholderImage:nil];
    _nameLabel.text = _lotteryModel.name;
}

@end
