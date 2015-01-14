//
//  JFLocalPlayer.h
//  GuessImageWar
//
//  Created by ran on 13-12-11.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFGameCenterManger.h"
//#import "JFPlayAniManger.h"
@interface JFLocalPlayer : NSObject<NSCoding>
{
    
}

@property(nonatomic,copy)NSString  *userID;
@property(nonatomic)int        goldNumber;
@property(nonatomic,retain)NSDictionary *GamePlayerInfo;
@property(nonatomic,getter = getConloginDays)int   conloginDays;
@property(nonatomic)int   winNumber;
@property(nonatomic)int   loseNumber;
@property(nonatomic)int   maxConWinNumber;
@property(nonatomic)int   score;
@property(nonatomic)int   lastLevel;
@property(nonatomic,copy)NSString       *nickName;
@property(nonatomic)BOOL  isPayedUser;


+(void)storeConLoginDays:(int)conLoginDays;
+(id)shareInstance;
+(void)addgoldNumber:(int)number;
+(void)addgoldNumberWithNoAudio:(int)number;
+(void)deletegoldNumber:(int)number;
+(void)updateUserLastLevel:(int)level;
+(BOOL)storeUserData;


+(void)resetUserInfo;

@end
