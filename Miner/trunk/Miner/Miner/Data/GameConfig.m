//
//  GameConfig.m
//  Miner
//
//  Created by jim kaden on 14/10/23.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "GameConfig.h"
#import "GzipUtility.h"
#import "haypi/net.h"
#import "PackageManager.h"

//#import "AppdowncontriConfig.h"
//#import "AssemblypayConfig.h"
#import "AttriConfig.h"
#import "BagExtentConfig.h"
#import "BuffConfig.h"
#import "ConstantsConfig.h"
#import "DropConfig.h"
#import "EquipmentConfig.h"
#import "ExtraConfig.h"
#import "HeroConfig.h"
#import "ItemConfig.h"
#import "MapConfig.h"
#import "MobConfig.h"
#import "MultilanConfig.h"
#import "PetConfig.h"
#import "PortConfig.h"
#import "QuickBattleConfig.h"
#import "RandateConfig.h"
#import "StringConfig.h"
#import "SkillConfig.h"
#import "VersionConfig.h"

@interface GameConfig ()

@property (nonatomic, strong) NSString *pathCaches; // Caches的路径
@end

@implementation GameConfig
static GameConfig* theGlobalGameConfig = nil;

+(GameConfig*)sharedInstance
{
    if ( theGlobalGameConfig == nil )
    {
        static dispatch_once_t gameConfigOnce = 0;
        dispatch_once(&gameConfigOnce, ^(void){
            theGlobalGameConfig = [[GameConfig alloc]initInstance];
        });
    }
    return theGlobalGameConfig;
}

-(id)initInstance
{
    self = [super init];
    if (self)
    {
        self.config = [[Config alloc]init];
        // 设置caches的路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        self.pathCaches = [paths objectAtIndex:0];
        self.pathCaches = [self.pathCaches stringByAppendingString:@"/"];
        
        [self initAllConfigFiles];
    }
    return self;
}

-(NSDictionary *)getAllVersions
{
    return [[VersionConfig share] getAllVersions];
}

//
// 配置文件名和配置类一一对应
//
-(void)initAllConfigFiles
{
    self.configObjects = [[NSMutableDictionary alloc]init];
//    [self.configObjects setObject:[AppdowncontriConfig share] forKey:@"appdowncontri"];
//    [self.configObjects setObject:[AssemblypayConfig share] forKey:@"assemblypay"];
    [self.configObjects setObject:[AttriConfig share] forKey:@"attri"];
    [self.configObjects setObject:[BagExtentConfig share] forKey:@"bagextent"];
    [self.configObjects setObject:[BuffConfig share] forKey:@"buff"];
    [self.configObjects setObject:[ConstantsConfig share] forKey:@"constants"];
    [self.configObjects setObject:[ContributionConfig share] forKey:@"contribution"];
    [self.configObjects setObject:[DropConfig share] forKey:@"drop"];
    [self.configObjects setObject:[EquipmentConfig share] forKey:@"equip"];
    [self.configObjects setObject:[ExtraConfig share] forKey:@"extra"];
    [self.configObjects setObject:[HeroConfig share] forKey:@"hero"];
    [self.configObjects setObject:[HeroInitConfig share] forKey:@"heroinit"];
    [self.configObjects setObject:[ItemConfig share] forKey:@"item"];
    [self.configObjects setObject:[MainAttriLvConfig share] forKey:@"mainattrilv"];
    [self.configObjects setObject:[MapConfig share] forKey:@"map"];
    [self.configObjects setObject:[MineConfig share] forKey:@"mine"];
    [self.configObjects setObject:[MobConfig share] forKey:@"mob"];
    [self.configObjects setObject:[MobDataConfig share] forKey:@"mobdata"];
    [self.configObjects setObject:[MultilanConfig share] forKey:@"multilan"];
//    [self.configObjects setObject:[NewsPaperContriConfig share] forKey:@"newspapercontri"];
    [self.configObjects setObject:[PetConfig share] forKey:@"pet"];
    [self.configObjects setObject:[PetDataConfig share] forKey:@"petdata"];
    [self.configObjects setObject:[PetLvConfig share] forKey:@"petlv"];
    [self.configObjects setObject:[PortConfig share] forKey:@"port"];
    [self.configObjects setObject:[PortLvConfig share] forKey:@"portlv"];
//    [self.configObjects setObject:[PortLvupkey share] forKey:@"portlvupkey"];
    [self.configObjects setObject:[QuickBattleConfig share] forKey:@"quickbattle"];
    [self.configObjects setObject:[RandateConfig share] forKey:@"randata"];
//    [self.configObjects setObject:[RelationRewardConfig share] forKey:@"relationreward"];
    [self.configObjects setObject:[SkillConfig share] forKey:@"skill"];
//    [self.configObjects setObject:[SpecialAttrilvconfig share] forKey:@"specialattrilv"];
    [self.configObjects setObject:[StringConfig share] forKey:@"string"];
    [self.configObjects setObject:[SubAttriGConfig share] forKey:@"subattrig"];
    [self.configObjects setObject:[SubAttriLvConfig share] forKey:@"subattrilv"];
    [self.configObjects setObject:[TcConfig share] forKey:@"tc"];
    [self.configObjects setObject:[VersionConfig share] forKey:@"version"];
}

//  清除缓存区的配置文件
-(void)clearConfigsInCaches
{
    NSString *ext = @"dat";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:self.pathCaches error:nil];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        if ([[filename pathExtension] isEqualToString:ext])
        {
            [fileManager removeItemAtPath:[self.pathCaches stringByAppendingString:filename] error:nil];
        }
    }
}

// 根据文件名去加载版本配置文件
-(void)loadVersionConfigWithFileName:(NSString *)filename
{
    VersionConfig *verCaches = [[VersionConfig alloc]init];
    VersionConfig *verBundle = [[VersionConfig alloc]init];
    
    BOOL verCachesLoad = [verCaches loadWithFile:filename InDirectory:self.pathCaches];
    
    [[VersionConfig share] reset];
    if (verCachesLoad == YES)   // 是否有缓冲版本文件
    {
        [verBundle loadWithFileInMainBundle:filename];
        int verVerCaches = [[[verCaches rowAtIndex:0] verNum] intValue];
        int verVerBundle = [[[verBundle rowAtIndex:0] verNum] intValue];
        if (verVerCaches < verVerBundle)    // 缓存区的版本小于应用内的版本
        {
            // 清楚缓存区版本  读取应用内版本
            [self clearConfigsInCaches];
            [[VersionConfig share] loadWithFileInMainBundle:filename];
        }
        else
        {
            // 读取缓存区的版本配置
            [[VersionConfig share] loadWithFile:filename InDirectory:self.pathCaches];
        }
    }
    else
    {
        // 读取应用内版本配置
        [[VersionConfig share] loadWithFileInMainBundle:filename];
    }
}

// 加载全部的配置文件
-(void)loadAllConfigs
{
    [self loadVersionConfigWithFileName:@"version.dat"];
    
    NSArray *tempConfigs = [[VersionConfig share] getAllConfigFileNames];
    for (int i=0; i<[tempConfigs count]; i++)
    {
        NSString *filename = [tempConfigs objectAtIndex:i];
        BaseDBReader * ob = [self.configObjects objectForKey:filename];
        if (ob == nil)
        {
            NSLog(@"%@ file is not exist.", filename);
            continue;
        }
        if ( [filename hasSuffix:@".dat"] == NO )
            filename = [filename stringByAppendingString:@".dat"];
        BOOL bRet = [ob loadWithFile:filename InDirectory:self.pathCaches];
        if (!bRet)
        {
            bRet = [ob loadWithFileInMainBundle:filename];
            if (!bRet)
            {
                NSLog(@"Loading file's name is %@, error!", filename);
            }
        }
    }
}

//-(BOOL)saveConfigInCaches:(NSString *)filename context:(NSData *)data
//{
//    NSString *fullName = [pathCaches stringByAppendingString:filename];
//    fullName = [fullName stringByAppendingString:@".dat"];
//    [data writeToFile:fullName atomically:YES];
//}

-(void)downloadNeedUpdateFiles:(NSDictionary *)verdict
{
//    NSArray *keys = [verdict allKeys];
//    for (NSString *configname in keys)
    {
        //        // 这里需要判断是否用url下载
        //        NSDictionary *dictVer = [dictVers objectForKey:configname];
        //        NSLog(@"dictVer:%@",dictVer);
//        [[PackageManager sharedInstance] configRequest:configname];
    }
}

#pragma mark - About Config Data
-(void)setBattleConfigWithDictionary:(NSDictionary *)data
{
    if (self.config == nil)
    {
        self.config = [[Config alloc]init];
    }
    [self.config setConfigDataWithDictionary:data];
}

#pragma mark - Encode data
-(BOOL)encodeConfigData:(NSString *)dataStr Name:(NSString *)name
{
    char* base64Data = (char*)[dataStr UTF8String];
    char* decordData = (char*)malloc(strlen(base64Data)*sizeof(char));
    int length = (int)[dataStr length];
    int base64Length = base64_decode_(decordData, base64Data, length);
    decordData[base64Length] = 0;
    NSData* data= [NSData dataWithBytes:decordData length:base64Length];
    NSData* ndata = [GzipUtility decompressData:data];  // 解压
    //NSString* path = [pathCaches stringByAppendingPathComponent:name];
    
    BOOL succeed = [self saveConfigInCaches:name context:ndata];
    free(decordData);
    return succeed;
}

-(BOOL)saveConfigInCaches:(NSString *)filename context:(NSData *)data
{
    NSString *fullName = [self.pathCaches stringByAppendingString:filename];
    fullName = [fullName stringByAppendingString:@".dat"];
    //[data writeToFile:fullName atomically:YES];
    return [[NSFileManager defaultManager] createFileAtPath:fullName contents:data attributes:nil];
}
@end
