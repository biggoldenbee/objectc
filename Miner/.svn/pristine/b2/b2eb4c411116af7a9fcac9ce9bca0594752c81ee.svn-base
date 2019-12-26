//
//  BattleLogActionCell.m
//  Miner
//
//  Created by jim kaden on 14/12/25.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BattleLogActionCell.h"
#import "AttributeString.h"
#import "GameUtility.h"

@implementation BattleLogActionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupAction:(BattleAction*)action
{
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc]init];
    int i = 1;
    for (BattleSubAction* sa in action.subActions )
    {
        AttributeString* attri = [[AttributeString alloc]initWithSubAction:sa];
        if ( attri.attrString != nil )
        {
            [string appendAttributedString:attri.attrString];
            if ( i < action.subActions.count )
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] ];
        }
        i ++;
    }
    _action = action;
    UILabel* label = (UILabel*)[self.contentView viewWithTag:1];
    if ( label == nil )
    {
        CGRect f = self.labelMessage.frame;
        f.size.width += widthDelta;
        label = [[UILabel alloc] initWithFrame:f];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setNumberOfLines:0];
        [label setFont:self.labelMessage.font];
        [label setTag:1];
        [label setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:label];
        
    }
    
    UIImageView* imageView = (UIImageView*)[self.contentView viewWithTag:2];
    if ( imageView == nil )
    {
        imageView = [[UIImageView alloc] initWithFrame:self.imageBanner.frame];
        imageView.tag = 2;
        imageView.backgroundColor = [UIColor clearColor];
        NSString* colorImage = [NSString stringWithFormat:@"mine_color_%d", (rand() % 3 + 1) ];
        imageView.image = [GameUtility imageNamed:colorImage];
        [self.contentView addSubview:imageView];
    }

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
    
    CGRect rectFrame = self.frame;
    label.attributedText = string;
    CGRect msgFrame = label.frame;
    CGRect imageFrame = self.imageBanner.frame;
    CGSize size = [self calcTextSize:string width:msgFrame.size.width];
    if ( label.frame.size.height < size.height )
    {
        CGRect parentFrame = rectFrame;
        parentFrame.size.height += size.height - msgFrame.size.height;
        imageFrame.size.height += size.height - msgFrame.size.height;
        
        msgFrame.size.height = ceil(size.height);
        msgFrame.size.width = size.width;
        self.frame = parentFrame;
        label.frame = msgFrame;
        imageView.frame = imageFrame;
        
    }

    [self setupBackground];
    
    self.cellHeight = self.frame.size.height;
}

@end
