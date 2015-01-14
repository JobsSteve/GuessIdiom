//
//  SQLOperation.h
//  I366_V1_4
//
//  操作信息记录中最后一条记录的数据库表格
//
//  Created by  on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"




@interface SQLOperation : NSObject
{
    sqlite3 *database;
    
    //    FMDatabase *db;
    
    FMDatabaseQueue *_dbQueue;
}

@property(nonatomic, retain) FMDatabaseQueue *dbQueue;

+ (SQLOperation *)sharedSQLOperation;
+ (void)closeOperation;
- (void)openDatabase;
- (void)closeDatabase;

//信息表
-(void)createTable;




//
-(void)updateUserLastAnswerLevel:(int)lasterAnswerIndex goldNumber:(int)goldNumber byuserID:(int)userID;
-(void)updateUserLastAnswerLevel:(int)lasterAnswerIndex byuserID:(int)userID;
-(void)updateUserGoldNumber:(int)goldNumber byuserID:(int)userID;
- (NSMutableArray *)querySomeUserInfo:(int)userID;
- (NSMutableArray *)queryAllUserInfo;
-(void)insertUserInfo:(int)userID GoldNumber:(int)goldNumber LasterAnswerIndex:(int)lastAnswerindex;

//

-(void)insertPuzzleTabel:(NSString*)strQuestion Answer:(NSString*)strAnswer mainType:(int)mainType subType:(int)subType TextType:(NSString*)strTextType puzzleIndex:(int)index levelType:(int)leveltype isAnswer:(int)isAnswer isUnlock:(int)isUnlock;
-(int)getMaxIndexINTablePUZZLEINFO;
-(BOOL)getIsHasSameQuestion:(NSString*)strQuestion;
- (NSMutableArray *)queryAllPuzzleInfo;
-(NSMutableArray*)queryPuzzleInfoByLevelIndex:(int)index;
- (void)createUserInfoTabel;


//
-(void)setAllPuzzleIndexAsNumber:(int)index;
-(void)updateIsUnlock:(int)isUnlocked IsAnswered:(int)isAnswer byLevel:(int)levelIndex;
-(void)updateIsUnlock:(int)isUnlocked byLevel:(int)levelIndex;
-(void)updateIsAnswer:(int)isAnswer byLevel:(int)levelIndex;
-(void)UpdateLevel:(int)level byAnswer:(NSString*)strAnswer andQuestion:(NSString*)strQuestion;
-(void)UpdateLevelIndex:(int)level byNowindex:(int)nowindex;

@end