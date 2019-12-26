//
//  HaypiTranslator.h
//  HaypiFramework
//
//  Created by jim kaden on 14-8-27.
//  Copyright (c) 2014年 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "net.h"

@class HT_TextGroup;
@protocol HT_TranslatorDelegate
-(void)translateDidFinished:(HT_TextGroup*)group;
@end

@interface HT_TextGroup : NSObject
@property (assign) int textID;
@property (copy) NSString* src;
@property (copy) NSString* target;
@property (copy) NSString* srcLanguange;
@property (copy) NSString* targetLanguage;

#ifdef OBJC_ARC_ENABLED
@property (strong) NSObject<HT_TranslatorDelegate>* delegate;
#else
@property (retain) NSObject<HT_TranslatorDelegate>* delegate;
#endif

@end

@interface HaypiTranslator : NSObject
+(void)translate:(int)textID text:(NSString*)text delegate:(NSObject<HT_TranslatorDelegate>*) delegate;
@end
