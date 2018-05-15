//
//  CPTimeManager.h
//  lottery
//
//  Created by wayne on 2017/10/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShiJianManager : NSObject

@property(nonatomic,assign,readonly)NSTimeInterval beijingTiemDistance;


+(ShiJianManager *)shareTimeManager;
-(void)cookBook_reloadBeiJingTime;



@end
