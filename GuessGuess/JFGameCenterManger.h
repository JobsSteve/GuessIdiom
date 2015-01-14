//
//  JFGameCenterManger.h
//  GuessImageWar
//
//  Created by ran on 13-12-10.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JFAppSet.h"
#import "UtilitiesFunction.h"


extern NSString  *const        BNRGamePlayUserInfo;
extern NSString  *const        kGamePlayUserInfoPlayerID;
extern NSString  *const        kGamePlayUserInfodisplayName;


@protocol JFGameCenterMangerDelegate <NSObject>
-(void)needShowLoginView:(UIViewController*)control;
-(void)getGameCenterID:(NSString*)playerID;
@end

@interface JFGameCenterManger : NSObject
{
    
    id<JFGameCenterMangerDelegate>  delegate;
    BOOL                            m_bHasauthed;
}
@property(nonatomic,assign)id<JFGameCenterMangerDelegate>  delegate;
@property(nonatomic,retain)NSString *playerID;

+(id)shareInstanceWithDelgate:(id)delegate;
+(NSDictionary*)getCurrentGameplayerinfo;




@end
