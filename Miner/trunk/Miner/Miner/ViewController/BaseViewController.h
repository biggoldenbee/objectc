//
//  BaseViewController.h
//  testMiner
//
//  Created by zhihua.qian on 14-11-21.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToolTipImageView.h"

@interface BaseViewController : UIViewController

@end

/*
 TabBarItemViewController
 需在xib中增加KeyPath
 itemTitle => [title 的多语言Key]
 itemIcon => [image name]
 itemIconSelected => [selected image name]
 */
//@interface TabBarItemViewController : BaseViewController
//
//@property (nonatomic, copy) NSString* itemTitle;            // 标题
//@property (nonatomic, copy) NSString* itemIcon;             // 标题图标
//@property (nonatomic, copy) NSString* itemIconSelected;     // 选中时的标题图标
//
//@end