//
//  JFPropModel.h
//  GuessImageWar
//
//  Created by ran on 13-12-11.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef  enum
{
    JFPropModelTypeTrash = 11,
    JFPropModelTypeTimeMachine = 12,
    JFPropModelTypeIdeaShow = 13,//灵光一闪
    JFPropModelTypeAvoidAnswer = 14,
    JFPropModelTypeExchangeUser = 15,///斗转星移
    JFPropModelTypeShareForHelp = 16,
    JFPropModelTypeTreasureBox = 17,
    JFPropModelTypeDice = 18,
}JFPropModelType;

@interface JFPropModel : NSObject



@property(nonatomic,copy)NSString  *propName;
@property(nonatomic)int propPrice;
@property(nonatomic,copy)NSString  *propImageName;
@property(nonatomic,copy)NSString   *propIncName;
@property(nonatomic,copy)NSString  *actionDescription;
@property(nonatomic)JFPropModelType  modelType;
@property(nonatomic)int useCount;
@property(nonatomic)int remainCount;


-(id)initWithPropType:(JFPropModelType)type;
-(id)initWithPropType:(JFPropModelType)type isRaceMode:(BOOL)isRaceMode;
@end
