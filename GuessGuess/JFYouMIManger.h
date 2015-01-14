//
//  JFYouMIManger.h
//  i366
//
//  Created by ran on 13-11-22.
//
//
#if 0
#import <Foundation/Foundation.h>
#import "YouMiConfig.h"
#import "YouMiWallSpot.h"
#import "YouMiView.h"

@protocol JFYouMIMangerDelegate <NSObject>

-(void)getAllYouMiModels:(NSMutableArray*)arrayModels;
@end

@interface JFYouMIManger : NSObject<YouMiDelegate>
{
    id<JFYouMIMangerDelegate>  delegate;
    NSMutableArray             *m_arrayData;
    
}

@property(nonatomic,assign)id<JFYouMIMangerDelegate>  delegate;
@property(nonatomic)int  app_userID;

-(void)showYouMiPointAppViewController;
-(void)GetYouMiAppSourceData:(int)page count:(int)count;
+(id)shareInstanceWithUserID:(int)userID;

//we will not call this method,just reserver for furture  use 
+(void)sharedealloc;


+(void)addYouMiadView:(UIView*)superView frame:(CGRect)frame rootViewController:(UIViewController*)rootViewController;
+(void)removeYouMiView;
+(void)showSpotView;
@end
#endif