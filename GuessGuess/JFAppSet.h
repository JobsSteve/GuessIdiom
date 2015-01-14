//
//  JFAppSet.h
//  GuessImageWar
//
//  Created by ran on 13-12-10.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JFAppSet : NSObject<NSCoding>
{
    CGFloat     m_fSoundEffect;
    CGFloat     m_bgvolume;
}

@property(nonatomic)CGFloat             SoundEffect;
@property(nonatomic)CGFloat             bgvolume;

+(id)shareInstance;
+(void)storeShareInstance;
@end
