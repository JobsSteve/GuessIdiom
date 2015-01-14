//
//  JFChargeNet.m
//  GuessImageWar
//
//  Created by ran on 14-1-2.
//  Copyright (c) 2014年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFChargeNet.h"
#import "JFLocalPlayer.h"
#import "InAppPurchaseManager.h"
#import "JFSQLManger.h"



NSString    *const      BNRChargeSuc = @"BNRChargeSuc";
@implementation JFChargeNet
@synthesize delegate;
@synthesize chargemodel;
@synthesize payID;
@synthesize channelID;
@synthesize receipt;


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.chargemodel = nil;
    self.payID = nil;
    self.channelID = nil;
    self.receipt = nil;
    DLOG(@"JFChargeNet dealloc");
    [super dealloc];
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [[InAppPurchaseManager sharedAppPurchase] setDelegate:self];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"faliedTransaction" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failTransaction:)
                                                     name:@"faliedTransaction" object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetShopListInAppStoreSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopListInAppStoreSuccess:)
                                                     name:@"GetShopListInAppStoreSuccess" object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetShopListInAppStoreFail" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopListInAppStoreFail:)
                                                     name:@"GetShopListInAppStoreFail" object:nil];
        
    }
    return self;
}


-(void)cleanChargeInfo
{
 
    if (self.payID)
    {
        //[JFSQLManger deleteInfoByPayID:self.payID];
    }
}
-(void)storeChareInfo
{
    if (self.payID)
    {
       // [JFSQLManger UpdateUndealchargeInfo:payID channelID:[self.channelID intValue] orderReceipt:self.receipt];
    }
    
}
-(void)failTransaction:(NSNotification*)note
{
    if (delegate && [delegate respondsToSelector:@selector(chargeGoldFail:)])
    {
        [delegate chargeGoldFail:0];
    }
    [self cleanChargeInfo];
}

-(void)getShopListInAppStoreSuccess:(NSNotification*)note
{
    if (delegate && [delegate respondsToSelector:@selector(getShopListInAppStoreSuccess:)])
    {
        [delegate getShopListInAppStoreSuccess:note];
    }

}
-(void)getShopListInAppStoreFail:(NSNotification*)note
{
    if (delegate && [delegate respondsToSelector:@selector(getShopListInAppStoreFail:)])
    {
        [delegate getShopListInAppStoreFail:[[note userInfo] valueForKey:@"error"]];
    }
    [self cleanChargeInfo];
}


-(void)requestChanel:(JFChargeProductModel*)tempchargeModel
{
    self.chargemodel = tempchargeModel;
    NSString    *strOrder = @"abcdefghijklmnopq";
    [[InAppPurchaseManager sharedAppPurchase] requestProUpgradeProductDataWithProductID:self.chargemodel.productID andOrderNumber:strOrder];

}



- (void)completeTransactionWithReceipt:(NSString *)tempreceipt
{
    self.receipt =  tempreceipt;
    DLOG(@"completeTransactionWithReceipt:%@",self.payID);
    DLOG(@"receipt length:%luu",(unsigned long)[tempreceipt length]);
    if (delegate  && [delegate respondsToSelector:@selector(chargeGoldSuc:)])
    {
        [delegate chargeGoldSuc:self.chargemodel];
    }
    [self storeChareInfo];
}



@end
