//
//  InAppPurchaseManager.h
//  I366_V1_4
//
//  Created by  on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>  
#import "SKProduct+LocalizedPrice.h"
#import "GTMBase64.h"
#import "JSON.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"  

@protocol InAppPurchaseManagerDelegate <NSObject>

- (void)completeTransactionWithReceipt:(NSString *)receipt;

@end

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate>  
{  
    SKProduct *proUpgradeProduct;  
    SKProductsRequest *_productsRequest;  
    NSMutableArray *_orderNumberOfProducts;
    
    NSObject<InAppPurchaseManagerDelegate> *delegate;
} 

@property (nonatomic, retain) SKProductsRequest *productsRequest;  
@property (nonatomic, retain) NSMutableArray *orderNumberOfProducts;
@property (nonatomic, assign) NSObject<InAppPurchaseManagerDelegate> *delegate;

+ (InAppPurchaseManager *)sharedAppPurchase;
+ (void)closePurchase;
- (void)requestProUpgradeProductDataWithProductID:(NSString *)productID andOrderNumber:(NSString *)orderNumber;

@end
