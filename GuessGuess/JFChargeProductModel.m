//
//  JFChargeProductModel.m
//  i366
//
//  Created by ran on 13-9-5.
//
//

#import "JFChargeProductModel.h"

@implementation JFChargeProductModel

@synthesize productID;
@synthesize productMoney;
@synthesize productType;
@synthesize productValue;
@synthesize title;
@synthesize chargedescription;

/**
 *  retire a instnce of class JFChargeProductModel
 *
 *  @param JFChargeProductModelType         charge type     2 is vipchargetype
 *  @param strproductID   productID
 *  @param value        the product value
 *  @param money        need money to pay
 *
 *  @return instnce of class JFChargeProductModel
 */
+(id)productWithType:(JFChargeProductModelType)type productID:(NSString *)strproductID value:(float)value money:(float)money
               title:(NSString *)title description:(NSString *)des
{
    JFChargeProductModel  *product = [[JFChargeProductModel alloc] init];
    product.productType = type;
    product.productID = strproductID;
    product.productValue = value;
    product.productMoney = money;
    product.title = title;
    product.chargedescription = des;
    
    return [product autorelease];
}

-(void)dealloc
{
    
    DLOG(@"JFChargeProductModel dealloc");
    self.productID = nil;
    self.title = nil;
    self.chargedescription = nil;
    [super dealloc];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"class:JFChargeProductModel  <<%p>>  productID:%@ productMoney:%.2f productType:%d productValue:%.2f",self,self.productID,self.productMoney,self.productType,self.productValue];
}
@end
