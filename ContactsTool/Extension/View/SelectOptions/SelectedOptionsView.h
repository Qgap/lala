//
//  DDChooseShopSizeView.h
//  dada
//
//  Created by wayne on 16/1/12.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SelectedOptionsBlock)(NSInteger index);

@interface SelectedOptionsView : UIView

+(void)showWithOnView:(UIView *)superView
              options:(NSArray<NSString *> *)options
        selectedIndex:(NSInteger)selectedIndex
             selected:(SelectedOptionsBlock)selected;

+(SelectedOptionsView*)showWithOnView:(UIView *)superView
                               options:(NSArray<NSString *> *)options
                         selectedIndex:(NSInteger)selectedIndex
                          clearBgColor:(BOOL)isClearBgColor
                              selected:(SelectedOptionsBlock)selected;

-(void)dismiss;
@end
