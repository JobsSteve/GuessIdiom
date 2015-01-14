//
//  JFAudioPlayerManger.m
//  GuessImageWar
//
//  Created by ran on 13-12-19.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFAudioPlayerManger.h"
#import "JFAppSet.h"



static JFAudioPlayerManger  *playManger= nil;
@implementation JFAudioPlayerManger
@synthesize filePath;


+(id)shareInstance
{
    if (!playManger)
    {
        playManger = [[JFAudioPlayerManger alloc] init];
    }
    
    return playManger;
}
+(void)playWithMediaType:(JFAudioPlayerMangerType)type
{
    JFAudioPlayerManger  *manger = [JFAudioPlayerManger shareInstance];
    [manger playEffect:type];
    
}
-(void)setAllowsPlayMutiplesAudios
{
    
    BOOL duckIfOtherAudioIsPlaying = NO;
    UInt32 value = kAudioSessionCategory_AudioProcessing;
    
    value = YES;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(value), &value);
    
    UInt32 isOtherAudioPlaying = 0;
    UInt32 size = sizeof(isOtherAudioPlaying);
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &size, &isOtherAudioPlaying);
    
    if (isOtherAudioPlaying && duckIfOtherAudioIsPlaying)
    {
        AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(value), &value);
    }
    AudioSessionSetActive(YES);
   
}


-(id)init
{
    self = [super init];
    if (self)
    {
        m_dicSoundInfo = [[NSMutableDictionary alloc] init];
        JFAppSet  *appset = [JFAppSet shareInstance];//fvolume
        [appset addObserver:self forKeyPath:@"SoundEffect" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:NULL];
        [appset addObserver:self forKeyPath:@"bgvolume" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:NULL];
        
    }
    return self;
}
-(id)initWithType:(JFAudioPlayerMangerType)mediaType
{
    self = [super init];
    if (self)
    {
        [self setAllowsPlayMutiplesAudios];
        
        m_iType = mediaType;
        NSString  *strPath = nil;
        switch (mediaType)
        {
            case JFAudioPlayerMangerTypeAvoidAnswer:
                strPath = [[NSBundle mainBundle] pathForResource:@"avoidanswer" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeButtonClick:
                strPath = [[NSBundle mainBundle] pathForResource:@"btnclick" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeChangeBg:
                strPath = [[NSBundle mainBundle] pathForResource:@"change_bg" ofType:@"mp3"];
                break;
            case JFAudioPlayerMangerTypeChangeFail:
                strPath = [[NSBundle mainBundle] pathForResource:@"change_fail" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeChangeSuc:
                strPath = [[NSBundle mainBundle] pathForResource:@"change_suc" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeCountDownbegin:
                strPath = [[NSBundle mainBundle] pathForResource:@"countdown_begin" ofType:@"mp3"];
                break;
            case JFAudioPlayerMangerTypeCountDown:
                strPath = [[NSBundle mainBundle] pathForResource:@"countdown" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeCountDownBoom:
                strPath = [[NSBundle mainBundle] pathForResource:@"countDown_boom" ofType:@"mp3"];
                break;
            case JFAudioPlayerMangerTypeExchangeUser:
                strPath = [[NSBundle mainBundle] pathForResource:@"exchangeuser" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeGainGold:
                strPath = [[NSBundle mainBundle] pathForResource:@"gain_gold" ofType:@"mp3"];
                break;
            case JFAudioPlayerMangerTypeGainMedal:
                strPath = [[NSBundle mainBundle] pathForResource:@"GainMedal" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeIdeaShow:
                strPath = [[NSBundle mainBundle] pathForResource:@"ideashow" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeMainBg:
                strPath = [[NSBundle mainBundle] pathForResource:@"main_bg" ofType:@"mp3"];
                break;
            case JFAudioPlayerMangerTypeNormalBg:
                strPath = [[NSBundle mainBundle] pathForResource:@"normal_bg" ofType:@"mp3"];
                break;
            case JFAudioPlayerMangerTypeNormalRight:
                strPath = [[NSBundle mainBundle] pathForResource:@"normal_right" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeNormalWrong:
                strPath = [[NSBundle mainBundle] pathForResource:@"normal_wrong" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeStamp:
                strPath = [[NSBundle mainBundle] pathForResource:@"stamp" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeTimemachine:
                strPath = [[NSBundle mainBundle] pathForResource:@"timemachine" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeTrash:
                strPath = [[NSBundle mainBundle] pathForResource:@"trash" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeTreasure:
                strPath = [[NSBundle mainBundle] pathForResource:@"treasure" ofType:@"wav"];
                break;
            case JFAudioPlayerMangerTypeNormalCheckBg:
                strPath = [[NSBundle mainBundle] pathForResource:@"normal_check_bg" ofType:@"mp3"];
                break;
            case JFAudioPlayerMangerTypeRacehallBg:
                strPath = [[NSBundle mainBundle] pathForResource:@"RacehallBg" ofType:@"mp3"];
                break;
            case JFAudioPlayerMangerTypeRankBg:
                strPath = [[NSBundle mainBundle] pathForResource:@"rank_bg" ofType:@"mp3"];
                break;
            case JFAudioPlayerMangerTypeDiceprop:
                strPath = [[NSBundle mainBundle] pathForResource:@"dice_prop" ofType:@"wav"];
                break;
            default:
                break;
        }
        
        if (strPath)
        {
            DLOG(@"strPath:%@",strPath);
            
        }else
        {
            DLOG(@"initWithType error occor mediaType:%d",mediaType);
            return nil;
        }
        
        
     
        NSURL  *strUrl = [NSURL fileURLWithPath:strPath];
        NSError  *error = nil;
        m_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:strUrl error:&error];
        if (mediaType != JFAudioPlayerMangerTypeChangeBg)
        {
           // m_audioPlayer.delegate = self;
        }
        
        
        self.filePath = strPath;
        
      //  NSData  *data = [NSData dataWithContentsOfURL:strUrl options:NSDataReadingMappedIfSafe error:&error];
     //   m_audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];

        if (![m_audioPlayer prepareToPlay])
        {
            
            DLOG(@"[m_audioPlayer prepareToPlay]):%d   %@******************************",[m_audioPlayer prepareToPlay],strPath);
        }
       
        
        if (error)
        {
            DLOG(@"m_audioPlayer error occur:%@",error);
        }
        
        JFAppSet  *appset = [JFAppSet shareInstance];//fvolume
        [appset addObserver:self forKeyPath:@"SoundEffect" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:NULL];
        [appset addObserver:self forKeyPath:@"bgvolume" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}


-(void)playEffect:(JFAudioPlayerMangerType)mediaType
{
    
    if ([[JFAppSet shareInstance] SoundEffect] <= 0)
    {
        return;
    }
    
    
    if ([m_dicSoundInfo objectForKey:@(mediaType)])
    {
        SystemSoundID soundId = [[m_dicSoundInfo objectForKey:@(mediaType)] intValue];
        AudioServicesPlaySystemSound(soundId);
        return;
    }
    
    
    [self setAllowsPlayMutiplesAudios];
    
    m_iType = mediaType;
    NSString  *strPath = nil;
    switch (mediaType)
    {
        case JFAudioPlayerMangerTypeAvoidAnswer:
            strPath = [[NSBundle mainBundle] pathForResource:@"avoidanswer" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeButtonClick:
            strPath = [[NSBundle mainBundle] pathForResource:@"btnclick" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeChangeBg:
            strPath = [[NSBundle mainBundle] pathForResource:@"change_bg" ofType:@"mp3"];
            break;
        case JFAudioPlayerMangerTypeChangeFail:
            strPath = [[NSBundle mainBundle] pathForResource:@"change_fail" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeChangeSuc:
            strPath = [[NSBundle mainBundle] pathForResource:@"change_suc" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeCountDownbegin:
            strPath = [[NSBundle mainBundle] pathForResource:@"countdown_begin" ofType:@"mp3"];
            break;
        case JFAudioPlayerMangerTypeCountDown:
            strPath = [[NSBundle mainBundle] pathForResource:@"countdown" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeCountDownBoom:
            strPath = [[NSBundle mainBundle] pathForResource:@"countDown_boom" ofType:@"mp3"];
            break;
        case JFAudioPlayerMangerTypeExchangeUser:
            strPath = [[NSBundle mainBundle] pathForResource:@"exchangeuser" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeGainGold:
            strPath = [[NSBundle mainBundle] pathForResource:@"gain_gold" ofType:@"mp3"];
            break;
        case JFAudioPlayerMangerTypeGainMedal:
            strPath = [[NSBundle mainBundle] pathForResource:@"GainMedal" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeIdeaShow:
            strPath = [[NSBundle mainBundle] pathForResource:@"ideashow" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeMainBg:
            strPath = [[NSBundle mainBundle] pathForResource:@"main_bg" ofType:@"mp3"];
            break;
        case JFAudioPlayerMangerTypeNormalBg:
            strPath = [[NSBundle mainBundle] pathForResource:@"normal_bg" ofType:@"mp3"];
            break;
        case JFAudioPlayerMangerTypeNormalRight:
            strPath = [[NSBundle mainBundle] pathForResource:@"normal_right" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeNormalWrong:
            strPath = [[NSBundle mainBundle] pathForResource:@"normal_wrong" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeStamp:
            strPath = [[NSBundle mainBundle] pathForResource:@"stamp" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeTimemachine:
            strPath = [[NSBundle mainBundle] pathForResource:@"timemachine" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeTrash:
            strPath = [[NSBundle mainBundle] pathForResource:@"trash" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeTreasure:
            strPath = [[NSBundle mainBundle] pathForResource:@"treasure" ofType:@"wav"];
            break;
        case JFAudioPlayerMangerTypeNormalCheckBg:
            strPath = [[NSBundle mainBundle] pathForResource:@"normal_check_bg" ofType:@"mp3"];
            break;
        case JFAudioPlayerMangerTypeRacehallBg:
            strPath = [[NSBundle mainBundle] pathForResource:@"RacehallBg" ofType:@"mp3"];
            break;
        case JFAudioPlayerMangerTypeRankBg:
            strPath = [[NSBundle mainBundle] pathForResource:@"rank_bg" ofType:@"mp3"];
            break;
        case JFAudioPlayerMangerTypeDiceprop:
            strPath = [[NSBundle mainBundle] pathForResource:@"dice_prop" ofType:@"wav"];
        default:
            break;
    }
    
    
    if (strPath)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL* fileURL = [NSURL fileURLWithPath:strPath];
            SystemSoundID soundId = 0;
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundId);
            AudioServicesPlaySystemSound(soundId);
            [m_dicSoundInfo setObject:@(soundId) forKey:@(mediaType)];
        });
       
    }else
    {
        DLOG(@"strPath fail:%@",strPath);
    }
   
    
    
  
}

-(void)playWithLoops:(BOOL)loops
{
    if (loops)
    {
        m_audioPlayer.numberOfLoops = -1;
    }else
    {
        m_audioPlayer.numberOfLoops = 0;
    }
    [self setAudioVolume];
    
   // m_audioPlayer.enableRate = YES;
    
  //  m_audioPlayer.meteringEnabled = YES;
    
    
    
    if (![m_audioPlayer play])
    {
        DLOG(@"m_audioPlayer play fail  url:%@",m_audioPlayer.url);
    }else
    {
     //   DLOG(@"m_audioPlayer suc................................. :%@",m_audioPlayer.url);
    }
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if (![m_audioPlayer play])
        {
            DLOG(@"m_audioPlayer play fail  url:%@",m_audioPlayer.url);
        }else
        {
            DLOG(@"m_audioPlayer suc.................................");
        }
    });*/
    
    
   
   // [m_audioPlayer play];
    
}

-(void)pausePlay
{
    [m_audioPlayer pause];
}

-(void)stopPlay
{
    
    [m_audioPlayer stop];
    [m_audioPlayer setCurrentTime:0];
}

-(void)setAudioVolume
{
    CGFloat  fvolume = 1;
    switch (m_iType)
    {
        case JFAudioPlayerMangerTypeAvoidAnswer:
        case JFAudioPlayerMangerTypeButtonClick:
        case JFAudioPlayerMangerTypeChangeFail:
        case JFAudioPlayerMangerTypeChangeSuc:
        case JFAudioPlayerMangerTypeCountDownbegin:
        case JFAudioPlayerMangerTypeCountDown:
        case JFAudioPlayerMangerTypeCountDownBoom:
        case JFAudioPlayerMangerTypeExchangeUser:
        case JFAudioPlayerMangerTypeGainGold:
        case JFAudioPlayerMangerTypeGainMedal:
        case JFAudioPlayerMangerTypeIdeaShow:
        case JFAudioPlayerMangerTypeNormalRight:
        case JFAudioPlayerMangerTypeNormalWrong:
        case JFAudioPlayerMangerTypeStamp:
        case JFAudioPlayerMangerTypeTimemachine:
        case JFAudioPlayerMangerTypeTrash:
        case JFAudioPlayerMangerTypeTreasure:
            
            fvolume = [[JFAppSet shareInstance] SoundEffect];
            break;
        case JFAudioPlayerMangerTypeChangeBg:
        case JFAudioPlayerMangerTypeMainBg:
        case JFAudioPlayerMangerTypeNormalBg:
        case JFAudioPlayerMangerTypeNormalCheckBg:
        case JFAudioPlayerMangerTypeRacehallBg:
        case JFAudioPlayerMangerTypeRankBg:
             fvolume = [[JFAppSet shareInstance] bgvolume];
            break;
        default:
            break;
    }
    
   // fvolume = 10;
   // DLOG(@"setVolume :%f..............................",fvolume);
    [m_audioPlayer setVolume:fvolume];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setAudioVolume];
    
}

-(void)dealloc
{
    if (m_audioPlayer)
    {
        [m_audioPlayer stop];
        [m_audioPlayer release];
         m_audioPlayer = nil;
    }
    
    [m_dicSoundInfo release];
    m_dicSoundInfo = nil;
    self.filePath = nil;
    [[JFAppSet shareInstance] removeObserver:self forKeyPath:@"SoundEffect"];
    [[JFAppSet shareInstance] removeObserver:self forKeyPath:@"bgvolume"];
    [super dealloc];
}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
   // DLOG(@"audioPlayerDidFinishPlaying suc:%d",flag);
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    DLOG(@"audioPlayerDidFinishPlaying error:%@",error);
}


- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    DLOG(@"audioPlayerBeginInterruption error:%@",player);
}

/* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
  DLOG(@"audioPlayerEndInterruption error:%luu",(unsigned long)flags);
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
     DLOG(@"audioPlayerEndInterruption error:%lu",(unsigned long)flags);
}

@end