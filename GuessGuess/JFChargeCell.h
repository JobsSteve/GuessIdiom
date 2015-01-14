//
//  JFChagreCell.h
//  GuessImageWar
//
//  Created by ran on 13-12-14.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFChargeProductModel.h"
#import "JFButtonTrace.h"
#import "UIImge-GetSubImage.h"
#import "NSString_hello.h"
@protocol JFChargeCellDelegate <NSObject>

-(void)chargeProductModel:(JFChargeProductModel*)model;

@end
@interface JFChargeCell : UITableViewCell
{
    JFLabelTrace                *m_labelMoney;
    UIImageView                 *m_imageIcon;
    JFButtonTrace               *m_btnPurchase;
    id<JFChargeCellDelegate>    delegate;
}

@property(nonatomic,retain)JFChargeProductModel  *model;
@property(nonatomic,assign)id<JFChargeCellDelegate> delegate;

-(void)updateDataWithModel:(JFChargeProductModel*)tempModel;
@end
