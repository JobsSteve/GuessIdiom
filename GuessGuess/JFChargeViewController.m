//
//  JFChargeViewController.m
//  GuessGuess
//
//  Created by Ran Jingfu on 3/13/14.
//  Copyright (c) 2014 Ran Jingfu. All rights reserved.
//

#import "JFChargeViewController.h"
#import "JFChargeProductModel.h"
#import "JFLocalPlayer.h"
@interface JFChargeViewController ()

@end

@implementation JFChargeViewController

-(id)init
{
    self = [super init];
    if (self)
    {
        m_arrayData = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect  frame = [self.view bounds];
    
    if (!m_tableView)
    {
        m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, frame.size.width, frame.size.height-66)];
        [self.view addSubview:m_tableView];
        [m_tableView setBackgroundView:nil];
        [m_tableView setBackgroundColor:[UIColor clearColor]];
        [m_tableView setDataSource:self];
        [m_tableView setDelegate:self];
        m_tableView.separatorColor = [UIColor clearColor];
    }
    
    
    JFButtonTrace    *btnBack = [[JFButtonTrace alloc] initWithFrame:CGRectMake(10,10,40,40) withshadowColor:nil withTextColor:[UIColor whiteColor] title:nil];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(clickbackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    [btnBack release];
    
    self.view.layer.contents =(id)[UIImage imageNamed:@"set_bg_iphone5.jpg"].CGImage;
    
    [self addDatasource];
    
    
}

-(void)clickbackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addDatasource
{
    
    
    
    JFChargeProductModel  *model6 = [JFChargeProductModel productWithType:JFChargeProductModelTypeDefault productID:@"com.jingfu.600gold" value:600 money:6 title:@"" description:@"600金币"];
    JFChargeProductModel  *model12 = [JFChargeProductModel productWithType:JFChargeProductModelTypeDefault productID:@"com.jingfu.1400gold" value:1400 money:12 title:@"" description:@"1400金币"];
    JFChargeProductModel  *model30 = [JFChargeProductModel productWithType:JFChargeProductModelTypeDefault productID:@"com.jingfu.3800gold" value:3800 money:30 title:@"" description:@"3800金币"];
    JFChargeProductModel  *model128 = [JFChargeProductModel productWithType:JFChargeProductModelTypeDefault productID:@"com.jingfu.6600gold" value:6600 money:50 title:@"" description:@"6600金币"];
    JFChargeProductModel  *model328 = [JFChargeProductModel productWithType:JFChargeProductModelTypeDefault productID:@"com.jingfu.15000gold" value:15000 money:128 title:@"" description:@"15000金币"];
    JFChargeProductModel    *model = [[JFChargeProductModel alloc] init];
    model.productType = JFChargeProductModelTypeExchange;
    
    [m_arrayData addObject:model6];
    [m_arrayData addObject:model12];
    [m_arrayData addObject:model30];
    [m_arrayData addObject:model128];
    [m_arrayData addObject:model328];
    //  [m_arrayData addObject:model];
    [model release];
    [m_tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [m_arrayData release];
    m_arrayData = nil;
    
    [m_tableView release];
    m_tableView = nil;
    
    m_chargeNet.delegate = nil;
    [m_chargeNet release];
    m_chargeNet = nil;
    
    [super dealloc];
}


#pragma tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrayData count];
    //UIFont
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JFChargeCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"11"];
    if (!cell)
    {
        cell = [[[JFChargeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundView:[UIView new]];
    [cell updateDataWithModel:[m_arrayData objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark JFChargeCellDelegate
-(void)chargeProductModel:(JFChargeProductModel*)model
{
    
    
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    
    if (![UtilitiesFunction networkCanUsed])
    {
        JFAlertView *av = [[JFAlertView alloc] initWithTitle:@"提示"
                                                     message:@"无法连接网络"
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"我知道了"];
        [av show];
        [av release];
        return;
    }

    if (!m_chargeNet)
    {
        m_chargeNet = [[JFChargeNet alloc] init];
        m_chargeNet.delegate = self;
    }
    
    
    [self showProgress];
    [m_chargeNet requestChanel:model];
    
    DLOG(@"chargeProductModel:%@",model);
}

-(void)showProgress
{
    MBProgressHUD  *progress = [[MBProgressHUD alloc] initWithView:self.view];
    progress.labelText = @"充值中,请稍后.......";
    [self.view addSubview:progress];
    [progress show:YES];
    [progress release];
}

-(void)hideProgress
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[MBProgressHUD class]])
        {
            [view removeFromSuperview];
        }
    }
}


-(void)getPayIDFail:(NSDictionary*)dicInfo
{
    [self hideProgress];
    JFAlertView *av = [[JFAlertView alloc] initWithTitle:@"提示"
                                                 message:@"充值失败!"
                                                delegate:nil
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"我知道了"];
    [av show];
    [av release];
    
}
-(void)chargeGoldFail:(int)status
{
    [self hideProgress];
    JFAlertView *av = [[JFAlertView alloc] initWithTitle:@"提示"
                                                 message:@"充值失败!"
                                                delegate:nil
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"我知道了"];
    [av show];
    [av release];
    
}
-(void)chargeGoldSuc:(JFChargeProductModel*)model
{
    

    int totlaMoney = [[JFLocalPlayer shareInstance] goldNumber]+model.productValue;
    
    
    [JFLocalPlayer addgoldNumber:model.productValue];
    
    NSString    *strMsg = [NSString stringWithFormat:@"充值成功，您获得%0.0f的金币！现在，您有%d金币了",model.productValue,totlaMoney];
    
    JFAlertView *av = [[JFAlertView alloc] initWithTitle:@"提示"
                                                 message:strMsg
                                                delegate:nil
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"我知道了"];
    [av show];
    [av release];
    [self hideProgress];
}
-(void)getServerRemainChargeSuc:(int)goldNum isFirstCharge:(BOOL)isfirstCharge
{
    
}
-(void)getShopListInAppStoreSuccess:(id)thread
{
    
}
-(void)getShopListInAppStoreFail:(id)Thread
{
    [self hideProgress];
    JFAlertView *av = [[JFAlertView alloc] initWithTitle:@"提示"
                                                 message:@"获取订单号失败！"
                                                delegate:nil
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"我知道了"];
    [av show];
    [av release];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
