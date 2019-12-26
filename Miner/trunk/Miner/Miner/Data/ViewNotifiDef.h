//
//  ViewNotifiDef.h
//  testMiner
//
//  Created by zhihua.qian on 14-12-2.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#ifndef testMiner_ViewNotifiDef_h
#define testMiner_ViewNotifiDef_h

// show view
//#define kNotif_View_Show_Hall           @"view.show.hall"       // 显示大厅
//#define kNotif_View_Show_Port           @"view.show.port"       // 显示港口
//#define kNotif_View_Show_Mine           @"view.show.mine"       // 显示挖矿
//#define kNotif_View_Show_Store          @"view.show.store"      // 显示商店
//#define kNotif_View_Show_News           @"view.show.news"       // 显示新闻
//#define kNotif_View_Show_Pack           @"view.show.pack"       // 显示包裹
//#define kNotif_View_Show_Set            @"view.show.set"        // 显示设置

//#define kNotif_View_Show_Equip          @"view.show.equip"              // 显示装备
//#define kNotif_View_Show_EquipInfo      @"view.show.equip.info"         // 显示装备信息
//#define kNotif_View_Show_EquipMain      @"view.show.equip.upgrade.main" // 显示装备主属性升级
//#define kNotif_View_Show_EquipSub       @"view.show.equip.upgrade.sub"  // 显示装备副属性升级

//#define kNotif_View_Show_Bag            @"view.show.bag"        // 显示背包
//#define kNotif_View_Show_Skill          @"view.show.skill"      // 显示技能
//#define kNotif_View_Show_Pet            @"view.show.pet"        // 显示宠物

//#define kNotif_View_Show_Commo          @"view.show.commo"      // 显示通用

// update view
//#define kNotif_View_Hall_Update         @"view.update.hall"         // 更新大厅界面

//#define kNotif_View_Mine_Update         @"view.update.mine"         // 更行挖矿界面

//#define kNotif_View_Equip_Update        @"view.update.equip"        // 更新装备界面
//#define kNotif_View_EquipInfo_Update    @"view.update.equip.info"   // 更行装备信息界面
//#define kNotif_View_EquipMain_Update    @"view.update.equip.main"   // 更新装备主属性界面
//#define kNotif_View_EquipSub_Update     @"view.update.equip.sub"    // 更新装备副属性界面

//#define kNotif_View_Bag_Update          @"view.update.bag"          // 更新背包界面
//#define kNotif_View_Skill_Update        @"view.update.skill"        // 更新技能界面
//#define kNotif_View_Pet_Update          @"view.update.pet"          // 更新宠物界面
//#define kNotif_View_Common_Update       @"view.update.common"       // 更新通用界面

// view events
#define kNotif_View_Mine_Battle_Anima   @"view.update.anima"        // 更新战斗动画
#define kNotif_View_Mine_Battle_Update  @"view.update.battle"       // 更新战斗log
#define kNotif_View_Mine_Battle_Next    @"view.update.next"         // 更新战斗log中的等待状态

#define kNotif_View_Common_Add          @"view.add.commo"                   // 给通用界面添加东西
#define kNotif_View_Common_Substract    @"view.substract.commo"             // 给通用界面移除东西
#define kNotif_View_Common_To_EquipMain @"view.event.common.to.equipmain"   // 给主属性界面传递数组对象

// package manager response event
#define kNotif_View_EquipUnload         @"view.equip.unload"        // 通知EquipInfoView关闭，更新EquipView
#define kNotif_View_EquipChange         @"view.equip.change"        // 通知CommonView关闭，更新EquipView
#define kNotif_View_EquipSell           @"view.equip.sell"          // 通知EquipInfoView关闭，更新BagView
#endif
