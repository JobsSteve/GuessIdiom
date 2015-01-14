//
//  JFLocalPlayer.m
//  GuessImageWar
//
//  Created by ran on 13-12-11.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFLocalPlayer.h"
#import "JFGameCenterManger.h"
#import "JFSQLManger.h"
#import "iToast.h"
#import "JFAudioPlayerManger.h"


#define    INITGOLDNUMBER              200



@implementation JFLocalPlayer
@synthesize conloginDays;
@synthesize nickName;
@synthesize winNumber;
@synthesize loseNumber;
@synthesize score;
@synthesize maxConWinNumber;
@synthesize lastLevel;
@synthesize userID;
@synthesize goldNumber;
@synthesize GamePlayerInfo;
@synthesize isPayedUser;





+(NSString*)storePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"didididididiididi"];
    /*
     NSError *error = nil;
     
     if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
     [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];*/
    return dataPath;
}

+(BOOL)storeUserData
{
    
    JFLocalPlayer *localplayer = [JFLocalPlayer shareInstance];
    BOOL  bsuc = [NSKeyedArchiver archiveRootObject:localplayer toFile:[JFLocalPlayer storePath]];
    if (!bsuc)
    {
        DLOG(@"storeUserData  fail");
    }
    return bsuc;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super init];
    if (self)
    {

        self.isPayedUser = [aDecoder decodeBoolForKey:@"isPayedUser"];
        self.conloginDays = [aDecoder decodeIntForKey:@"conloginDays"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.winNumber = [aDecoder decodeIntForKey:@"winNumber"];
        self.loseNumber = [aDecoder decodeIntForKey:@"loseNumber"];
        self.score = [aDecoder decodeIntForKey:@"score"];
        self.maxConWinNumber = [aDecoder decodeIntForKey:@"maxConWinNumber"];
        self.lastLevel = [aDecoder decodeIntForKey:@"lastLevel"];
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.goldNumber = [aDecoder decodeIntForKey:@"goldNumber"];
        self.GamePlayerInfo = [aDecoder decodeObjectForKey:@"GamePlayerInfo"];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGameCenterInfo:) name:BNRGamePlayUserInfo object:nil];
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:self.isPayedUser forKey:@"isPayedUser"];
    [aCoder encodeInt:self.conloginDays forKey:@"conloginDays"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeInt:self.winNumber forKey:@"winNumber"];
    [aCoder encodeInt:self.loseNumber forKey:@"loseNumber"];
    [aCoder encodeInt:self.score forKey:@"score"];
    [aCoder encodeInt:self.maxConWinNumber forKey:@"maxConWinNumber"];
    [aCoder encodeInt:self.goldNumber forKey:@"goldNumber"];
    [aCoder encodeInt:self.lastLevel forKey:@"lastLevel"];
    [aCoder encodeObject:self.GamePlayerInfo forKey:@"GamePlayerInfo"];
    
}

+(id)shareInstance
{
    
    static JFLocalPlayer    *localplayer = nil;
    if (!localplayer)
    {
        if (!localplayer)
        {
            localplayer = [[JFLocalPlayer alloc] init];
        }
        [JFSQLManger getDataForUserInfoFromDB:localplayer];
    }
    return localplayer;
    
}


/*
+(id)shareInstance
{
    
    static JFLocalPlayer *localplayer = nil;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         localplayer = [[JFLocalPlayer alloc] init];
          [JFSQLManger getDataForUserInfoFromDB:localplayer];
    });
    return localplayer;
    
}*/
+(void)addgoldNumber:(int)number
{
    JFLocalPlayer *localplayer = [JFLocalPlayer shareInstance];
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeGainGold];
    [localplayer addgoldNumber:number];
    [JFSQLManger updateUserGoldNumberToDB:localplayer.goldNumber
                                 playerID:[localplayer.userID intValue]];
}

+(void)addgoldNumberWithNoAudio:(int)number
{
    JFLocalPlayer *localplayer = [JFLocalPlayer shareInstance];
    [localplayer addgoldNumber:number];
    [JFSQLManger updateUserGoldNumberToDB:localplayer.goldNumber
                                 playerID:[localplayer.userID intValue]];
}
+(void)deletegoldNumber:(int)number
{
    JFLocalPlayer *localplayer = [JFLocalPlayer shareInstance];
    if (number<= 0)
    {
        return;
    }
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeGainGold];
    [localplayer deletegoldNumber:number];
    [JFSQLManger updateUserGoldNumberToDB:localplayer.goldNumber
                                 playerID:[localplayer.userID intValue]];
}


+(void)updateUserLastLevel:(int)level
{
    JFLocalPlayer *localplayer = [JFLocalPlayer shareInstance];
    [localplayer setLastLevel:level];
    [JFSQLManger updateUserLevelNumberToDB:level
                                 playerID:[localplayer.userID intValue]];
    
}


+(void)storeConLoginDays:(int)conLoginDays
{
    JFLocalPlayer *localplayer = [JFLocalPlayer shareInstance];
    [localplayer storeConLoginDays:conLoginDays];
}



+(void)resetUserInfo
{
    JFLocalPlayer *localplayer = [JFLocalPlayer shareInstance];
    [localplayer resetUserInfo];
    

}
-(id)init
{
    self = [super init];
    if (self)
    {
        self.userID = @"1234567890";
        self.nickName  = @"";
        self.GamePlayerInfo = nil;
#if USETESTDATA
        self.goldNumber =   300000;
#else
        self.goldNumber =   INITGOLDNUMBER;
#endif
        self.conloginDays = 1;
        self.isPayedUser = NO;
        self.lastLevel = 1;
      //  [self addTestData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGameCenterInfo:) name:BNRGamePlayUserInfo object:nil];
    }
    return self;
}


-(void)resetUserInfo
{
    self.goldNumber = INITGOLDNUMBER;
    self.lastLevel = 0;
 
    self.conloginDays = 1;
    [self cleanConloginDays];
    
    
     NSUserDefaults  *standUser = [NSUserDefaults standardUserDefaults];
     NSString    *strStoreEnterKey = [NSString stringWithFormat:@"NormalLevelEnter%@",self.userID];
     [standUser removeObjectForKey:strStoreEnterKey];
     NSString    *strStoreFreeKey = [NSString stringWithFormat:@"NormalLevelInfoReward%@",self.userID];
     [standUser removeObjectForKey:strStoreFreeKey];
     NSString    *strStoresharekey = [NSString stringWithFormat:@"LocalShareCount%@",[[JFLocalPlayer shareInstance] userID]];
     [standUser removeObjectForKey:strStoresharekey];
    
    
    
    ///medal store info
    int type = 1000;
    NSString    *strStoreMedalkey1 = [NSString stringWithFormat:@"%d%@medal",type,[[JFLocalPlayer shareInstance] userID]];
    [standUser removeObjectForKey:strStoreMedalkey1];
    type = 1001;
    NSString    *strStoreMedalkey2 = [NSString stringWithFormat:@"%d%@medal",type,[[JFLocalPlayer shareInstance] userID]];
    [standUser removeObjectForKey:strStoreMedalkey2];
    
    type = 1002;
    NSString    *strStoreMedalkey3 = [NSString stringWithFormat:@"%d%@medal",type,[[JFLocalPlayer shareInstance] userID]];
    [standUser removeObjectForKey:strStoreMedalkey3];
    
    type = 1003;
    NSString    *strStoreMedalkey4 = [NSString stringWithFormat:@"%d%@medal",type,[[JFLocalPlayer shareInstance] userID]];
    [standUser removeObjectForKey:strStoreMedalkey4];
    
    NSDictionary *dicInfo = [standUser dictionaryRepresentation];
    for (NSString  *strKey in [dicInfo allKeys])
    {
        if ([strKey rangeOfString:@"NormalLevelInfo"].location != NSNotFound)
        {
            [standUser removeObjectForKey:strKey];
            continue;
        }
    }

    [standUser synchronize];
    [JFSQLManger UpdateUserInfoToDB:self];
    [JFSQLManger resetNormalLevelInfo];
}

-(void)addTestData
{
    self.userID = @"10010";
    self.nickName  = @"12月20日";
    self.GamePlayerInfo = nil;
    self.goldNumber = 999999;
    self.conloginDays = 1;
}
-(void)getGameCenterInfo:(NSNotification*)note
{
    self.GamePlayerInfo = [note userInfo];
    DLOG(@"getGameCenterInfo:%@",note);
}

-(void)addgoldNumber:(int)number
{
    self.goldNumber += number;
}
-(void)deletegoldNumber:(int)number
{
    self.goldNumber -= number;
    if (self.goldNumber < 0)
    {
        self.goldNumber = 0;
    }
}



-(void)cleanConloginDays
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"ConloginDays"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)storeConLoginDays:(int)conLoginDays
{
    if ([self.userID intValue] <= 0)
    {
        DLOG(@"storeConLoginDays  withuserID error:%@ but still store",self.userID);
       // return;
    }
     NSTimeInterval  timer = [[NSDate date] timeIntervalSince1970];
     NSString   *strCondays = [NSString stringWithFormat:@"%d",conLoginDays];
     NSString   *strTimer = [NSString stringWithFormat:@"%f",timer];
    
    
    
    NSDictionary   *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:strTimer,@"LASTGAINGOLDTIMER",strCondays,@"ConLoginDay",nil];
    [[NSUserDefaults standardUserDefaults] setObject:dicInfo forKey:[NSString stringWithFormat:@"ConloginDays"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(int)getConloginDays
{


    NSDictionary  *dicInfo = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"ConloginDays"]];
    if (dicInfo == nil)
    {
        return 1;
    }
    
   
    NSDateFormatter  *dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateFormat:@"YYYYMMDD"];
    
    int lasttimer = [[dicInfo valueForKey:@"LASTGAINGOLDTIMER"] intValue];
    int nowtmer = [[NSDate date] timeIntervalSince1970];
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:lasttimer];
    
    
    NSString   *strNow = [dataFormat stringFromDate:[NSDate date]];
    NSString    *strLast = [dataFormat stringFromDate:date];
    [dataFormat release];
    if ([strNow isEqualToString:strLast])
    {
        return -1;
    }else
    {
        
        if (lasttimer-nowtmer > 60*60*24)
        {
            return 1;
        }
        
        NSString  *strConday = [dicInfo valueForKey:@"ConLoginDay"];
        if ([strConday intValue] >= 5)
        {
            return 5;
        }else
        {
            return [strConday intValue]+1;
        }
    }
    
    return -1;
}

-(void)dealloc
{
    self.userID = nil;
    self.nickName = nil;
    self.GamePlayerInfo = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
@end
