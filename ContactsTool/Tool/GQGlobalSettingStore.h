

#import <Foundation/Foundation.h>

@interface GQGlobalSettingStore : NSObject

@property(nonatomic,assign,readonly)BOOL isOpenButtonVoice;

-(void)cookBook_switchButtonVoiceIsOpen:(BOOL)isOpen;


@end
