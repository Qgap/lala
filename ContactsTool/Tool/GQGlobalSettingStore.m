

#import "GQGlobalSettingStore.h"

@interface GQGlobalSettingStore ()
{
    NSString *_openButtonVoice;
}

@end

@implementation GQGlobalSettingStore

static GQGlobalSettingStore *shareStore;

+(GQGlobalSettingStore *)shareStore{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        GQGlobalSettingStore *existStore = [GQGlobalSettingStore loadStore];
        shareStore = existStore?existStore:[GQGlobalSettingStore new];
    });
    
    return shareStore;
}

#pragma mark- class method

+(BOOL)saveStore:(GQGlobalSettingStore *)store
{
    @synchronized(self) {
        
        shareStore = store;
        NSData * storeData = [NSKeyedArchiver archivedDataWithRootObject:store];
        NSData * aesStoreData = [storeData AES256EncryptWithKey:loadSettingStoreInfoAES256Key()];
        BOOL isOk = [aesStoreData writeToFile:loadSettingStoreInfoFullPath() atomically:YES];
        return isOk;
    }
    
}

#pragma mark- coding delegate

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_openButtonVoice forKey:@"_openButtonVoice"];
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self != nil)
    {
        _openButtonVoice = [aDecoder decodeObjectForKey:@"_openButtonVoice"];
        
    }
    return self;
}

#pragma mark- object method

-(void)cookBook_switchButtonVoiceIsOpen:(BOOL)isOpen
{
    if (isOpen) {
        _openButtonVoice = @"1";
    }else{
        _openButtonVoice = @"0";
    }
    [GQGlobalSettingStore saveStore:self];
}

#pragma mark- getter

-(BOOL)isOpenButtonVoice
{
    if ([_openButtonVoice isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

#pragma mark- AES

NSString * loadSettingStoreInfoFolder(){
    
    return @"settingStore";
}

NSString * loadSettingStoreInfoFullPath(){
    
    return [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:loadSettingStoreInfoFolder()];
}

#pragma mark- AES

NSString * loadSettingStoreInfoAES256Key(){
    
    return @"settingStoreA26K";
}

/**
 *  加载本地储存的用户信息
 *
 *  @return 用户
 */
+(GQGlobalSettingStore *)loadStore
{
    NSData * aesStoreData = [NSData dataWithContentsOfFile:loadSettingStoreInfoFullPath()];
    NSData * storeData = [aesStoreData AES256DecryptWithKey:loadSettingStoreInfoAES256Key()];
    GQGlobalSettingStore * store = [NSKeyedUnarchiver unarchiveObjectWithData:storeData];
    return store;
}

@end
