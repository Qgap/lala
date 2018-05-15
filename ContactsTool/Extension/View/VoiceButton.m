//
//  VoiceButton.m
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "VoiceButton.h"

@interface VoiceButton ()
@end

@implementation VoiceButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [DataCenter cookBook_playButtonClickVoice];
    
}

@end
