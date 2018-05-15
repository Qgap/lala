//
//  CPLotteryModel.h
//  lottery
//
//  Created by wayne on 2017/6/12.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GQLotteryModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *num;
@property(nonatomic,copy)NSString *pic;

@property(nonatomic,copy)NSString *fullPicUrlString;


@property(nonatomic,copy)NSString *lastOpen;
@property(nonatomic,copy)NSString *lastPeriod;
@property(nonatomic,copy)NSString *period;
@property(nonatomic,copy)NSString *timeout;


@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *openTime;

@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *status;


//extension
@property(nonatomic,assign)int mainResultCellStyle;
@property(nonatomic,retain)NSArray *resultArray;
@property(nonatomic,retain)NSString *noteDes;

@end
