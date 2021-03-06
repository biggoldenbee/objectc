//
//  BriefTextTableViewCell.m
//  Miner
//
//  Created by biggoldenbee on 15/1/8.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BriefTextTableViewCell.h"
#import "GameUtility.h"

@interface BriefTextTableViewCell()

@property (strong, nonatomic) UIImageView *baseLine;

@property (nonatomic, strong) NSArray *theAutoSellPropsColor;
@property (nonatomic, strong) NSArray *theAutoSellPropsColorName;
@property (nonatomic, strong) NSMutableArray* theAutoSellsProps;


@property (nonatomic, assign) CGFloat theCurentHeight;
@property (strong, nonatomic) UITextView *textView;
@end

@implementation BriefTextTableViewCell

-(void)initilizingComponents {
    self.baseLine = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-276-22)/2,5,276,1)];
    self.baseLine.image = [GameUtility imageNamed:@"base_line2.png"];
    [self.contentView addSubview:self.baseLine] ;

    self.theAutoSellPropsColor = [[NSArray alloc] initWithObjects:
                                  [UIColor whiteColor],
                                  [UIColor greenColor],
                                  [UIColor blueColor],
                                  [UIColor purpleColor],
                                  [UIColor orangeColor],
                                  nil];
    
    self.theAutoSellPropsColorName = [[NSArray alloc] initWithObjects:  @"white",
                                      @"blue",
                                      @"green",
                                      @"red",
                                      @"puple",
                                      nil];
    self.theAutoSellsProps = [[NSMutableArray alloc] init];
    self.theCurentHeight = self.frame.size.height;
    // 产生所有的autoSells Label
    for(int i=0; i<5; i++) {
        UILabel *briefAutoSellsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,60,300,15)];
     
        briefAutoSellsLabel.font = [UIFont systemFontOfSize:12] ;
        briefAutoSellsLabel.text = @"Auto sells the white Props x11" ;
        briefAutoSellsLabel.textAlignment = NSTextAlignmentCenter;
        briefAutoSellsLabel.textColor = [self.theAutoSellPropsColor objectAtIndex:i] ;
     
        // 隐藏所有的Label
        [briefAutoSellsLabel setHidden:TRUE] ;
        [self.theAutoSellsProps addObject:briefAutoSellsLabel];
        [self.contentView addSubview:briefAutoSellsLabel];
    }

    UIFont *font = [UIFont systemFontOfSize:14];
    self.textView = [[UITextView alloc] init];
    [self.textView setFont:font];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.textView setScrollEnabled:FALSE];
    [self.textView setEditable:FALSE];
    [self.textView setSelectable:FALSE];
    [self.textView setFrame:CGRectMake(14,10,300,20)];
    [self addSubview:self.textView];
}

- (void)awakeFromNib {
    // Initialization code
   
    // 初次进行初始化操作
    [self initilizingComponents];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)getLines:(NSString *)inStr {
    NSInteger lines = 0;
    
    if ([inStr length]>0) {
        NSMutableArray *strLines = [NSMutableArray array];
        [inStr enumerateLinesUsingBlock: ^(NSString *line, BOOL *stop) {
            [strLines addObject:line];
        }];
        lines = [strLines count] ;
    }
    
    return lines;
    
}

-(void)setTextInfo:(NSString *)inStr autoSells:(NSArray*)autoSells; {

    // 设置view初始的高度为Brief_Component_Y
    CGFloat theViewHeight = 16;
    CGRect rect ;
    
    // 设置所有的autoSells
    for(int i=0; i<5; i++) {
        UILabel *briefAutoSellsLabel = [self.theAutoSellsProps objectAtIndex:i];
        [briefAutoSellsLabel setHidden:TRUE];
        
        if (i<[autoSells count]) {
            NSNumber *sellsCount = [autoSells objectAtIndex:i];
            if ([sellsCount intValue]>0) {
                briefAutoSellsLabel.text = [NSString stringWithFormat:@"Auto sells the %@ Props X%d",
                                            [self.theAutoSellPropsColorName objectAtIndex:i],
                                            [sellsCount intValue]];
                rect = CGRectMake(20,theViewHeight,280,15);
                briefAutoSellsLabel.frame = rect;
                [briefAutoSellsLabel setHidden:FALSE];
                theViewHeight = theViewHeight+15;
                NSLog(@"%@ [%f,%f,%f,%f]\n", briefAutoSellsLabel.text,
                      briefAutoSellsLabel.frame.origin.x,
                      briefAutoSellsLabel.frame.origin.y,
                      briefAutoSellsLabel.frame.size.width,
                      briefAutoSellsLabel.frame.size.height
                      ) ;
            }
        }
    }

    [self.baseLine setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-276-22)/2,theViewHeight+5,276,1)];

    self.theCurentHeight = theViewHeight;
    // 计算文字行数
    NSInteger lines = [self getLines:inStr] ;
    // 设置view的高度
    theViewHeight = 24+lines*14+20 ;
    // 设置textView的高度和显示内容
    [self.textView setFrame:CGRectMake(14,self.theCurentHeight+10,300,theViewHeight)];
    [self.textView setText:inStr] ;
    
//    rect= [self frame];
//    rect.size.height = self.theCurentHeight;
//    [self setFrame:rect];
   
    // 设置最后高度
    self.theCurentHeight = self.theCurentHeight+theViewHeight;
    
    // 设置view的高度
    rect = self.frame;
    rect.size.height = self.theCurentHeight;
    self.frame = rect;
    
    // 保存view的高度到the
    self.theCurentHeight = theViewHeight;
}

@end
