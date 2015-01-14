//
//  JFGameCenterManger.m
//  GuessImageWar
//
//  Created by ran on 13-12-10.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFGameCenterManger.h"
//#import <GameKit/GameKit.h>

NSString  *const        BNRGamePlayUserInfo = @"BNRGamePlayUserInfo";
NSString  *const        kGamePlayUserInfoPlayerID = @"playerID";
NSString  *const        kGamePlayUserInfodisplayName= @"displayName";

static  JFGameCenterManger  *gameCenter = nil;

@implementation JFGameCenterManger
@synthesize delegate;
@synthesize playerID;
-(NSString*)storePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"localUserData"];
    /*
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];*/
    return dataPath;
}



-(void)getPlayerID
{
    
    if (delegate && [delegate respondsToSelector:@selector(getGameCenterID:)])
    {
        [delegate getGameCenterID:self.playerID];
    }
}
+(id)shareInstanceWithDelgate:(id)delegate
{
    if (!gameCenter)
    {
        
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
        gameCenter = [[JFGameCenterManger alloc] init];
        gameCenter.delegate = delegate;
        [gameCenter authInGameCenter];
    }
    return gameCenter;
}
+(NSDictionary*)getCurrentGameplayerinfo
{
    return [gameCenter getCurrentGameplayerinfo];
}
-(NSDictionary*)getCurrentGameplayerinfo
{
    NSDictionary  *olddic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self storePath]];
    return olddic;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        m_bHasauthed = NO;
    }
    return self;
}
-(void)authInGameCenter
{
    /*
    GKLocalPlayer  *player = [GKLocalPlayer localPlayer];
    DLOG(@"GKLocalPlayer log:%@",player);
    
    if (CURRENTVERSIONNUMBER >= 6.0)
    {
        
        if (player.isAuthenticated == NO)
        {
          //  [[JFAppSet shareInstance] setCurreninterface:UIInterfaceOrientationMaskAllButUpsideDown];
            [player setAuthenticateHandler:^(UIViewController *controller,NSError *error)
             {
                 if (controller  && delegate && [delegate respondsToSelector:@selector(needShowLoginView:)])
                 {
                     [delegate needShowLoginView:controller];
                 }
                 
                 
                 
                 if (error)
                 {
                     [self setLandScale];
                 }
                 DLOG(@"controler:%@ error:%@ player:%@",controller,error,player);
                 
                 if (player.playerID  && ![player.playerID isEqualToString:@""])
                {
                    NSDictionary  *dicinfo = [NSDictionary dictionaryWithObjectsAndKeys:player.playerID,@"playerID",player.displayName,@"displayName", nil];
                    if (!m_bHasauthed)
                    {
                        
                        [NSKeyedArchiver archiveRootObject:dicinfo toFile:[self storePath]];
                        m_bHasauthed = YES;
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:BNRGamePlayUserInfo object:nil userInfo:dicinfo];
                    
                    self.playerID = [dicinfo valueForKey:@"playerID"];
                    [self getPlayerID];
                    [self setLandScale];
                 }
                 
             }];
            
             NSDictionary  *olddic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self storePath]];
            if (!olddic)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:BNRGamePlayUserInfo object:nil userInfo:olddic];
                self.playerID = [olddic valueForKey:@"playerID"];
                [self getPlayerID];
            }else
            {
                DLOG(@"there is no gamecenter info");
            }
           
        }else
        {
            
         
             NSDictionary  *dicinfo = [NSDictionary dictionaryWithObjectsAndKeys:player.playerID,@"playerID",player.displayName,@"displayName", nil];
            if (!m_bHasauthed)
            {
               
                [NSKeyedArchiver archiveRootObject:dicinfo toFile:[self storePath]];
                m_bHasauthed = YES;
            }else
            {
                NSDictionary  *olddic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self storePath]];
                if (![[olddic valueForKey:@"playerID"] isEqualToString:player.playerID])
                {
                    [NSKeyedArchiver archiveRootObject:dicinfo toFile:[self storePath]];
                }
            }
            [self setLandScale];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:BNRGamePlayUserInfo object:nil userInfo:dicinfo];
            self.playerID = [dicinfo valueForKey:@"playerID"];
            [self getPlayerID];
            
        }
        
        
    }else
    {
        
        if (player.isAuthenticated == NO)
        {
            [player authenticateWithCompletionHandler:^(NSError *error)
             {
                 if (player.isAuthenticated || [player.playerID length] > 0)
                 {
                     NSDictionary  *dicinfo = [NSDictionary dictionaryWithObjectsAndKeys:player.playerID,@"playerID",player.displayName,@"displayName", nil];
                     if (!m_bHasauthed)
                     {
                         
                         [NSKeyedArchiver archiveRootObject:dicinfo toFile:[self storePath]];
                         m_bHasauthed = YES;
                     }else
                     {
                         NSDictionary  *olddic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self storePath]];
                         if (![[olddic valueForKey:@"playerID"] isEqualToString:player.playerID])
                         {
                             [NSKeyedArchiver archiveRootObject:dicinfo toFile:[self storePath]];
                         }
                     }
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:BNRGamePlayUserInfo object:nil userInfo:dicinfo];
                     
                     self.playerID = [dicinfo valueForKey:@"playerID"];
                     [self getPlayerID];
                     
                    // [self setLandScale];
                     
                 }else
                 {
                     NSDictionary  *olddic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self storePath]];
                     if (!olddic)
                     {
                         [[NSNotificationCenter defaultCenter] postNotificationName:BNRGamePlayUserInfo object:nil userInfo:olddic];
                         self.playerID = [olddic valueForKey:@"playerID"];
                         [self getPlayerID];
                     }else
                     {
                         DLOG(@"there is no gamecenter info");
                     }
                     
                 }
                 DLOG(@"authenticateWithCompletionHandler:%@  error:%@",player,error);
             }];
        }else
        {
            NSDictionary  *dicinfo = [NSDictionary dictionaryWithObjectsAndKeys:player.playerID,@"playerID",player.displayName,@"displayName", nil];
            if (!m_bHasauthed)
            {
                
                [NSKeyedArchiver archiveRootObject:dicinfo toFile:[self storePath]];
                m_bHasauthed = YES;
            }else
            {
                NSDictionary  *olddic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self storePath]];
                if (![[olddic valueForKey:@"playerID"] isEqualToString:player.playerID])
                {
                    [NSKeyedArchiver archiveRootObject:dicinfo toFile:[self storePath]];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:BNRGamePlayUserInfo object:nil userInfo:dicinfo];
            self.playerID = [dicinfo valueForKey:@"playerID"];
            [self getPlayerID];
         //   [self setLandScale];
            
        }
        
        
        DLOG(@"GKLocalPlayer after:%@",player);
        
    }*/
}

-(void)setLandScale
{
    
    return;
  //  [[JFAppSet shareInstance] setCurreninterface:UIInterfaceOrientationMaskLandscape];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
      UIInterfaceOrientation type = [UIApplication sharedApplication].statusBarOrientation;
    if (type != UIDeviceOrientationLandscapeRight && type != UIDeviceOrientationLandscapeLeft)
    {
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
        {
            
            DLOG(@"[[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)");
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                           withObject:(id)UIInterfaceOrientationLandscapeRight];
        }
        
    }
}

@end
