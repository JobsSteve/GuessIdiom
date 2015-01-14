


//
//  JFPropModel.m
//  GuessImageWar
//
//  Created by ran on 13-12-11.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFPropModel.h"

@implementation JFPropModel
@synthesize modelType;
@synthesize propName;
@synthesize propPrice;
@synthesize propImageName;
@synthesize actionDescription;
@synthesize useCount;
@synthesize remainCount;
@synthesize propIncName;



-(id)initWithPropType:(JFPropModelType)type
{
    self = [super init];
    if (self)
    {
        
        self.modelType = type;
        switch (self.modelType)
        {
            case JFPropModelTypeTrash:
                self.propName = @"垃圾桶";
                self.actionDescription = @"使用道具随机去掉三个错误文字";
                self.propImageName = @"gameexplain_trash.png";
                self.propIncName = @"trash_prop.png";
                self.propPrice = 20;
                self.useCount = 4;
                self.remainCount = 4;
                break;
            case JFPropModelTypeTimeMachine:
                self.propName = @"时光机";
                self.actionDescription = @"使用道具可增加答题时间";
                self.propImageName = @"gameexplain_timemachine.png";
                self.propIncName = @"timemachine_prop.png";
                self.propPrice = 30;
                self.useCount = 3;
                self.remainCount = 3;
                break;
            case JFPropModelTypeAvoidAnswer:
                self.propName = @"免答金牌";
                self.actionDescription = @"使用道具可免答一道问题（孙大圣专属）";
                self.propImageName = @"gameexplain_avoidanswer.png";
                self.propIncName = @"avoid_answer_prop.png";
                self.propPrice = 150;
                self.useCount = 1;
                self.remainCount = 1;
                break;
            case JFPropModelTypeExchangeUser:
                self.propName = @"斗转星移";
                self.actionDescription = @"使用道具可把问题转给对方（唐小藏专属）";
                self.propImageName = @"gameexplain_trafrom.png";
                self.propIncName = @"douzhuanxinyi_prop.png";
                self.propPrice = 200;
                self.useCount = 1;
                self.remainCount = 1;
                break;
            case JFPropModelTypeIdeaShow:
                self.propName = @"灵光一闪";
                self.actionDescription = @"使用道具随机获取一个文字提示（孙大圣，唐小藏专属）";
                self.propImageName = @"gameexplain_goodidea.png";
                self.propIncName = @"goodidea_prop.png";
                self.propPrice = 50;
                self.useCount = CGFLOAT_MAX;
                self.remainCount = CGFLOAT_MAX;
                break;
            case JFPropModelTypeDice:
                self.propName = @"色子";
                self.actionDescription = @"使用道具随机更换题目";
                self.propImageName = @"gameexplain_goodidea.png";
                self.propIncName = @"dice_prop.png";
                self.propPrice = 10;
                self.useCount = 3;
                self.remainCount = 3;
                break;
            case JFPropModelTypeShareForHelp:
                self.propName = @"分享";
                self.actionDescription = @"分享给好友，小伙伴们一起来支招，还可获得奖励";
                self.propImageName = @"gameexplain_share.png";
                self.propIncName = @"share_prop.png";
                self.propPrice = 20;
                self.useCount = CGFLOAT_MAX;
                self.remainCount = CGFLOAT_MAX;
                break;
            case JFPropModelTypeTreasureBox:
                self.propName = @"宝箱";
                self.actionDescription = @"免费领取金币的宝箱";
                self.propImageName = @"gameexplain_treasexbox.png";
                self.propPrice = 20;
                self.useCount = CGFLOAT_MAX;
                self.remainCount = CGFLOAT_MAX;
                break;
                
            default:
                break;
        }
    }
    return self;
}



-(id)initWithPropType:(JFPropModelType)type isRaceMode:(BOOL)isRaceMode
{
    self = [super init];
    if (self)
    {
        
        self.modelType = type;
        switch (self.modelType)
        {
            case JFPropModelTypeTrash:
                self.propName = @"垃圾桶";
                self.actionDescription = @"使用道具随机去掉三个错误文字";
                self.propImageName = @"gameexplain_trash.png";
                self.propIncName = @"trash_prop.png";
                self.propPrice = 20;
                self.useCount = 4;
                self.remainCount = 4;
                if (isRaceMode)
                {
                    self.useCount = 5;
                    self.remainCount = 5;
                }
                break;
            case JFPropModelTypeTimeMachine:
                self.propName = @"时光机";
                self.actionDescription = @"使用道具可增加答题时间";
                self.propImageName = @"gameexplain_timemachine.png";
                 self.propIncName = @"timemachine_prop.png";
                self.propPrice = 30;
                self.useCount = 3;
                self.remainCount = 3;
                break;
            case JFPropModelTypeAvoidAnswer:
                self.propName = @"免答金牌";
                self.actionDescription = @"使用道具可免答一道问题（孙大圣专属）";
                self.propImageName = @"gameexplain_avoidanswer.png";
                self.propIncName = @"avoid_answer_prop.png";
                self.propPrice = 150;
                self.useCount = 1;
                self.remainCount = 1;
                break;
            case JFPropModelTypeExchangeUser:
                self.propName = @"斗转星移";
                self.actionDescription = @
                "使用道具可把问题转给对方（唐小藏专属）";
                self.propImageName = @"gameexplain_trafrom.png";
                self.propIncName = @"douzhuanxinyi_prop.png";
                self.propPrice = 200;
                self.useCount = 1;
                self.remainCount = 1;
                break;
            case JFPropModelTypeIdeaShow:
                self.propName = @"灵光一闪";
                self.actionDescription = @"使用道具随机获取一个文字提示（孙大圣，唐小藏专属）";
                self.propImageName = @"gameexplain_goodidea.png";
                self.propIncName = @"goodidea_prop.png";
                self.propPrice = 50;
                self.useCount = CGFLOAT_MAX;
                self.remainCount = CGFLOAT_MAX;
                if (isRaceMode)
                {
                    self.useCount = 3;
                    self.remainCount = 3;
                }
                break;
            case JFPropModelTypeShareForHelp:
                self.propName = @"分享";
                self.actionDescription = @"分享给好友，小伙伴们一起来支招，还可获得奖励";
                self.propImageName = @"gameexplain_share.png";
                self.propPrice = 20;
                self.useCount = CGFLOAT_MAX;
                self.remainCount = CGFLOAT_MAX;
                self.propIncName = @"share_prop.png";
                break;
            case JFPropModelTypeTreasureBox:
                self.propName = @"宝箱";
                self.actionDescription = @"免费领取金币的宝箱";
                self.propImageName = @"gameexplain_treasexbox.png";
                self.propPrice = 20;
                self.useCount = CGFLOAT_MAX;
                self.remainCount = CGFLOAT_MAX;
                break;
                
            default:
                break;
        }
    }
    return self;
}

-(void)dealloc
{
    
    self.propImageName = nil;
    self.propName = nil;
    self.actionDescription = nil;
    [super dealloc];
}

@end
