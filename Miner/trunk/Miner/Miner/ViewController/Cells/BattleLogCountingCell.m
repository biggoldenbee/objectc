//
//  BattleLogCountingCell.m
//  Miner
//
//  Created by jim kaden on 14/12/25.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BattleLogCountingCell.h"
#import "StringConfig.h"
@implementation BattleLogCounting
-(void)setOriginalTimer:(int)originalTimer
{
    _time = originalTimer;
    _originalTimer = originalTimer;
}

-(void)countDown
{
    _time --;
}

-(void)start
{}

-(bool)validate;
{
    return _time >= 0;
}
-(int)time
{
    return _time;
}

@end

@implementation BattleLogCountingCell

-(void)setupMessage:(NSAttributedString*)str
{
    if ( self.labelMessage.font != nil )
    {
        NSMutableParagraphStyle* ps = [[NSMutableParagraphStyle alloc] init];
        ps.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attrsDictionary = @{
                                          NSFontAttributeName : self.labelMessage.font,
                                          NSParagraphStyleAttributeName : ps,
                                          };
        
        NSMutableAttributedString* string = [str mutableCopy];
        [string addAttributes:attrsDictionary range:NSMakeRange(0, [str length])];
        str = string;
    }

    UILabel* label = (UILabel*)[self.contentView viewWithTag:1];
    if ( label == nil )
    {
        label = [[UILabel alloc] initWithFrame:self.labelMessage.frame];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setNumberOfLines:0];
        [label setFont:self.labelMessage.font];
        [label setTag:1];
        [label setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:label];
        
        _rectMessage = self.frame;
    }
    
    label.attributedText = str;
    CGRect msgFrame = self.labelMessage.frame;
    CGSize size = [self calcTextSize:str width:msgFrame.size.width];
    //NSLog(@"width=%.1f, height=%.1f, msgFrame(%.1f, %.1f)", size.width, size.height, msgFrame.size.width, msgFrame.size.height);
    if ( label.frame.size.height < size.height )
    {
        CGRect parentFrame = _rectMessage;
        parentFrame.size.height += size.height - msgFrame.size.height;
        msgFrame.size.height = ceil(size.height);
        msgFrame.size.width = size.width;
        self.frame = parentFrame;
        label.frame = msgFrame;
    }
    [self setupBackground];
    self.cellHeight = self.frame.size.height ;
}

-(void)refreshMessage:(BattleLogCounting*)blc
{
    if ( [blc time] < 0 )
        return;
    NSString* waitingFormat = [[StringConfig share] getLocalLanguage:@"battlog_wait_next"];
    
    NSString *tempString = [waitingFormat stringByReplacingOccurrencesOfString:@"{13}" withString:[NSString stringWithFormat:@"%d",[blc time]]];
    NSAttributedString *timeString = [AttributeString stringWithString:tempString mode:BML_Normal];
    
    [self setupMessage:timeString];
}

-(void)layoutSubviews
{
    
}
@end
