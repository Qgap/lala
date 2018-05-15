//
//  DDChooseShopSizeView.h
//  dada
//
//  Created by wayne on 16/1/12.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SelectedOptionsAgoBlock)(NSInteger index);

@interface SelectedOptionsAgoView : UIView

+(void)showWithOnView:(UIView *)superView
                title:(NSString *)title
              options:(NSArray<NSString *> *)options
        selectedIndex:(NSInteger)selectedIndex
             selected:(SelectedOptionsAgoBlock)selected;

@end
