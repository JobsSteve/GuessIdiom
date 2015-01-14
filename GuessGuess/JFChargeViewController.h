//
//  JFChargeViewController.h
//  GuessGuess
//
//  Created by Ran Jingfu on 3/13/14.
//  Copyright (c) 2014 Ran Jingfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFChargeCell.h"
#import "JFAlertView.h"
#import "UtilitiesFunction.h"
#import "JFChargeNet.h"
#import "MBProgressHUD.h"
#import "JFAudioPlayerManger.h"

@interface JFChargeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,JFChargeNetDelegate,JFChargeCellDelegate>
{
    
    
    UITableView             *m_tableView;
    NSMutableArray          *m_arrayData;
    JFChargeNet             *m_chargeNet;
}

@end
