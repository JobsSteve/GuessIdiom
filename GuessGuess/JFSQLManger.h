//
//  JFSQLManger.h
//  ParseForSqlite
//
//  Created by ran on 14-2-24.
//  Copyright (c) 2014年 com.lelechat.chengyuwar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFLocalPlayer.h"

@interface JFSQLManger : NSObject


+(void)createTable;


+(void)getDataForUserInfoFromDB:(JFLocalPlayer*)localPlayer;
+(void)updateUserGoldNumberToDB:(int)goldNumber playerID:(int)userID;
+(void)updateUserLevelNumberToDB:(int)lastAnswerNumber playerID:(int)userID;
+(void)resetNormalLevelInfo;
+(void)UpdateUserInfoToDB:(JFLocalPlayer*)player;


//
+(void)insertToSql:(NSString*)strQuestion answer:(NSString*)strAnswer maintype:(int)mainType subType:(int)subType levelType:(int)leveltype  index:(int)index  typeString:(NSString*)typeString isAnswer:(int)isAnswer isUnlock:(int)isUnlock;
+(int)getMaxIndexFromTablePuzzleTable;
+(BOOL)isHasSameQuestion:(NSString*)strQuestion;
+(void)closeDB;
+(NSMutableArray*)getAllPuzzleInfoFromDB;


+(void)setLevelAnswerAndUnlocked:(int)level;
+(void)setLevelUnlocked:(int)level;
+(void)updateUserLevelNumberToDB:(int)lastlevel player:(JFLocalPlayer*)player;
+(id)getOnePuzzleModelByLevel:(int)level;
+(void)UpdateLevelIndex:(int)level byNowindex:(int)nowindex;

+(NSMutableArray*)getAllUnAnsweredPuzzleInfoFromDB;
@end
