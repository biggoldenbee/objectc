//
//  HpCharactorCache.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 15/1/5.
//  Copyright (c) 2015年 zhou gang. All rights reserved.
//

#import "HpCharactorCache.h"
#import "HpBaseMacros.h"
#import "HpExtensionMacros.h"
#import "HpAnimVisitor.h"
#import "HpCharactor.h"
#import "HpSpriteFrame.h"

#import "HpAnimVisitor.h"
#import "HpAnimBuildVisitor.h"
#import "HpAnimRenderVisitor.h"
#import "HpCharactorXmlParser.h"
#import "HpCharactorBinParser.h"
#import "HpStack.h"


#define USE_COMMON_CACHE    1


@implementation HpCharactorCache
{
    NSCountedSet* _chrNames;
    NSMutableDictionary* _chrCache;
    NSCountedSet* _plistNames;
    NSMutableDictionary* _plistCache;
    NSMutableDictionary* _spriteFramesAliases;
    NSMutableDictionary* _textureCache;
    NSMutableSet* _allChrFiles;
    HpStack* _layerCreaterCache;
}


static_member_(id<HpAnimVisitor>, builder, HpAnimBuildVisitor);
static_member_(id<HpAnimVisitor>, render, HpAnimRenderVisitor);
static_member_(id<HpAnimParser>, xmlParse, HpCharactorXmlParser);
static_member_(id<HpAnimParser>, chrParse, HpCharactorBinParser);

#ifdef USE_COMMON_CACHE

static_member_(NSCountedSet*, chrNames, NSCountedSet);
static_member_(NSMutableDictionary*, chrCache, NSMutableDictionary);
static_member_(NSCountedSet*, plistName, NSCountedSet);
static_member_(NSMutableDictionary*, plistCache, NSMutableDictionary);
static_member_(NSMutableDictionary*, spriteFramesAliases, NSMutableDictionary);
static_member_(NSMutableDictionary*, textureCache, NSMutableDictionary);
static_member_(HpStack*, layerCreaterCache, HpStack);

#endif


- (id)init
{
    if (self = [super init]) {
#ifdef USE_COMMON_CACHE
        _chrNames = retain(self.chrNames);
        _chrCache = retain(self.chrCache);
        _plistNames = retain(self.plistName);
        _plistCache = retain(self.plistCache);
        _spriteFramesAliases = retain(self.spriteFramesAliases);
        _textureCache = retain(self.textureCache);
        _layerCreaterCache = retain(self.layerCreaterCache);
#else
        _chrNames = [[NSCountedSet alloc] init];
        _chrCache = [[NSMutableDictionary alloc] init];
        _plistNames = [[NSCountedSet alloc] init];
        _plistCache = [[NSMutableDictionary alloc] init];
        _spriteFramesAliases = [[NSMutableDictionary alloc] init];
        _textureCache = [[NSMutableDictionary alloc] init];
        _layerCreaterCache = [[HpStack alloc] init];
#endif

        _allChrFiles = [[NSMutableSet alloc] init];

    }

    return self;
}

- (void)dealloc
{
    [self removeAllCache];
    release(_chrNames);
    release(_chrCache);
    release(_plistNames);
    release(_plistCache);
    release(_spriteFramesAliases);
    release(_allChrFiles);
    super_dealloc();
}

- (id)addCharatorFile:(NSString*)fileName
{
    _fileName = retain(fileName);

    HpCharactor* chr = [_chrCache objectForKey:fileName];

    if (!chr)
    {
        id parser = [fileName rangeOfString:@".xml"].length > 0 ? [self xmlParse] : [self chrParse];
        chr = [parser parse:fileName];

        if (chr == nil) {
            NSLog(@"Fail to load charactor file %@!", fileName);
            return nil;
        }

        [_chrCache setObject:chr forKey:fileName];

        // add plist
        for (NSString* plist_name in chr.plists)
            [self addPlistFile:plist_name];

        // build
        [[self builder] begin:self];
        NSEnumerator* e = [chr.animas objectEnumerator];
        for (HpAnimation* a in e)
            [[self builder] visitAnima:a firstly:YES at:0];
        [[self builder] end];

    }

    if (![_allChrFiles member:fileName])
    {
        [_chrNames addObject:fileName];
        [_allChrFiles addObject:fileName];
    }

    return chr;
}

- (void)removeCharatorFile:(NSString*)fileName
{
    [_chrNames removeObject:fileName];
    if ([_chrNames member:fileName] == nil) {
        // will remove unrefrenced chr
        HpCharactor* chr = [_chrCache objectForKey:fileName];

        for (NSString* plist in chr.plists) {
            [self removePlistFile:plist];
        }

        [_chrCache removeObjectForKey:fileName];
    }
}

- (void)addPlistFile:(NSString*)plist
{
    NSAssert(plist, @"plist filename should not be nil");

    if( ! [_plistCache objectForKey:plist] ) {

        NSString *path = [HpHelper fullPathFromRelativePath:plist];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

        NSString *texturePath = nil;
        NSDictionary *metadataDict = [dict objectForKey:@"metadata"];
        if( metadataDict )
            // try to read  texture file name from meta data
            texturePath = [metadataDict objectForKey:@"textureFileName"];


        if( texturePath )
        {
            // build texture path relative to plist file
            NSString *textureBase = [plist stringByDeletingLastPathComponent];
            texturePath = [textureBase stringByAppendingPathComponent:texturePath];
        } else {
            // build texture path by replacing file extension
            texturePath = [plist stringByDeletingPathExtension];
            texturePath = [texturePath stringByAppendingPathExtension:@"png"];
        }

        NSMutableDictionary* spriteframes = [self addSpriteFramesWithDictionary:dict textureReference:texturePath];
        [spriteframes setObject:texturePath forKey:plist];  // add a plist->png for easy finding

        [_plistCache setObject:spriteframes forKey:plist];
    }

    [_plistNames addObject:plist];
}


- (void)removePlistFile:(NSString*)plist
{
    [_plistNames removeObject:plist];

    if ([_plistNames member:plist] == nil) {
        // will remove ununsed plist
        NSDictionary* spriteframes = [_plistCache objectForKey:plist];
        NSString* textureFilename = [spriteframes objectForKey:plist];
        // will remove associated texture
        [_textureCache removeObjectForKey:textureFilename];
        [_plistCache removeObjectForKey:plist];
    }
    
}

- (void)removeAllCache
{
    for (NSString* file in _allChrFiles) {
        [self removeCharatorFile:file];
    }
}


- (HpCharactor*)charactorByFile:(NSString*)file
{
    return [_chrCache objectForKey:file];
}

- (HpSpriteFrame*)spriteFrameByName:(NSString*)name
{
    NSArray* plists = [[_chrCache objectForKey:self.fileName] plists];
    for (NSString* plisName in plists) {
        HpSpriteFrame* sf = [[_plistCache objectForKey:plisName] objectForKey:name];
        if ( sf )
            return sf;
    }

    return nil;
}

- (HpAnimation*)animtionByName:(NSString*)name
{
    HpCharactor* chr = [_chrCache objectForKey:_fileName];
    return [chr.animas objectForKey:name];
}

- (UIImage*)imageBySpriteFrame:(HpSpriteFrame*)spriteframe
{
    UIImage* texture = [_textureCache objectForKey:spriteframe.textureFilename];
    if (texture == nil) {
        texture = [UIImage imageWithContentsOfFile:[HpHelper fullPathFromRelativePath:spriteframe.textureFilename]];
        [_textureCache setObject:texture forKey:spriteframe.textureFilename];
    }

    return texture;
}

-(NSMutableDictionary*) addSpriteFramesWithDictionary:(NSDictionary*)dictionary textureReference:(id)textureReference
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    /*
     Supported Zwoptex Formats:
     ZWTCoordinatesFormatOptionXMLLegacy = 0, // Flash Version
     ZWTCoordinatesFormatOptionXML1_0 = 1, // Desktop Version 0.0 - 0.4b
     ZWTCoordinatesFormatOptionXML1_1 = 2, // Desktop Version 1.0.0 - 1.0.1
     ZWTCoordinatesFormatOptionXML1_2 = 3, // Desktop Version 1.0.2+
     */
    NSDictionary *metadataDict = [dictionary objectForKey:@"metadata"];
    NSDictionary *framesDict = [dictionary objectForKey:@"frames"];

    int format = 0;

    // get the format
    if(metadataDict != nil)
        format = [[metadataDict objectForKey:@"format"] intValue];

    // check the format
    NSAssert( format >= 0 && format <= 3, @"format is not supported for CCSpriteFrameCache addSpriteFramesWithDictionary:textureFilename:");

    // SpriteFrame info
    CGRect rectInPixels;
    BOOL isRotated = NO;
    CGPoint frameOffset;
    CGSize originalSize;

    // add real frames
    for(NSString *frameDictKey in framesDict) {
        NSDictionary *frameDict = [framesDict objectForKey:frameDictKey];
        HpSpriteFrame *spriteFrame=nil;
        if(format == 0) {
            float x = [[frameDict objectForKey:@"x"] floatValue];
            float y = [[frameDict objectForKey:@"y"] floatValue];
            float w = [[frameDict objectForKey:@"width"] floatValue];
            float h = [[frameDict objectForKey:@"height"] floatValue];
            float ox = [[frameDict objectForKey:@"offsetX"] floatValue];
            float oy = [[frameDict objectForKey:@"offsetY"] floatValue];
            int ow = [[frameDict objectForKey:@"originalWidth"] intValue];
            int oh = [[frameDict objectForKey:@"originalHeight"] intValue];
            // check ow/oh
            if(!ow || !oh)
                NSLog(@"cocos2d: WARNING: originalWidth/Height not found on the CCSpriteFrame. AnchorPoint won't work as expected. Regenerate the .plist");

            // abs ow/oh
            ow = abs(ow);
            oh = abs(oh);

            // set frame info
            rectInPixels = CGRectMake(x, y, w, h);
            isRotated = NO;
            frameOffset = CGPointMake(ox, oy);
            originalSize = CGSizeMake(ow, oh);
        } else if(format == 1 || format == 2) {
            CGRect frame = CGRectFromString([frameDict objectForKey:@"frame"]);
            BOOL rotated = NO;

            // rotation
            if(format == 2)
                rotated = [[frameDict objectForKey:@"rotated"] boolValue];

            CGPoint offset = CGPointFromString([frameDict objectForKey:@"offset"]);
            CGSize sourceSize = CGSizeFromString([frameDict objectForKey:@"sourceSize"]);

            // set frame info
            rectInPixels = frame;
            isRotated = rotated;
            frameOffset = offset;
            originalSize = sourceSize;
        } else if(format == 3) {
            // get values
            CGSize spriteSize = CGSizeFromString([frameDict objectForKey:@"spriteSize"]);
            CGPoint spriteOffset = CGPointFromString([frameDict objectForKey:@"spriteOffset"]);
            CGSize spriteSourceSize = CGSizeFromString([frameDict objectForKey:@"spriteSourceSize"]);
            CGRect textureRect = CGRectFromString([frameDict objectForKey:@"textureRect"]);
            BOOL textureRotated = [[frameDict objectForKey:@"textureRotated"] boolValue];

            // get aliases
            NSArray *aliases = [frameDict objectForKey:@"aliases"];
            for(NSString *alias in aliases) {
                if( [_spriteFramesAliases objectForKey:alias] )
                    NSLog(@"cocos2d: WARNING: an alias with name %@ already exists",alias);

                [_spriteFramesAliases setObject:frameDictKey forKey:alias];
            }

            // set frame info
            rectInPixels = CGRectMake(textureRect.origin.x, textureRect.origin.y, spriteSize.width, spriteSize.height);
            isRotated = textureRotated;
            frameOffset = spriteOffset;
            originalSize = spriteSourceSize;
        }

        NSString *textureFileName = textureReference;
        spriteFrame = [[HpSpriteFrame alloc] initWithTextureFilename:textureFileName rectInPixels:rectInPixels rotated:isRotated offset:frameOffset originalSize:originalSize];

        // add sprite frame
        [result setObject:spriteFrame forKey:frameDictKey];
        release(spriteFrame);
    }
    
    return result;
}


@end
