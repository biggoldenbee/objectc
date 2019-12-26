//
//  BattleLogMessageCell.m
//  Miner
//
//  Created by jim kaden on 14/12/25.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BattleLogMessageCell.h"

@implementation BattleLogMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupMessage:(NSAttributedString*)string
{
    if ( self.labelMessage.font != nil )
    {
        NSMutableParagraphStyle* ps = [[NSMutableParagraphStyle alloc] init];
        ps.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attrsDictionary = @{
//                                          NSFontAttributeName : self.labelMessage.font,
                                          NSParagraphStyleAttributeName : ps,
                                          };
        
        NSMutableAttributedString* str = [string mutableCopy];
        [str addAttributes:attrsDictionary range:NSMakeRange(0, [str length])];
        string = str;
    }
    
    UILabel* label = (UILabel*)[self.contentView viewWithTag:1];
    if ( label == nil )
    {
        label = [[UILabel alloc] initWithFrame:self.labelMessage.frame];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = self.labelMessage.font;
        label.tag = 1;
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
    }
    CGRect rectFrame = self.frame;
    label.attributedText = string;
    CGRect msgFrame = self.labelMessage.frame;
    CGSize size = [self calcTextSize:string width:msgFrame.size.width];
    if ( label.frame.size.height < size.height )
    {
        CGRect parentFrame = rectFrame;
        parentFrame.size.height += size.height - msgFrame.size.height;
        msgFrame.size.height = ceil(size.height);
        self.frame = parentFrame;
        label.frame = msgFrame;
    }
    [self setupBackground];
    self.cellHeight = self.frame.size.height ;
}

@end


