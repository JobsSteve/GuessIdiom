//
//  JFAppSet.m
//  GuessImageWar
//
//  Created by ran on 13-12-10.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFAppSet.h"

static  JFAppSet  *appset = nil;

@implementation JFAppSet


@synthesize bgvolume = m_bgvolume;
@synthesize SoundEffect = m_fSoundEffect;


+(NSString*)storePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"localJFAppSet"];
    return dataPath;
}


+(void)storeShareInstance
{
    NSString  *strPath = [JFAppSet storePath];
    BOOL  bsuc =  [NSKeyedArchiver archiveRootObject:appset toFile:strPath];
    if (!bsuc)
    {
        DLOG(@"JFAppSet storeShareInstance strPath  fail:%@",strPath);
    }
}

-(void)setSoundEffect:(CGFloat)newSoundEffect
{
    m_fSoundEffect = newSoundEffect;
     [JFAppSet storeShareInstance];
}

-(void)setBgvolume:(CGFloat)newbgvolume
{
    m_bgvolume =  newbgvolume;
    [JFAppSet storeShareInstance];
}
+(id)shareInstance
{
    if (!appset)
    {
        appset = [[NSKeyedUnarchiver unarchiveObjectWithFile:[JFAppSet storePath]] retain];
        if (!appset)
        {
           appset = [[JFAppSet alloc] init];
        }
    }
    return appset;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        
        self.bgvolume = [aDecoder decodeFloatForKey:@"bgvolume"];
        self.SoundEffect = [aDecoder decodeFloatForKey:@"SoundEffect"];
     //   self.curreninterface = [aDecoder decodeIntForKey:@"curreninterface"];
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.bgvolume forKey:@"bgvolume"];
    [aCoder encodeFloat:self.SoundEffect forKey:@"SoundEffect"];

    
}
-(id)init
{
    self = [super init];
    if (self)
    {
        

        self.bgvolume = 1.0;
        self.SoundEffect = 1.0;
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
}
@end
