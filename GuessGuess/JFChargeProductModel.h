//
//  JFChargeProductModel.h
//  i366
//
//  Created by ran on 13-9-5.
//
//

#import <Foundation/Foundation.h>



typedef enum
{
    JFChargeProductModelTypeDefault,
    JFChargeProductModelTypeExchange
}JFChargeProductModelType;
@interface JFChargeProductModel : NSObject


@property(nonatomic)JFChargeProductModelType  productType;
@property(nonatomic)float  productValue;    // 价值
@property(nonatomic,copy)NSString   *productID;
@property(nonatomic)float productMoney; //实际支付的钱
@property(nonatomic,copy)NSString   *title;
@property(nonatomic,copy)NSString   *chargedescription;

+(id)productWithType:(JFChargeProductModelType)type productID:(NSString *)strproductID value:(float)value money:(float)money
               title:(NSString *)title description:(NSString *)des;
@end
