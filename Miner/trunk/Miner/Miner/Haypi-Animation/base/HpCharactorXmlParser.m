//
//  HpCharactorXmlParser.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpCharactorXmlParser.h"
#import "HpCharactor.h"
#import "HpAnimation.h"
#import "HpLayer.h"
#import "HpKeyframe.h"
#import "HpImageKeyframe.h"
#import "HpAnimaKeyframe.h"
#import "HpInterpHolder.h"
#import "HpLinearInterpolator.h"
#import "HpSplineInterpolator.h"
#import "HpBaseMacros.h"
#import "HpExtensionMacros.h"

@interface HpCharactorXmlParser () <NSXMLParserDelegate>
{
    HpCharactor* _cur_chara;
    HpAnimation* _cur_anima;
    HpLayer* _cur_layer;
    HpKeyframe* _cur_keyfrm;
    int _cur_property;
}

@end

enum CharKeyPropertyType
{
    CharKeyProperty_None,
    CharKeyProperty_Image,
    CharKeyProperty_Anima,
    CharKeyProperty_Time,
    CharKeyProperty_TimeInher,
    CharKeyProperty_Center,
    CharKeyProperty_Trans,
    CharKeyProperty_Scale,
    CharKeyProperty_Rot,
    CharKeyProperty_Skew,
    CharKeyProperty_Color,
    CharKeyProperty_Event
};


@implementation HpCharactorXmlParser

-(void)dealloc
{
    _cur_chara = nil;
    _cur_anima = nil;
    _cur_layer = nil;
    _cur_keyfrm = nil;
    super_dealloc();
}

-(id)parse:(NSString*)xmlfile
{
    _cur_chara = nil;

    NSString* full_path = [HpHelper fullPathFromRelativePath:xmlfile];
    NSURL* url = [NSURL fileURLWithPath:full_path];

    NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
    release(parser);

    return autorelease(_cur_chara);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Charactor"])
        _cur_chara = [[HpCharactor alloc]init];
    else if ([elementName isEqualToString:@"plist"])
    {
        NSString* path = [attributeDict objectForKey:@"file"];
        NSArray* components = [path componentsSeparatedByString:@"\\"];
        [_cur_chara.plists addObject:[components objectAtIndex:components.count - 1]];
    }
    else if ([elementName isEqualToString:@"Animation"])
    {
        NSString* name = [attributeDict objectForKey:@"name"];
        if ([_cur_chara.animas objectForKey:name])
            NSLog(@"Duplicated animation id : %@", name);

        NSString* len = [attributeDict objectForKey:@"length"];
        _cur_anima = [[HpAnimation alloc]initWithName:name length:[len intValue]];
        [_cur_chara.animas setObject:_cur_anima forKey:name];
        release(_cur_anima);
    }
    else if ([elementName isEqualToString:@"Node"])
    {
        NSString* name = [attributeDict objectForKey:@"name"];
        _cur_layer = [[HpLayer alloc]initWithName:name];
        [_cur_anima.layers addObject:_cur_layer];
        release(_cur_layer);
    }
    else if ([elementName isEqualToString:@"Key"])
    {
        _cur_keyfrm = [[HpKeyframe alloc] init];
        NSString* type = [attributeDict objectForKey:@"type"];
        if ([type isEqualToString:@"NullKey"])
            _cur_keyfrm.contentType = HpContentType_Null;
        else if ([type isEqualToString:@"ImageKey"])
            _cur_keyfrm.contentType = HpContentType_Image;
        else if ([type isEqualToString:@"AnimaKey"])
            _cur_keyfrm.contentType = HpContentType_Anima;
        _cur_keyfrm.arrayIndex = (int)_cur_layer.keys.count;
        [_cur_layer.keys addObject:_cur_keyfrm];
        release(_cur_keyfrm);
    }
    else if ([elementName isEqualToString:@"Image"])
    {
        _cur_property = CharKeyProperty_Image;
    }
    else if ([elementName isEqualToString:@"Anima"])
    {
        _cur_property = CharKeyProperty_Anima;
    }
    else if ([elementName isEqualToString:@"Time"])
    {
        _cur_property = CharKeyProperty_Time;
    }
    else if ([elementName isEqualToString:@"TimeInher"])
    {
        _cur_property = CharKeyProperty_TimeInher;
    }
    else if ([elementName isEqualToString:@"Center"])
    {
        _cur_property = CharKeyProperty_Center;
    }
    else if ([elementName isEqualToString:@"Scale"])
    {
        _cur_property = CharKeyProperty_Scale;
    }
    else if ([elementName isEqualToString:@"Skew"])
    {
        _cur_property = CharKeyProperty_Skew;
    }
    else if ([elementName isEqualToString:@"Rot"])
    {
        _cur_property = CharKeyProperty_Rot;
    }
    else if ([elementName isEqualToString:@"Trans"])
    {
        _cur_property = CharKeyProperty_Trans;
    }
    else if ([elementName isEqualToString:@"Color"])
    {
        _cur_property = CharKeyProperty_Color;
    }
    else if ([elementName isEqualToString:@"Event"])
    {
        _cur_property = CharKeyProperty_Event;
    }
    else if ([elementName isEqualToString:@"Interps"])
    {
        HpInterpHolder* holder = [[HpInterpHolder alloc] init];
        _cur_keyfrm.interps = holder;
        release(holder);
    }
    else if ([elementName isEqualToString:@"Interp"])
    {
        NSString* type = [attributeDict objectForKey:@"type"];
        id interp;
        if ([type isEqualToString:@"linear"])
            interp = [HpLinearInterp interp];
        else if ([type isEqualToString:@"spline"])
            interp = [HpSplineInterp interp:[attributeDict objectForKey:@"ctrlpts"]];

        NSString* target = [attributeDict objectForKey:@"target"];
        if ([target isEqualToString:@"Center"])
            _cur_keyfrm.interps.centerInterp = interp;
        else if ([target isEqualToString:@"Scale"])
            _cur_keyfrm.interps.scaleInterp = interp;
        else if ([target isEqualToString:@"Skew"])
            _cur_keyfrm.interps.skewInterp = interp;
        else if ([target isEqualToString:@"Rot"])
            _cur_keyfrm.interps.rotInterp = interp;
        else if ([target isEqualToString:@"Trans"])
            _cur_keyfrm.interps.transInterp = interp;
        else if ([target isEqualToString:@"Color"])
            _cur_keyfrm.interps.colorInterp = interp;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    _cur_property = 0;
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    switch (_cur_property)
    {
        case CharKeyProperty_None:
            break;
        case CharKeyProperty_Image:
        case CharKeyProperty_Anima:
            _cur_keyfrm.content = string;
            break;
        case CharKeyProperty_Event:
            _cur_keyfrm.event = string;
            break;
        case CharKeyProperty_Center:
            _cur_keyfrm.center =  CGPointFromString(string);
            break;
        case CharKeyProperty_Color:
        {
            NSScanner* scanner = [[NSScanner alloc] initWithString:string];
            [scanner setScanLocation:1];
            unsigned int value;
            [scanner scanHexInt:&value];
            _cur_keyfrm.color = [UIColor colorWithRed:((value >> 16) & 0xff) / 255.f
                                                green:((value >> 8) & 0xff) / 255.f
                                                 blue:(value & 0xff) / 255.f
                                                alpha:((value >> 24) & 0xff) / 255.f];
            release(scanner);
            break;
        }
        case CharKeyProperty_Rot:
            _cur_keyfrm.rot = [string floatValue];
            break;
        case CharKeyProperty_Scale:
            _cur_keyfrm.scale = CGPointFromString(string);
            break;
        case CharKeyProperty_Skew:
            _cur_keyfrm.skew = CGPointFromString(string);
            break;
        case CharKeyProperty_Time:
            _cur_keyfrm.time = [string intValue];
            break;
        case CharKeyProperty_TimeInher:
            _cur_keyfrm.isTimeInherited = [string boolValue];
        case CharKeyProperty_Trans:
            _cur_keyfrm.trans = CGPointFromString(string);
            break;
        default:
            break;
    }
}
@end
