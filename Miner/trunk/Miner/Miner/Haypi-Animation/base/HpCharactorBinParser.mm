//
//  HpCharactorBinParser.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpCharactorBinParser.h"
#import "HpBinaryReader.h"
#import "HpCharactor.h"
#import "HpAnimation.h"
#import "HpLayer.h"
#import "HpImageKeyframe.h"
#import "HpAnimaKeyframe.h"
#import "HpInterpHolder.h"
#import "HpLinearInterpolator.h"
#import "HpSplineInterpolator.h"
#import "HpBaseMacros.h"
#import "HpExtensionMacros.h"

@interface HpCharactorBinParser ()
{
    HpCharactor* _cur_chara;
    HpAnimation* _cur_anima;
    HpLayer* _cur_layer;
    HpKeyframe* _cur_keyfrm;
}

@end


static Byte ChrReadingVersion = 0x00;
static float Byte2Double = 1/255.f;

CGPoint readPoint(HpBinaryReader* reader);
UIColor* readColor(HpBinaryReader* reader);
id<HpInterp> readInterp(HpBinaryReader* reader);


@implementation HpCharactorBinParser

-(void)dealloc
{
    _cur_chara = nil;
    _cur_anima = nil;
    _cur_layer = nil;
    _cur_keyfrm = nil;
    super_dealloc();
}

-(id)parse:(NSString*)chrfile
{
    _cur_chara = [[HpCharactor alloc] init];

    NSString *fullpath = [HpHelper fullPathFromRelativePath:chrfile];
    const char * abspath = [fullpath cStringUsingEncoding:NSASCIIStringEncoding];

    HpBinaryReader reader(abspath);
    char buffer[128] = {0};

    reader.readChars(buffer, 3);

    NSString* chr = [NSString stringWithUTF8String:buffer];
    if (![chr isEqualToString:@"CHR"]) return nil;

    ChrReadingVersion = reader.readByte();

    Byte plist_count = reader.readByte();
    for (int i=0; i<plist_count; i++) {
        reader.readString(buffer);
        NSString* path = [NSString stringWithUTF8String:buffer];
        NSArray* components = [path componentsSeparatedByString:@"\\"];
        [_cur_chara.plists addObject:[components objectAtIndex:components.count - 1]];
    }

    if (ChrReadingVersion >= 0x07) {
        Byte music_cout = reader.readByte();
        for (int i=0; i<music_cout; i++) {
            reader.readString(buffer);
        }
    }

    ushort ani_count = reader.readUInt16();
    for (int i=0; i<ani_count; i++)
    {
        [self readAnimation:&reader :buffer];
    }

    reader.close();
    return autorelease(_cur_chara);
}

- (void)readAnimation:(HpBinaryReader*)reader :(char*)buffer
{
    reader->readString(buffer);
    NSString* ani_name = [[NSString alloc] initWithUTF8String: buffer];
    if ([_cur_chara.animas objectForKey:ani_name])
        NSLog(@"Duplicated animation id : %@", ani_name);

    int len = 0;
    switch (ChrReadingVersion) {
        case 0x02:
        case 0x03:
            len = reader->readByte();
            break;
        default:
            len = reader->readUInt16();
            break;
    }

    if (ChrReadingVersion >= 0x08) {
        Byte attrib_count = reader->readByte();
        for (int i=0; i<attrib_count; i++) {
            reader->readString(buffer);
            reader->readString(buffer);
        }
    }

    _cur_anima = [[HpAnimation alloc] initWithName:ani_name length:len];
    [_cur_chara.animas setObject:_cur_anima forKey:ani_name];
    release(_cur_anima);
    release(ani_name);
//    release(ani_name);

    Byte layer_count = reader->readByte();
    for (int j=0; j<layer_count; j++) {
        [self readLayer:reader buffer:buffer];
    }
}

- (void)readLayer:(HpBinaryReader*)reader buffer:(char*)buffer
{
    reader->readString(buffer);
    NSString* layer_name = [[NSString alloc] initWithUTF8String:buffer];
    _cur_layer = [[HpLayer alloc] initWithName:layer_name];
    [_cur_anima.layers addObject:_cur_layer];
    release(_cur_layer);
    release(layer_name);

    ushort key_count = reader->readUInt16();
    for (int k=0; k<key_count; k++) {
        [self readKeyFrame:reader :buffer];
    }
}

- (void)readKeyFrame:(HpBinaryReader*)reader :(char*)buffer
{
    _cur_keyfrm = [[HpKeyframe alloc] init];
    _cur_keyfrm.contentType = (HpContentType)reader->readByte();
    _cur_keyfrm.arrayIndex = (int)_cur_layer.keys.count;
    [_cur_layer.keys addObject:_cur_keyfrm];
    release(_cur_keyfrm);

    if (_cur_keyfrm.contentType != HpContentType_Null){
        reader->readString(buffer);
        _cur_keyfrm.content = [[NSString alloc] initWithUTF8String:buffer];
        release(_cur_keyfrm.content);
    }

    [self readCommon: reader: _cur_keyfrm : buffer];
}

- (void)readCommon:(HpBinaryReader*)reader :(HpKeyframe*)p_kf : (char*) buffer
{
    switch (ChrReadingVersion) {
        case 0x02:
        case 0x03:
            p_kf.Time = reader->readByte();
            break;
        default:
            p_kf.Time = reader->readUInt16();
            break;
    }

    if (_cur_keyfrm.contentType == HpContentType_Null)
        return;

    if (p_kf.contentType == HpContentType_Anima)
        p_kf.isTimeInherited = reader->readBoolean();

    p_kf.center = readPoint(reader);
    p_kf.scale = readPoint(reader);
    p_kf.skew = readPoint(reader);
    p_kf.rot = reader->readSingle();
    p_kf.trans = readPoint(reader);
    p_kf.color = readColor(reader);

    if (ChrReadingVersion >= 0x05) {
        readColor(reader);
    }

    if (ChrReadingVersion >= 0x06) {
        reader->readByte();
    }

    reader->readString(buffer);
    p_kf.event = [[NSString alloc] initWithUTF8String:buffer];
    release(p_kf.event);

    Byte interp_type = reader->readByte();
    if (interp_type > 0){
        HpInterpHolder* holder = [[HpInterpHolder alloc]init];
        _cur_keyfrm.Interps = holder;
        release(holder);

        if (interp_type == 1){
            holder.CenterInterp = holder.ScaleInterp = holder.SkewInterp = holder.RotInterp =
            holder.TransInterp =holder.ColorInterp = [HpLinearInterp interp];
        }else if (interp_type == 2){
            holder.CenterInterp = holder.ScaleInterp = holder.SkewInterp = holder.RotInterp =
            holder.TransInterp =holder.ColorInterp = readInterp(reader);
        }else if (interp_type == 3){
            holder.CenterInterp = readInterp(reader);
            holder.ScaleInterp = readInterp(reader);
            holder.SkewInterp = readInterp(reader);
            holder.RotInterp = readInterp(reader);
            holder.TransInterp = readInterp(reader);
            holder.ColorInterp = readInterp(reader);
        }
    }
}

@end

CGPoint readPoint(HpBinaryReader* reader)
{
    double x = reader->readSingle();
    double y = reader->readSingle();
    return CGPointMake(x, y);
}

UIColor* readColor(HpBinaryReader* reader)
{
    double r = reader->readByte()*Byte2Double;
    double g = reader->readByte()*Byte2Double;
    double b = reader->readByte()*Byte2Double;
    double a = reader->readByte()*Byte2Double;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

id<HpInterp> readInterp(HpBinaryReader* reader)
{
    switch (ChrReadingVersion) {
        case 0x02:
        {
            HpSplineInterp* interp = [[HpSplineInterp alloc]init];
            interp.p1 = readPoint(reader);
            interp.p2 = readPoint(reader);
            return autorelease(interp);
        }
        default:
        {
            HpSplineInterp* interp = [[HpSplineInterp alloc]init];
            double p1x = reader->readByte()*Byte2Double;
            double p1y = reader->readByte()*Byte2Double;
            double p2x = reader->readByte()*Byte2Double;
            double p2y = reader->readByte()*Byte2Double;
            interp.p1 = CGPointMake(p1x, p1y);
            interp.p2 = CGPointMake(p2x, p2y);
            return autorelease(interp);
        }
    }
}

