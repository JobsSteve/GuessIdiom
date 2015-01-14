//
//  JFAudioPlayerManger.h
//  GuessImageWar
//
//  Created by ran on 13-12-19.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "JFAppSet.h"
#import <AudioToolbox/AudioToolbox.h>

typedef enum
{
    JFAudioPlayerMangerTypeMainBg,
    JFAudioPlayerMangerTypeCountDownbegin,//countdown_begin
    JFAudioPlayerMangerTypeCountDown,
    JFAudioPlayerMangerTypeCountDownBoom,
    JFAudioPlayerMangerTypeAvoidAnswer,
    JFAudioPlayerMangerTypeTrash,
    JFAudioPlayerMangerTypeTreasure,
    JFAudioPlayerMangerTypeButtonClick,
    JFAudioPlayerMangerTypeExchangeUser,
    JFAudioPlayerMangerTypeTimemachine,
    JFAudioPlayerMangerTypeIdeaShow,
    JFAudioPlayerMangerTypeStamp,
    JFAudioPlayerMangerTypeChangeFail,
    JFAudioPlayerMangerTypeChangeBg,
    JFAudioPlayerMangerTypeChangeSuc,
    JFAudioPlayerMangerTypeGainMedal,
    JFAudioPlayerMangerTypeGainGold,
    JFAudioPlayerMangerTypeNormalBg,
    JFAudioPlayerMangerTypeNormalRight,
    JFAudioPlayerMangerTypeNormalWrong,
    JFAudioPlayerMangerTypeRankBg,
    JFAudioPlayerMangerTypeRacehallBg,
    JFAudioPlayerMangerTypeNormalCheckBg,
    JFAudioPlayerMangerTypeDiceprop
    
}JFAudioPlayerMangerType;

@interface JFAudioPlayerManger : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer               *m_audioPlayer;
    JFAudioPlayerMangerType     m_iType;
    NSMutableDictionary         *m_dicSoundInfo;
    
}
@property(nonatomic,copy)NSString   *filePath;


-(id)initWithType:(JFAudioPlayerMangerType)mediaType;
+(void)playWithMediaType:(JFAudioPlayerMangerType)type;
-(void)pausePlay;
-(void)stopPlay;
-(void)playWithLoops:(BOOL)loops;
@end
