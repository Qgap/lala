//
//  CPBuyLotteryManager.h
//  lottery
//
//  Created by 施小伟 on 2017/11/26.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    
    CPLotteryResultForE11X5     = 0,
    CPLotteryResultForXGLHC     = 1,
    CPLotteryResultForSSC       = 2,
    CPLotteryResultForSHSSL     = 3,
    CPLotteryResultForP13       = 4,
    CPLotteryResultForPK10      = 5,
    CPLotteryResultForPCDD      = 6,
    CPLotteryResultForKLSF      = 7,
    CPLotteryResultForK3        = 8,
    CPLotteryResultForFC3D      = 9
    
    
} CPLotteryResultType;


#define CPLotteryResultTypeByTypeString(typeString)\
[@[@"e11x5",@"xglhc",@"ssc",@"shssl",@"pl3",@"pk10",@"pcdd",@"klsf",@"k3",@"fc3d",] indexOfObject:typeString]

@interface CBBuyLyManager : NSObject


+(instancetype)shareManager;

/**
 当前的购买彩种的类型
 */
@property(nonatomic,assign)CPLotteryResultType currentBuyLotteryType;

/**
 当前的玩法名称
 */
@property(nonatomic,copy)NSString *currentPlayKindDes;


/*
 当前投注期数
 */
@property(nonatomic,copy)NSString *currentBetPeriod;



/**
 获取快3类型的图片

 @param number 数字
 */
+(UIImage *)k3BackgroundImageByNumber:(NSString *)number;




@end
