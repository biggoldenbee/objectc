//
//  BattleAnimationSkillBoard.m
//  Miner
//
//  Created by jim kaden on 15/1/6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BattleAnimationSkillBoard.h"
#import "SkillConfig.h"
#import "StringConfig.h"
#import "GameUtility.h"
#import "AttributeString.h"
@implementation BattleAnimationSkillBoard

+(BattleAnimationSkillBoard*)create:(id)owner skill:(int)skill withLv:(int)lv
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleAnimationSkillBoard" owner:owner options:nil];
    BattleAnimationSkillBoard* view = (BattleAnimationSkillBoard*)[array objectAtIndex:0];
    [view setSkill:skill withLv:lv];
    return view;
}

-(void)setSkill:(int)skill withLv:(int)lv
{
    SkillBase* sb = [[SkillConfig share] getSkillBaseWithTId:[NSNumber numberWithInt:skill] withLevel:[NSNumber numberWithInt:lv]];
    if ( sb == nil )
        return;
    NSString* skillname = [[StringConfig share] getLocalLanguage:sb.skillName];
    self.imageIcon.image = [GameUtility imageNamed:sb.skillIcon];
    self.labelName.stroke = YES;

    NSAttributedString* string = [AttributeString stringWithString:skillname
                                                          fontSize:sb.animaFontSize
                                                          fontBold:YES
                                                   foregroundColor:sb.animaFontColor
                                                       strokeColor:[UIColor blackColor]
                                                        strokeSize:2];
    self.labelName.attributedText = string;


}


@end

@implementation UILabelEx

- (void)drawTextInRect:(CGRect)rect
{
    if ( self.stroke == NO )
        [super drawTextInRect:rect];
    else
    {
        CGSize shadowOffset = self.shadowOffset;
        UIColor *textColor = self.textColor;
        
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(c, self.strokeSize == 0 ? 2 : self.strokeSize );
        CGContextSetLineJoin(c, kCGLineJoinRound);
        
        CGContextSetTextDrawingMode(c, kCGTextStroke);
        self.textColor = self.strokeColor == nil ? [UIColor blackColor] : self.strokeColor;
        [super drawTextInRect:rect];
        
        CGContextSetTextDrawingMode(c, kCGTextFill);
        self.textColor = textColor;
        self.shadowOffset = CGSizeMake(0, 0);
        [super drawTextInRect:rect];
        
        self.shadowOffset = shadowOffset;
    }
}
@end
