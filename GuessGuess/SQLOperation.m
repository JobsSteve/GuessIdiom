//
//  SQLOperation.m
//  I366_V1_4
//
//  Created by  on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SQLOperation.h"
#import "UtilitiesFunction.h"
#define kDatabaseName @"puzzleInfo.db"

@implementation SQLOperation
@synthesize dbQueue = _dbQueue;

static SQLOperation *operation = nil;

- (NSString *)databaseFilePath
{
    
    
    return [UtilitiesFunction stroreDBPathInDoc];
    NSString  *bundPath = [[NSBundle mainBundle] bundlePath];
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSString *documentsDirectory = [paths objectAtIndex:0];
    
	return [bundPath stringByAppendingPathComponent:kDatabaseName];
}

- (void)openDatabase
{
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self databaseFilePath]];
}

- (void)closeDatabase
{
    
}

- (id)init
{
    if (operation) {
        return operation;
    }else {
        
        self = [super init];
        
        if (self) {
            
        }
        
        return self;
    }
    
}

+ (SQLOperation *)sharedSQLOperation
{
    if (!operation)
    {
        operation = [[SQLOperation alloc] init];
        [operation openDatabase];
    }
    
    return operation;
}

+ (void)closeOperation
{
    if (operation) {
        [operation closeDatabase];
        [operation dealloc];
        operation = nil;
    }
}

- (void)dealloc
{
    database = NULL;
    self.dbQueue = nil;
    
    [super dealloc];
}


- (void)createTable
{
    [self createPuzzleTabel];
    [self createUserInfoTabel];
  
}
#pragma mark user info table


- (void)createUserInfoTabel
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"createUserInfoTabel  open fail");
         }
         NSString *createSQL = @"CREATE TABLE IF NOT EXISTS USERINFO(ID INTEGER PRIMARY KEY,USERID INT,GOLDNUMBER INT,LASTANSWERINDEX INT)";
         
         if (![db executeUpdate:createSQL])
         {
             DLOG(@"createUserInfoTabel fail:%@",createSQL);
         };
         if (![db close])
         {
             
             DLOG(@"createUserInfoTabel  close fail");
         }
         
         
     }];
}
-(void)insertUserInfo:(int)userID GoldNumber:(int)goldNumber LasterAnswerIndex:(int)lastAnswerindex
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"insertUserInfo  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into USERINFO(ID,USERID, GOLDNUMBER, LASTANSWERINDEX) values(NULL,%d,%d,%d)",userID,goldNumber,lastAnswerindex];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"insertUserInfo:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"insertUserInfo  close fail");
        }
        
    }];
    
}

- (NSMutableArray *)queryAllUserInfo
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select * from USERINFO"];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            int userID = [rs intForColumnIndex:1];
            int goldNumber = [rs intForColumnIndex:2];
            int lastAnswerIndex = [rs intForColumnIndex:3];
            
            
            
            
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(userID),@"userID",@(goldNumber),@"goldNumber",@(lastAnswerIndex),@"lastAnswerIndex",nil];
            [array addObject:infoDic];
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return array;
}


- (NSMutableArray *)querySomeUserInfo:(int)userID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select * from USERINFO where userid=%d",userID];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            int userID = [rs intForColumnIndex:1];
            int goldNumber = [rs intForColumnIndex:2];
            int lastAnswerIndex = [rs intForColumnIndex:3];
            
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(userID),@"userID",@(goldNumber),@"goldNumber",@(lastAnswerIndex),@"lastAnswerIndex",nil];
            [array addObject:infoDic];
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return array;
}

-(void)updateUserGoldNumber:(int)goldNumber byuserID:(int)userID
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"updateUserGoldNumber  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"update USERINFO set goldNumber=%d where userid=%d",goldNumber,userID];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"updateUserGoldNumber:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"updateUserGoldNumber  close fail");
        }
        
    }];
    
}
-(void)updateUserLastAnswerLevel:(int)lasterAnswerIndex byuserID:(int)userID
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"updateUserLastAnswerLevel  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"update USERINFO set LASTANSWERINDEX=%d where userid=%d",lasterAnswerIndex,userID];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"updateUserLastAnswerLevel:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"updateUserLastAnswerLevel  close fail");
        }
        
    }];
    
}
-(void)updateUserLastAnswerLevel:(int)lasterAnswerIndex goldNumber:(int)goldNumber byuserID:(int)userID
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"updateUserLastAnswerLevel  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"update USERINFO set LASTANSWERINDEX=%d,goldnumber=%d where userid=%d",lasterAnswerIndex,goldNumber,userID];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"updateUserLastAnswerLevel:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"updateUserLastAnswerLevel  close fail");
        }
        
    }];
    
}

#pragma mark puzzles

- (void)createPuzzleTabel
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"createPuzzleTabel  open fail");
         }
         
         //
         NSString *createSQL = @"CREATE TABLE IF NOT EXISTS PUZZLEINFO(ID INTEGER PRIMARY KEY, QUESTION TEXT,ANSWER TEXT,PUZZLEMAINTYPE INT,PUZZLESUBTYPE INT,PUZZLETEXTTYPE TEXT,PUZZLEINDEX INT,LEVELTYPE INT,ISANSWER INT);";
         
         if (![db executeUpdate:createSQL])
         {
             DLOG(@"createPuzzleTabel fail:%@",createSQL);
         };
         NSString   *strAlertTable = @"ALTER TABLE PUZZLEINFO ADD isunlock INT;";
         if (![db executeUpdate:strAlertTable])
         {
             DLOG(@"createPuzzleTabel fail:%@",strAlertTable);
         };
         
         if (![db close])
         {
             
             DLOG(@"createPuzzleTabel  close fail");
         }
         
         
     }];
}

-(void)insertPuzzleTabel:(NSString*)strQuestion Answer:(NSString*)strAnswer mainType:(int)mainType subType:(int)subType TextType:(NSString*)strTextType puzzleIndex:(int)index levelType:(int)leveltype isAnswer:(int)isAnswer isUnlock:(int)isUnlock
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"insertPuzzleTabel  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into PUZZLEINFO(QUESTION, ANSWER, PUZZLEMAINTYPE, PUZZLESUBTYPE, PUZZLETEXTTYPE, PUZZLEINDEX,LEVELTYPE,ISANSWER,ISUNLOCK) values('%@','%@','%d', '%d', '%@',%d,%d,%d,%d);",strQuestion,strAnswer,mainType,subType,strTextType,index,leveltype,isAnswer,isUnlock];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"executeUpdate:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"insertToUSERINFO  close fail");
        }
        
    }];
    
}


-(void)UpdateLevel:(int)level byAnswer:(NSString*)strAnswer andQuestion:(NSString*)strQuestion
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"UpdateLevel  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"Update puzzleinfo set puzzleindex=%d where QUESTION='%@' and ANSWER='%@'",level,strQuestion,strAnswer];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"executeUpdate:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"UpdateLevel  close fail");
        }
        
    }];
    
}

-(void)UpdateLevelIndex:(int)level byNowindex:(int)nowindex
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"UpdateLevelIndex  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"Update puzzleinfo set puzzleindex=%d where puzzleindex=%d",level,nowindex];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"UpdateLevelIndex:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"UpdateLevelIndex  close fail");
        }
        
    }];
    
}

-(void)setAllPuzzleIndexAsNumber:(int)index
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"setAllPuzzleIndexAsNumber  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"update PUzzleInfo set PuzzleIndex=%d where puzzleindex>0",index];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"setAllPuzzleIndexAsNumber:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"setAllPuzzleIndexAsNumber  close fail");
        }
        
    }];
    
}





-(int)getMaxIndexINTablePUZZLEINFO
{


    __block int maxIndex = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select MAX(PUZZLEINDEX) from PUZZLEINFO"];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
   
            maxIndex = [rs intForColumnIndex:0];
         
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return maxIndex;

}


-(BOOL)getIsHasSameQuestion:(NSString*)strQuestion
{
    
    
    __block int maxIndex = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select count from PUZZLEINFO where QUESTION='%@'",strQuestion];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            
            maxIndex = [rs intForColumnIndex:0];
            
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return maxIndex;
}



- (NSMutableArray *)queryAllPuzzleInfo
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select * from PUZZLEINFO"];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
        while (rs.next)
        {
            NSString    *question = [rs stringForColumnIndex:1];
            NSString    *answer = [rs stringForColumnIndex:2];
            int mainType = [rs intForColumnIndex:3];
            int subType = [rs intForColumnIndex:4];
            NSString    *textType = [rs stringForColumnIndex:5];
            int index = [rs intForColumnIndex:6];
            int leveltype = [rs intForColumnIndex:7];
            int isAnswer  = [rs intForColumnIndex:8];
            int isUnlock = [rs intForColumnIndex:9];
            

            
            
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:question,@"question",answer,@"answer",@(mainType),@"mainType",@(subType),@"subType",textType,@"textType",@(index),@"index",@(leveltype),@"leveltype",@(isAnswer),@"isAnswer",@(isUnlock),@"isUnlock",nil];
            [array addObject:infoDic];
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return array;
}


-(NSMutableArray*)queryPuzzleInfoByLevelIndex:(int)index
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select * from PUZZLEINFO where PUZZLEINDEX=%d",index];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            NSString    *question = [rs stringForColumnIndex:1];
            NSString    *answer = [rs stringForColumnIndex:2];
            int mainType = [rs intForColumnIndex:3];
            int subType = [rs intForColumnIndex:4];
            NSString    *textType = [rs stringForColumnIndex:5];
            int index = [rs intForColumnIndex:6];
            int leveltype = [rs intForColumnIndex:7];
            int isAnswer  = [rs intForColumnIndex:8];
            int isUnlock = [rs intForColumnIndex:9];
            
            
            
            
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:question,@"question",answer,@"answer",@(mainType),@"mainType",@(subType),@"subType",textType,@"textType",@(index),@"index",@(leveltype),@"leveltype",@(isAnswer),@"isAnswer",@(isUnlock),@"isUnlock",nil];
            [array addObject:infoDic];
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return array;
}


-(void)updateIsUnlock:(int)isUnlocked IsAnswered:(int)isAnswer byLevel:(int)levelIndex
{
    
    
    if (levelIndex <= 0)
    {
        DLOG(@"updateIsUnlock return because levelindex:%d",levelIndex);
        return;
    }
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"updateIsUnlock  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"update PuzzleInfo set ISUNLOCK=%d,ISANSWER=%d where puzzleindex=%d",isUnlocked,isAnswer,levelIndex];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"updateIsUnlock:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"updateIsUnlock  close fail");
        }
        
    }];
    
}
-(void)updateIsUnlock:(int)isUnlocked byLevel:(int)levelIndex
{
    
    if (levelIndex <= 0)
    {
        DLOG(@"updateIsUnlock return because levelindex:%d",levelIndex);
        return;
    }
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"updateIsUnlock  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"update PuzzleInfo set ISUNLOCK=%d where puzzleindex=%d",isUnlocked,levelIndex];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"updateIsUnlock:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"updateIsUnlock  close fail");
        }
        
    }];
    
}
-(void)updateIsAnswer:(int)isAnswer byLevel:(int)levelIndex
{
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"updateIsAnswer  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"update PuzzleInfo set isanswer=%d where puzzleindex=%d",isAnswer,levelIndex];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"updateIsAnswer:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"updateIsAnswer  close fail");
        }
        
    }];
    
}






@end