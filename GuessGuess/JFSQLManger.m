//
//  JFSQLManger.m
//  ParseForSqlite
//
//  Created by ran on 14-2-24.
//  Copyright (c) 2014年 com.lelechat.chengyuwar. All rights reserved.
//

#import "JFSQLManger.h"
#import "SQLOperation.h"
#import "JFPuzzleModel.h"
@implementation JFSQLManger

+(void)createTable
{
    [[SQLOperation sharedSQLOperation] createTable];
}

+(void)closeDB
{
    [SQLOperation closeOperation];
}

+(void)getDataForUserInfoFromDB:(JFLocalPlayer*)localPlayer
{
    NSMutableArray  *array = [[SQLOperation sharedSQLOperation] querySomeUserInfo:[localPlayer.userID intValue]];
    if ([array count])
    {
        NSDictionary  *dicInfo = [array objectAtIndex:0];
        localPlayer.goldNumber = [[dicInfo valueForKey:@"goldNumber"] intValue];
        localPlayer.lastLevel = [[dicInfo valueForKey:@"lastAnswerIndex"] intValue];
    }else
    {
        DLOG(@"getDataForUserInfoFromDB has no user Info");
        
        [JFSQLManger UpdateUserInfoToDB:localPlayer];
    }
}


+(void)updateUserGoldNumberToDB:(int)goldNumber playerID:(int)userID
{
    [[SQLOperation sharedSQLOperation] updateUserGoldNumber:goldNumber byuserID:userID];
}

+(void)updateUserLevelNumberToDB:(int)lastAnswerNumber playerID:(int)userID
{
    [[SQLOperation sharedSQLOperation] updateUserLastAnswerLevel:lastAnswerNumber byuserID:userID];
}

+(void)resetNormalLevelInfo
{
    
    
   JFLocalPlayer *player = [JFLocalPlayer shareInstance];
    player.lastLevel = 1;
    NSMutableArray  *array = [[SQLOperation sharedSQLOperation] querySomeUserInfo:player.userID.intValue];
    if ([array count])
    {
        [[SQLOperation sharedSQLOperation] updateUserLastAnswerLevel:player.lastLevel goldNumber:player.goldNumber byuserID:[player.userID intValue]];
    }else
    {
        [[SQLOperation sharedSQLOperation] insertUserInfo:[player.userID intValue] GoldNumber:player.goldNumber LasterAnswerIndex:player.lastLevel];
    }
    
    [[SQLOperation sharedSQLOperation] setAllPuzzleIndexAsNumber:-1];
}
+(void)UpdateUserInfoToDB:(JFLocalPlayer*)player
{
    NSMutableArray  *array = [[SQLOperation sharedSQLOperation] querySomeUserInfo:player.userID.intValue];
    if ([array count])
    {
        [[SQLOperation sharedSQLOperation] updateUserLastAnswerLevel:player.lastLevel goldNumber:player.goldNumber byuserID:[player.userID intValue]];
    }else
    {
        [[SQLOperation sharedSQLOperation] insertUserInfo:[player.userID intValue] GoldNumber:player.goldNumber LasterAnswerIndex:player.lastLevel];
    }
}

+(void)insertToSql:(NSString*)strQuestion answer:(NSString*)strAnswer maintype:(int)mainType subType:(int)subType levelType:(int)leveltype  index:(int)index  typeString:(NSString*)typeString isAnswer:(int)isAnswer isUnlock:(int)isUnlock
{
    
   [[SQLOperation sharedSQLOperation] insertPuzzleTabel:strQuestion Answer:strAnswer mainType:mainType subType:subType TextType:typeString puzzleIndex:index levelType:leveltype isAnswer:isAnswer isUnlock:isUnlock];
}



+(void)updateUserLevelNumberToDB:(int)lastlevel player:(JFLocalPlayer*)player
{
     player.lastLevel = lastlevel;
     [[SQLOperation sharedSQLOperation] updateUserLastAnswerLevel:lastlevel goldNumber:player.goldNumber byuserID:[player.userID intValue]];
}



+(int)getMaxIndexFromTablePuzzleTable
{
    return [[SQLOperation sharedSQLOperation] getMaxIndexINTablePUZZLEINFO];
}


+(BOOL)isHasSameQuestion:(NSString*)strQuestion
{
    return [[SQLOperation sharedSQLOperation] getIsHasSameQuestion:strQuestion];
}


+(NSMutableArray*)getAllPuzzleInfoFromDB
{
    
    NSMutableArray  *arrayPuzzles = [[SQLOperation sharedSQLOperation] queryAllPuzzleInfo];
    NSMutableArray  *arrayreturn = [NSMutableArray array];
    for (NSDictionary  *dicinfo in arrayPuzzles)
    {
        // NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:question,@"question",answer,@"answer",@(mainType),@"mainType",@(subType),@"subType",textType,@"textType",@(index),@"index",@(leveltype),@"leveltype",@(isAnswer),@"isAnswer",@(isUnlock),@"isUnlock",nil];
        
        
        JFPuzzleModel  *model = [[JFPuzzleModel alloc] init];
        model.puzzleQuestion = [dicinfo valueForKey:@"question"];
        model.puzzleAnswer = [dicinfo valueForKey:@"answer"];
        model.puzzlesubTypeString = [dicinfo valueForKey:@"textType"];
        model.mainType = [[dicinfo valueForKey:@"mainType"] intValue];
        model.subType = [[dicinfo valueForKey:@"subType"] intValue];
        model.leveltype = [[dicinfo valueForKey:@"leveltype"] intValue];
        model.levelIndex = [[dicinfo valueForKey:@"index"] intValue];
        model.isUnlock = [[dicinfo valueForKey:@"isUnlock"] boolValue];
        model.isAnswered = [[dicinfo valueForKey:@"isAnswer"] boolValue];
        [arrayreturn addObject:model];
        [model release];
    
    }
    return arrayreturn;
}

+(NSMutableArray*)getAllUnAnsweredPuzzleInfoFromDB
{
    
    NSMutableArray  *arrayPuzzles = [[SQLOperation sharedSQLOperation] queryAllPuzzleInfo];
    NSMutableArray  *arrayreturn = [NSMutableArray array];
    for (NSDictionary  *dicinfo in arrayPuzzles)
    {
        // NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:question,@"question",answer,@"answer",@(mainType),@"mainType",@(subType),@"subType",textType,@"textType",@(index),@"index",@(leveltype),@"leveltype",@(isAnswer),@"isAnswer",@(isUnlock),@"isUnlock",nil];
        
        
        JFPuzzleModel  *model = [[JFPuzzleModel alloc] init];
        model.isAnswered = [[dicinfo valueForKey:@"isAnswer"] boolValue];
        
        if (model.isAnswered)
        {
            [model release];
            continue;
        }
        model.puzzleQuestion = [dicinfo valueForKey:@"question"];
        model.puzzleAnswer = [dicinfo valueForKey:@"answer"];
        model.puzzlesubTypeString = [dicinfo valueForKey:@"textType"];
        model.mainType = [[dicinfo valueForKey:@"mainType"] intValue];
        model.subType = [[dicinfo valueForKey:@"subType"] intValue];
        model.leveltype = [[dicinfo valueForKey:@"leveltype"] intValue];
        model.levelIndex = [[dicinfo valueForKey:@"index"] intValue];
        model.isUnlock = [[dicinfo valueForKey:@"isUnlock"] boolValue];
       
        [arrayreturn addObject:model];
        [model release];
        
    }
    return arrayreturn;
}
+(NSMutableArray*)getAllUnAnsweredPuzzleInfoFromDBByIndex:(int)levelIndex
{
    
    NSMutableArray  *arrayPuzzles = [[SQLOperation sharedSQLOperation] queryPuzzleInfoByLevelIndex:levelIndex];
    NSMutableArray  *arrayreturn = [NSMutableArray array];
    for (NSDictionary  *dicinfo in arrayPuzzles)
    {
        // NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:question,@"question",answer,@"answer",@(mainType),@"mainType",@(subType),@"subType",textType,@"textType",@(index),@"index",@(leveltype),@"leveltype",@(isAnswer),@"isAnswer",@(isUnlock),@"isUnlock",nil];
        
        
        JFPuzzleModel  *model = [[JFPuzzleModel alloc] init];
        model.isAnswered = [[dicinfo valueForKey:@"isAnswer"] boolValue];
        
        if (model.isAnswered)
        {
            [model release];
            continue;
        }
        model.puzzleQuestion = [dicinfo valueForKey:@"question"];
        model.puzzleAnswer = [dicinfo valueForKey:@"answer"];
        model.puzzlesubTypeString = [dicinfo valueForKey:@"textType"];
        model.mainType = [[dicinfo valueForKey:@"mainType"] intValue];
        model.subType = [[dicinfo valueForKey:@"subType"] intValue];
        model.leveltype = [[dicinfo valueForKey:@"leveltype"] intValue];
        model.levelIndex = [[dicinfo valueForKey:@"index"] intValue];
        model.isUnlock = [[dicinfo valueForKey:@"isUnlock"] boolValue];
        
        [arrayreturn addObject:model];
        [model release];
        
    }
    return arrayreturn;
}

+(void)setLevelAnswerAndUnlocked:(int)level
{
    [[SQLOperation sharedSQLOperation] updateIsUnlock:1 IsAnswered:1 byLevel:level];
}
+(void)setLevelUnlocked:(int)level
{
    [[SQLOperation sharedSQLOperation] updateIsUnlock:1 byLevel:level];
}

+(id)getOnePuzzleModelByLevel:(int)level
{
    JFPuzzleModel   *model =  nil;
    NSMutableArray *arrayModel = [JFSQLManger getAllUnAnsweredPuzzleInfoFromDBByIndex:level];
    if ([arrayModel count])
    {
        model = [arrayModel firstObject];
    }else
    {
        NSMutableArray  *array = [JFSQLManger getAllUnAnsweredPuzzleInfoFromDB];
        
        if ([array count])
        {
            srandom((unsigned)(time(NULL)+[array count]));
            long  index = random()%[array count];
            model = [array objectAtIndex:index];
            model.levelIndex = level;
            
            [[SQLOperation sharedSQLOperation] UpdateLevel:model.levelIndex byAnswer:model.puzzleAnswer andQuestion:model.puzzleQuestion];
        }
    }
    return model;
}


+(void)UpdateLevelIndex:(int)level byNowindex:(int)nowindex
{
    [[SQLOperation sharedSQLOperation] UpdateLevelIndex:level byNowindex:nowindex];
}
@end
