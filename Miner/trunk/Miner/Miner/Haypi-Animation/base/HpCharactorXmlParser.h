//
//  HpCharactorXmlParser.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HpAnimVisitor.h"

@interface HpCharactorXmlParser : NSObject <HpAnimParser>

-(id)parse:(NSString*)xmlfile;

@end
