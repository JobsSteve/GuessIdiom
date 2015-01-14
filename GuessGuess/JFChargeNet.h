//
//  JFChargeNet.h
//  GuessImageWar
//
//  Created by ran on 14-1-2.
//  Copyright (c) 2014年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFChargeProductModel.h"
#import "InAppPurchaseManager.h"


@protocol JFChargeNetDelegate <NSObject>

@optional
-(void)getPayIDFail:(NSDictionary*)dicInfo;
-(void)chargeGoldFail:(int)status;
-(void)chargeGoldSuc:(JFChargeProductModel*)model;
-(void)getServerRemainChargeSuc:(int)goldNum isFirstCharge:(BOOL)isfirstCharge;
-(void)getShopListInAppStoreSuccess:(id)thread;
-(void)getShopListInAppStoreFail:(id)Thread;
@optional
-(void)networkOccurError:(NSString*)statusCode;
@end
@interface JFChargeNet : NSObject<InAppPurchaseManagerDelegate>
{
    id<JFChargeNetDelegate> deleagte;
    
}
@property(nonatomic,assign)id<JFChargeNetDelegate> delegate;
@property(nonatomic,retain)JFChargeProductModel *chargemodel;
@property(nonatomic,copy)NSString   *payID;
@property(nonatomic,copy)NSString   *channelID;
@property(nonatomic,copy)NSString   *receipt;

-(void)requestChanel:(JFChargeProductModel*)tempchargeModel;
@end
