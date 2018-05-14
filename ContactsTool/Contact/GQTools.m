//
//  GQTools.m
//  Contact
//
//  Created by gap on 2018/5/10.
//  Copyright © 2018年 gq. All rights reserved.
//

#import "GQTools.h"

@implementation GQTools

+ (BOOL)CNLanguage {
    return [GQTools ZhHans] || [GQTools ZhHant];
}

+ (BOOL)CNArea {
    NSString * country= [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    if ([country isEqualToString:@"CN"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)ZhHant {
    NSString *pfLanguageCode = [NSLocale preferredLanguages][0];
    if ([pfLanguageCode isEqualToString:@"zh-Hant"] ||
        [pfLanguageCode hasPrefix:@"zh-Hant"] ||
        [pfLanguageCode hasPrefix:@"yue-Hant"] ||
        [pfLanguageCode isEqualToString:@"zh-HK"] ||
        [pfLanguageCode isEqualToString:@"zh-TW"]
        ) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)ZhHans {
    NSString *pfLanguageCode = [NSLocale preferredLanguages][0];
    if ([pfLanguageCode isEqualToString:@"zh-Hans"] ||
        [pfLanguageCode hasPrefix:@"yue-Hans"] ||
        [pfLanguageCode hasPrefix:@"zh-Hans"]) {
        return YES;
    } else
    {
        return NO;
    }
}

@end
