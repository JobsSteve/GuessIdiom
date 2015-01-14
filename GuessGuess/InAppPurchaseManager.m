//
//  InAppPurchaseManager.m
//  I366_V1_4
//
//  Created by  on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseManager.h"


@implementation InAppPurchaseManager
@synthesize productsRequest = _productsRequest;
@synthesize orderNumberOfProducts = _orderNumberOfProducts;
@synthesize delegate;

//extern void mmc_vim_send_transaction_to_server(char *orderid, char *tradeid, char *productid, char *receipt);

static InAppPurchaseManager *purchase = nil;

- (id)init
{
    if (purchase) {
        return purchase;
    }else {
        self = [super init];
        if (self) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            self.orderNumberOfProducts = array;
            [array release];
        }
        
        return self;
    }
}

+ (InAppPurchaseManager *)sharedAppPurchase
{
    if (!purchase) {
        purchase = [[InAppPurchaseManager alloc] init];
    }
    
    return purchase;
}

+ (void)closePurchase
{
    if (purchase) {
        [purchase release];
        purchase = nil;
    }
}

- (void)dealloc
{
#ifdef DEBUG_VERSION
    NSLog(@"InAppPurchaseManager dealloc");
#endif
    
    [_productsRequest cancel];
    [_productsRequest setDelegate:nil];
    self.productsRequest = nil;
    self.orderNumberOfProducts = nil;
    self.delegate = nil;
    
    [proUpgradeProduct release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)requestProUpgradeProductDataWithProductID:(NSString *)productID andOrderNumber:(NSString *)orderNumber
{
    
  //  NSArray *array = [[SKPaymentQueue defaultQueue] transactions];
    
    NSSet *productIdentifiers = [NSSet setWithObject:productID];  
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers]; 
    self.productsRequest = request;
    _productsRequest.delegate = self;  
    [_productsRequest start];  
    [request release];
    
    [_orderNumberOfProducts addObject:orderNumber];
    
    // we will release the request object in the delegate callback  
}  

#pragma mark -  
#pragma mark SKProductsRequestDelegate methods  

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response  
{  
    NSArray *products = response.products;  
    proUpgradeProduct = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;  
    if (proUpgradeProduct)  
    {  
        DLOG(@"Product title: %@" , proUpgradeProduct.localizedTitle);
        DLOG(@"Product description: %@" , proUpgradeProduct.localizedDescription);
        DLOG(@"Product price: %@" , proUpgradeProduct.price);
        DLOG(@"Product id: %@" , proUpgradeProduct.productIdentifier);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetShopListInAppStoreSuccess" object:nil];
        
        SKPayment *payment = [SKPayment paymentWithProduct:proUpgradeProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }  
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)  
    {  
        DLOG(@"Invalid product id: %@" , invalidProductId);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetShopListInAppStoreFail" object:nil];
    }  
    

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"completeTransaction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeTransaction:) name:@"completeTransaction" object:nil];
}


- (void)requestDidFinish:(SKRequest *)request
{
     DLOG(@"requestDidFinish:%@",request);
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetShopListInAppStoreFail" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"error",nil]];
    DLOG(@"request:%@",error);
}

- (void)completeTransaction:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"completeTransaction" object:nil];
    
    if ([_orderNumberOfProducts lastObject] != nil) {
        [_orderNumberOfProducts removeObjectAtIndex:0];
        
        SKPaymentTransaction *transaction = [notification object];
        NSString *tradeid = transaction.transactionIdentifier;
        NSString *productid = proUpgradeProduct.productIdentifier;
        
        NSString *recepit = [GTMBase64 stringByEncodingData:transaction.transactionReceipt];
        DLOG(@"receipt:%@", recepit);
        DLOG(@"receipt:%@", [transaction description]);
        DLOG(@"tradeid:%@", tradeid);
        DLOG(@"productid:%@", productid);
        
        [delegate completeTransactionWithReceipt:recepit];
    }
}

@end
