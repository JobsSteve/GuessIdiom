//
//  JFNormalAnswerViewController.m
//  GuessImageWar
//
//  Created by ran on 13-12-17.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFNormalAnswerViewController.h"
#import "PublicClass.h"
#import "UtilitiesFunction.h"
#import "JFLocalPlayer.h"
#import "JFPlayAniManger.h"
#import "JFShareManger.h"
#import "JFChargeViewController.h"
#import <iAd/ADBannerView.h>

#define NEEDCLICKAVOIDAUTO      0

@interface JFNormalAnswerViewController ()<ADBannerViewDelegate>

@property(nonatomic,strong)ADBannerView *adView;
@end

@implementation JFNormalAnswerViewController
@synthesize idiomModel;
@synthesize avoidProp;
@synthesize trashProp;
@synthesize ideaShowProp;
@synthesize adView;


-(id)init
{
    self = [super init];
    if (self)
    {
        
        JFLocalPlayer   *player = [JFLocalPlayer shareInstance];
        
        DLOG(@"lastlevel:%d",player.lastLevel);
        self.idiomModel = [JFSQLManger getOnePuzzleModelByLevel:[[JFLocalPlayer shareInstance] lastLevel]];
      
        [player addObserver:self forKeyPath:@"goldNumber" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        
    }
    return self;
}


-(void)WillEnterForeground:(NSNotification*)note
{
     [self cleanStoreData:nil];
}

-(void)WillResignActive:(NSNotification*)note
{
     [self storeCurrentState];
}

-(void)cleanFreeGoldInfo:(id)thread
{

    
    m_idiomView.userInteractionEnabled = YES;
    NSString    *strStoreFreeKey = [NSString stringWithFormat:@"NormalLevelInfoReward%@",[[JFLocalPlayer shareInstance] userID]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:strStoreFreeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self refreshSelfView:nil];
    if ([[JFLocalPlayer shareInstance] goldNumber] > 0)
    {
        //[self cleanFreeGoldInfo:nil];
      
        [self setPropGrayAccordGoldNumber];
        [self setPropGrayAccordRemainCount];
    }else
    {
        [self showFreeGiftView];
    }
    
}


-(void)dealloc
{
    
    [self.adView removeFromSuperview];
    self.adView = nil;
    
    DLOG(@"JFNormalAnswerViewController dealloc");
    JFLocalPlayer   *player = [JFLocalPlayer shareInstance];
    [player removeObserver:self forKeyPath:@"goldNumber"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.idiomModel = nil;
    [m_idiomView release];
    m_idiomView = nil;
    [m_labelLevel release];
    m_labelLevel = nil;
    [m_goldView release];
    m_goldView = nil;
    self.avoidProp = nil;
    self.ideaShowProp = nil;
    self.trashProp = nil;
    if (m_playerbgManger)
    {
        [m_playerbgManger stopPlay];
        [m_playerbgManger release];
        m_playerbgManger = nil;
    }
    [super dealloc];
}
-(void)loadView
{
    [super loadView];
    
    [self initview];
    
    [self initViewAccordStoreData];
    
   // [m_idiomView startAnswer:30];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!m_playerbgManger)
    {
        m_playerbgManger = [[JFAudioPlayerManger alloc] initWithType:JFAudioPlayerMangerTypeNormalBg];
          [m_playerbgManger playWithLoops:YES];
    }
  
	
}


-(void)addYouMiAd
{
    
    ADBannerView    *bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    bannerView.delegate = self;
    bannerView.frame = CGRectOffset(bannerView.frame, 0, self.view.frame.size.height-bannerView.frame.size.height);
    [self.view addSubview:bannerView];
    self.adView = bannerView;
    
#if 0
    [JFYouMIManger shareInstanceWithUserID:0];
    CGRect  frame = [UIScreen mainScreen].bounds;
    [JFYouMIManger addYouMiadView:self.view frame:CGRectMake(0, frame.size.height-50, frame.size.width, 50) rootViewController:self];
#endif
}

-(void)removeYoumiAD
{
#if 0
    [JFYouMIManger removeYouMiView];
#endif
    
    [self.adView removeFromSuperview];
    self.adView = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // [m_playerbgManger pausePlay];
}
-(void)initview
{
    CGSize  size = [[UIScreen mainScreen] bounds].size;
    CGRect  frame = CGRectMake(0, 0, size.width, size.height);
    [self.view setFrame:frame];
    if (iPhone5)
    {
        self.view.layer.contents = (id)[UIImage imageNamed:@"main_bg_iphone5.png"].CGImage;
        //main_bg_withnothing
    }else
    {
        self.view.layer.contents = (id)[UIImage imageNamed:@"main_bg.png"].CGImage;
    }

    UIButton      *btnback = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
   // [btnback setImageEdgeInsets:UIEdgeInsetsMake(2, 20, 2, 20)];
    [btnback setImage:[PublicClass getImageAccordName:@"back.png"] forState:UIControlStateNormal];
    [btnback addTarget:self action:@selector(clickBackbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnback];
    

    if (!m_labelLevel)
    {
        m_labelLevel = [[JFLabelTrace alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 30) withShadowColor:[UIColor whiteColor] offset:CGSizeMake(1, 1) textColor:[UIColor orangeColor]];
        [m_labelLevel setFont:TEXTFONTWITHSIZE(25)];
        [m_labelLevel setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:m_labelLevel];
    }
    

    [m_labelLevel setText:[NSString stringWithFormat:@"%d",self.idiomModel.levelIndex]];
    [self addChargeViewInView:self.view];
    [self addAnswerInSuperview:self.view];
    [self addPropButton:self.view];
    
    


    [btnback release];


}//622150713100066826



-(void)addChargeViewInView:(UIView*)view
{
    UIImageView     *imagegoldbg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, 10,110, 28)];
   // imagegoldbg.image = [PublicClass getImageAccordName:@"Coins_bg.png"];
    imagegoldbg.userInteractionEnabled = YES;
    [view addSubview:imagegoldbg];
    imagegoldbg.tag = 10001011;
    
    UIImageView *addIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    addIcon.image = [PublicClass getImageAccordName:@"gold_icon.png"];
    [imagegoldbg addSubview:addIcon];
    
    
    JFLabelTrace   *labelicons = [[JFLabelTrace alloc] initWithFrame:CGRectMake(22, 2, 70, 24) withShadowColor:[UIColor whiteColor] offset:CGSizeMake(1, 1) textColor:[UIColor orangeColor]];
    [labelicons setBackgroundColor:[UIColor clearColor]];
    [labelicons setTextAlignment:NSTextAlignmentCenter];
    [labelicons setFont:TEXTFONTWITHSIZE(15)];
    labelicons.tag = 1001;
    [imagegoldbg addSubview:labelicons];
    
    
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddGold:)];
    [imagegoldbg addGestureRecognizer:tap];
    [tap release];
    
    
    [labelicons setText:[NSString stringWithFormat:@"%d",[[JFLocalPlayer shareInstance] goldNumber]]];
    [labelicons release];
    [addIcon release];
    [imagegoldbg release];
}


-(void)addPropButton:(UIView*)bgView
{
    CGFloat    fXpoint = 20;
    CGFloat    fYpoint = 80;
    JFPropModel  *modelTrash = [[JFPropModel alloc] initWithPropType:JFPropModelTypeTrash];
    JFPropButton  *btnTrash = [[JFPropButton alloc] initWithFrame:CGRectMake(fXpoint, fYpoint, 54,50) withModel:modelTrash];
     btnTrash.delegate =  self;
    [bgView addSubview:btnTrash];
    self.trashProp = btnTrash;
    [modelTrash release];
    [btnTrash release];
    
  
    fYpoint +=  50+20;
    JFPropModel  *modelidea = [[JFPropModel alloc] initWithPropType:JFPropModelTypeIdeaShow];
    JFPropButton  *btnIdea = [[JFPropButton alloc] initWithFrame:CGRectMake(fXpoint, fYpoint, 54, 50) withModel:modelidea];
    btnIdea.delegate =  self;
    self.ideaShowProp = btnIdea;
    [bgView addSubview:btnIdea];
    [modelidea release];
    [btnIdea release];
    
    
    
   // fYpoint -=  20;
    
    fYpoint = 80;
    fXpoint = self.view.frame.size.width-70;
    JFPropModel  *modelshare = [[JFPropModel alloc] initWithPropType:JFPropModelTypeShareForHelp];
    JFPropButton  *btnshare = [[JFPropButton alloc] initWithFrame:CGRectMake(fXpoint, fYpoint, 50, 50) withModel:modelshare];
    btnshare.delegate =  self;
    [bgView addSubview:btnshare];
    [modelshare release];
    [btnshare release];
    
    fYpoint +=  50+20;
    JFPropModel  *modelavoid = [[JFPropModel alloc] initWithPropType:JFPropModelTypeDice];
    JFPropButton  *btnavoid = [[JFPropButton alloc] initWithFrame:CGRectMake(fXpoint, fYpoint, 54, 50) withModel:modelavoid];
 //   [btnavoid setGoldIconGray:YES];
    btnavoid.delegate =  self;
    self.avoidProp = btnavoid;
    [bgView addSubview:btnavoid];
    [modelavoid release];
    [btnavoid release];
    
    
}







-(void)addAnswerInSuperview:(UIView*)bgView
{
    
    
    CGRect frame = CGRectMake(0, 50, bgView.frame.size.width, 400);
    if (!m_idiomView)
    {
        m_idiomView = [[JFIdiomDetailView alloc] initWithFrame:frame withModel:self.idiomModel];
        m_idiomView.delegate = self;
        [bgView addSubview:m_idiomView];
    }
    
    
    
    if (!self.idiomModel)
    {
        JFAlertView *av = [[JFAlertView alloc] initWithTitle:@"提示" message:@"恭喜你！\n你已经完成所有的关卡！更多精彩，请关注下一版本！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关注"];
        av.tag = 2201;
        [av show];
        [av release];
    }
}


-(void)clickAddGold:(id)sender
{
     [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];

    JFChargeViewController  *controller = [[JFChargeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    DLOG(@"clickAddGold:%@",sender);
}

-(void)clickBackbtn:(id)sender
{

    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    [self storeCurrentState];
    [self backToCheckPointControlNeedShowMaxOffset:NO];
    
    //[self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	
	 [self addYouMiAd];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetPropRemainCount
{
    self.avoidProp.propModel.remainCount = self.avoidProp.propModel.useCount;
    self.trashProp.propModel.remainCount = self.trashProp.propModel.useCount;
    self.ideaShowProp.propModel.remainCount = self.ideaShowProp.propModel.useCount;
    
   
}

-(void)setPropGrayAccordGoldNumber
{
    if (self.avoidProp.propModel.propPrice <= [[JFLocalPlayer shareInstance] goldNumber])
    {
        [self.avoidProp setGoldIconGray:NO];
    }else
    {
        [self.avoidProp setGoldIconGray:YES];
    }
    
    if (self.trashProp.propModel.propPrice <= [[JFLocalPlayer shareInstance] goldNumber])
    {
        [self.trashProp setGoldIconGray:NO];
    }else
    {
        [self.trashProp setGoldIconGray:YES];
    }
    if (self.ideaShowProp.propModel.propPrice <= [[JFLocalPlayer shareInstance] goldNumber])
    {
        [self.ideaShowProp setGoldIconGray:NO];
    }else
    {
        [self.ideaShowProp setGoldIconGray:YES];
    }
    
}


-(void)setPropGrayAccordRemainCount
{
    if (self.avoidProp.propModel.remainCount > 0)
    {
        [self.avoidProp setGoldIconGray:NO];
    }else
    {
        [self.avoidProp setGoldIconGray:YES];
    }
    
    if (self.trashProp.propModel.remainCount > 0)
    {
        [self.trashProp setGoldIconGray:NO];
    }else
    {
        [self.trashProp setGoldIconGray:YES];
    }
    if (self.ideaShowProp.propModel.remainCount > 0)
    {
        [self.ideaShowProp setGoldIconGray:NO];
    }else
    {
        [self.ideaShowProp setGoldIconGray:YES];
    }
    
}

-(void)showNetCannotUserAlert
{
    JFAlertView *av = [[JFAlertView alloc] initWithTitle:@"提示"
                                                 message:@"无法连接网络。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了"];
    [av show];
    [av release];
}
-(void)clickPropButton:(JFPropModel*)model button:(JFPropButton*)btnProp
{
    
  
    if (model.modelType == JFPropModelTypeShareForHelp)
    {
    
        
        if (![UtilitiesFunction networkCanUsed])
        {
            [self showNetCannotUserAlert];
            return;
        }
        UIImage *image = [UIImage getScreenImageWithView:self.view size:self.view.frame.size];
        [JFShareManger shareWithMsg:@"哈哈，这题目难度高吧！" image:image viewController:self];
        
    }else
    {
        /*
        if (m_idiomView.viewStatus != JFIdiomDetailViewStatusCounting)
        {
            return;
        }*/
        
        if (model.remainCount <= 0)
        {
            return;
        }
        if (model.propPrice > [[JFLocalPlayer shareInstance] goldNumber])
        {
            JFAlertView  *av = [[JFAlertView alloc] initWithTitle:@"提示" message:@"金币不足，是否购买金币?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买"];
            av.tag = 2000;
            [av show];
            [av release];
            return;
        }
        
        if ([m_idiomView isRightAnswerInForm])
        {
            return;
        }
        
        switch (model.modelType)
        {
            case JFPropModelTypeAvoidAnswer:
                [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeAvoidAnswer];
                break;
            case JFPropModelTypeIdeaShow:
                [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeIdeaShow];
                break;
            case JFPropModelTypeTrash:
                [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeTrash];
                break;
            case JFPropModelTypeDice:
                [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeDiceprop];
                break;
            default:
                break;
        }
        
        
       
        [m_idiomView usePropWithType:model.modelType];
        model.remainCount--;
        [JFLocalPlayer deletegoldNumber:model.propPrice];
        [self setPropGrayAccordGoldNumber];
        if (model.remainCount <= 0)
        {
            [btnProp setGoldIconGray:YES];
        }
        
        [JFPlayAniManger deleteGoldWithAni:model.propPrice];
        
       
    
    }
    DLOG(@"clickPropButton:%@",model);
}


-(void)JFAlertClickView:(JFAlertView *)alertView index:(JFAlertViewClickIndex)buttonIndex
{
    if (buttonIndex == JFAlertViewClickIndexRight)
    {
        if (alertView.tag == 2000)
        {
            
            JFChargeViewController  *controller = [[JFChargeViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            //JFChargeView  *chargeView = [[JFChargeView alloc] initWithFrame:CGRectZero];
           // [chargeView show];
          //  [chargeView release];
        }else if (alertView.tag == 3000)
        {
            NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",832088951];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
    
    if (alertView.tag == 2201)
    {
        if (JFAlertViewClickIndexRight == buttonIndex)
        {
            NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",832088951];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (BOOL)shouldAutorotate
{
    DLOG(@"shouldAutorotate");
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskPortrait;
}




-(void)refreshSelfView:(id)Thread
{
    //gold_icon
    [m_labelLevel setText:[NSString stringWithFormat:@"%d",self.idiomModel.levelIndex]];
    UIView   *supergoldview = [self.view viewWithTag:10001011];
    UILabel *labelIcon = (UILabel*)[supergoldview viewWithTag:1001];
    [labelIcon setText:[NSString stringWithFormat:@"%d",[[JFLocalPlayer shareInstance] goldNumber]]];
}


#pragma mark JFIdiomDetailViewDelegate


-(JFPuzzleModel*)getAnotherpuzzleModel
{
    
    int levelindex = [[JFLocalPlayer shareInstance] lastLevel];
    [JFSQLManger UpdateLevelIndex:-1 byNowindex:levelindex];
    JFPuzzleModel *model = [JFSQLManger getOnePuzzleModelByLevel:levelindex];
    return model;
}
-(void)answerIdiomSuc:(JFPuzzleModel*)model isUsedAvoidprop:(BOOL)isUsed isTimeOut:(BOOL)isTimeOut wrontTime:(int)wrongTime
{
    
    


    int     goldNumber = 20;
    
    if (model.isAnswered)
    {
        goldNumber = 2;
 
    }else
    {

        goldNumber = 20;

        if (self.idiomModel.levelIndex == 3)
        {
            JFAlertView *av = [[JFAlertView alloc] initWithTitle:@"提示" message:@"请赐一个5星评价吧，大人！" delegate:self cancelButtonTitle:@"残忍拒绝" otherButtonTitles:@"赐个5星"];
            av.tag = 3000;
            [av show];
            [av release];
        }
       
    }
    if (isUsed)
    {
        goldNumber = 0;
    }
    


    
    
    
   [JFSQLManger getOnePuzzleModelByLevel:self.idiomModel.levelIndex+1];
    
    
    [JFSQLManger setLevelAnswerAndUnlocked:self.idiomModel.levelIndex];
    [JFSQLManger setLevelUnlocked:self.idiomModel.levelIndex+1];
    
    JFPuzzleModel    *lastModel = self.idiomModel;
    if (!lastModel.isAnswered)
    {
        [[JFLocalPlayer shareInstance] setLastLevel:self.idiomModel.levelIndex+1];
        [JFSQLManger updateUserLevelNumberToDB:self.idiomModel.levelIndex+1 player:[JFLocalPlayer shareInstance]];
        [[JFLocalPlayer shareInstance] setLastLevel:self.idiomModel.levelIndex+1];
    }
    
    [JFLocalPlayer addgoldNumber:goldNumber];
    [JFPlayAniManger addGoldWithAni:goldNumber];
    
    
    BOOL  islast = ![[JFSQLManger getAllUnAnsweredPuzzleInfoFromDB] count];
    UIImage  *image = [UIImage getScreenImageWithView:self.view size:self.view.frame.size];
    JFAnswerRightViewController *controler = [[JFAnswerRightViewController alloc] initWithFrame:CGRectZero withModel:model gold:goldNumber islastidiom:islast withImage:image];
    controler.delegate = self;
    [self.navigationController pushViewController:controler animated:NO];
    [controler release];
    
    DLOG(@"answerIdiomSuc:%@",model);
}


-(void)answerIdiomOverTime:(JFPuzzleModel *)model
{
    /*
    if (!model.isAnswed)
    {
         [JFLocalPlayer deletegoldNumber:30];
        [JFPlayAniManger deleteGoldWithAni:30];
    }else
    {
         [JFLocalPlayer deletegoldNumber:10];
        [JFPlayAniManger deleteGoldWithAni:10];
    }
   
    [self refreshSelfView:nil];
    if ([[JFLocalPlayer shareInstance] goldNumber] <= 0)
    {
        [self addFreeGoldWithCountDown:30];
        
    }*/
    DLOG(@"answerIdiomOverTime:%@",model);
}


-(void)startNextIdiom:(JFPuzzleModel*)TempidiomModel
{
    
   
    [self resetPropRemainCount];
    [self setPropGrayAccordGoldNumber];
    
    self.idiomModel = TempidiomModel;
    
    
#if AUTOSHOWANSWER
    iToast  *toast = [[iToast alloc] initWithText:self.idiomModel.puzzleAnswer];
    [toast show];
    [toast release];
#endif
    [self refreshSelfView:nil];
    [m_idiomView updateViewAccordModel:TempidiomModel];
    [m_idiomView startAnswer:30];
    [JFSQLManger setLevelUnlocked:self.idiomModel.levelIndex];
    
    [self checkNeedClickAvoidAnswerAuto];
}


-(void)checkNeedClickAvoidAnswerAuto
{
#if DEBUG
#if NEEDCLICKAVOIDAUTO
    [self clickPropButton:self.avoidProp.propModel button:self.avoidProp];
#endif
#endif
    
}

#pragma mark JFAnswerRightViewDelegate
-(void)clickToshare:(id)sender
{
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    
    if (![UtilitiesFunction networkCanUsed])
    {
        [self showNetCannotUserAlert];
        return;
    }
    UIImage *image = [UIImage getScreenImageWithView:self.view size:self.view.frame.size];
    [JFShareManger shareWithMsg:@"哈哈，这题目难度高吧！" image:image viewController:sender];
    DLOG(@"clickToshare:%@",sender);
}
-(void)clickToNextIdiom:(JFPuzzleModel*)model addGoldNumber:(int)number;
{
    
    int index = model.levelIndex+1;
    JFPuzzleModel   *nextModel = [JFSQLManger getOnePuzzleModelByLevel:index];
 
    if (nextModel)
    {
        [self startNextIdiom:nextModel];
    }else
    {
        //[self backToCheckPointControlNeedShowMaxOffset:YES];
        DLOG(@" clickToNextIdiom  lastidiom");
    }
    
}
-(void)clickMoreIdioms:(id)sender addGoldNumber:(int)number
{
    
    JFAlertView *av = [[JFAlertView alloc] initWithTitle:@"提示" message:@"恭喜你！\n你已经完成所有的关卡！更多精彩，请关注下一版本！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关注"];
    av.tag = 2201;
    [av show];
    [av release];
    
    //[self backToCheckPointControlNeedShowMaxOffset:YES];
    DLOG(@"clickMoreIdioms:%@",sender);
}


-(void)clickBackButtonInAnswerview:(id)sender
{
    [self backToCheckPointControlNeedShowMaxOffset:NO];
}

-(void)backToCheckPointControlNeedShowMaxOffset:(BOOL)bNeedShowMaxOff
{

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark    JFFreeGoldVewDelegate

-(void)addFreeGoldWithCountDown:(int)countDownSeconds
{
    
    
}
-(void)clickToAddGoldNumber:(int)addgoldNumber
{
    
    m_idiomView.userInteractionEnabled = YES;
    [JFLocalPlayer addgoldNumberWithNoAudio:addgoldNumber];
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeGainGold];
    [JFPlayAniManger addGoldWithAni:addgoldNumber];
 
    
}
-(void)clickToGainreward:(id)thread
{
    DLOG(@"clickToGainreward:%@",thread);
}

-(void)cleanStoreData:(id)Thread
{
    NSString    *strStoreKey = [NSString stringWithFormat:@"NormalLevelInfo%@%d",[[JFLocalPlayer shareInstance] userID],self.idiomModel.levelIndex];
    NSString    *strStoreFreeKey = [NSString stringWithFormat:@"NormalLevelInfoReward%@",[[JFLocalPlayer shareInstance] userID]];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:strStoreFreeKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:strStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)storeCurrentState
{
    
    NSString    *strStoreKey = [NSString stringWithFormat:@"NormalLevelInfo%@%d",[[JFLocalPlayer shareInstance] userID],self.idiomModel.levelIndex];
    int  nowtimer = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary     *dicInfo = [NSMutableDictionary dictionary];
    
    
    if (!m_idiomView.answerRight)
    {
        if (self.idiomModel.levelIndex > 3)
        {
            [dicInfo setObject:@(nowtimer) forKey:@"answerTimerInterval"];
            [dicInfo setObject:@(m_idiomView.remainCountDown) forKey:@"answerremainCountDown"];
            [dicInfo setObject:@(self.avoidProp.propModel.remainCount) forKey:@"avoidPropremainCount"];
            [dicInfo setObject:@(self.trashProp.propModel.remainCount) forKey:@"trashPropPropremainCount"];
            [dicInfo setObject:@(self.ideaShowProp.propModel.remainCount) forKey:@"ideaShowPropremainCount"];
            [dicInfo setObject:[m_idiomView getNowAnswerStr] forKey:@"ANSWERSTR"];
            [dicInfo setObject:[m_idiomView getNowOptionStr] forKey:@"OPTIONSTR"];
            [[NSUserDefaults standardUserDefaults] setObject:dicInfo forKey:strStoreKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
       
        
    }
    DLOG(@"storeCurrentState:%@  strStoreFreeKey",dicInfo);
}

-(void)initViewAccordStoreData
{
    

    NSString    *strStoreKey = [NSString stringWithFormat:@"NormalLevelInfo%@%d",[[JFLocalPlayer shareInstance] userID],self.idiomModel.levelIndex];
 //   NSString    *strStoreFreeKey = [NSString stringWithFormat:@"NormalLevelInfoReward%@",[[JFLocalPlayer shareInstance] userID]];
    NSString    *strStoreEnterKey = [NSString stringWithFormat:@"NormalLevelEnter%@",[[JFLocalPlayer shareInstance] userID]];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:strStoreEnterKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary    *dicLevelinfo = [[NSUserDefaults standardUserDefaults] valueForKey:strStoreKey];
    NSTimeInterval  nowtimeinter = [[NSDate date] timeIntervalSince1970];
    if (dicLevelinfo && [[dicLevelinfo allKeys] count])
    {
        
      
        int  oldtimerinter = [[dicLevelinfo objectForKey:@"answerTimerInterval"] intValue];
        int remainCount = [[dicLevelinfo objectForKey:@"answerremainCountDown"] intValue];
        int countdown = remainCount-(nowtimeinter-oldtimerinter);
        int avoidCount = [[dicLevelinfo valueForKey:@"avoidPropremainCount"] intValue];
        int ideaCount = [[dicLevelinfo valueForKey:@"ideaShowPropremainCount"] intValue];
        int trashCount = [[dicLevelinfo valueForKey:@"trashPropPropremainCount"] intValue];
        
        //  [dicInfo setObject:[m_idiomView getNowAnswerStr] forKey:@"ANSWERSTR"];
       // [dicInfo setObject:[m_idiomView getNowOptionStr] forKey:@"OPTIONSTR"];
        
        NSString    *strOption = [dicLevelinfo valueForKey:@"OPTIONSTR"];
        NSString    *strAnswer = [dicLevelinfo valueForKey:@"ANSWERSTR"];
        self.avoidProp.propModel.remainCount = avoidCount;
        self.ideaShowProp.propModel.remainCount = ideaCount;
        self.trashProp.propModel.remainCount = trashCount;
        
        if (self.avoidProp.propModel.remainCount  <= 0)
        {
            [self.avoidProp setGoldIconGray:YES];
        }
        if (self.ideaShowProp.propModel.remainCount  <= 0)
        {
            [self.ideaShowProp setGoldIconGray:YES];
        }
        if (self.trashProp.propModel.remainCount  <= 0)
        {
            [self.trashProp setGoldIconGray:YES];
        }
        
        [self setPropGrayAccordGoldNumber];
        if (remainCount <= 0)
        {
            [m_idiomView setIsFailed:YES];
        }
        
          DLOG(@"initViewAccordStoreData %@ \ncountdown:%d remainCount:%d nowtimeinter：%f oldtimer:%d  diclevelInfo:%@",dicLevelinfo,countdown,remainCount,nowtimeinter,oldtimerinter,dicLevelinfo);
        if (countdown > 30)
        {
            countdown = 30;
        }
        [m_idiomView setStringAfterLoadModel:strOption answerStr:strAnswer];
        [m_idiomView startAnswer:countdown];
        
    }else
    {
        [m_idiomView startAnswer:30];
    }
    
    if ([[JFLocalPlayer shareInstance] goldNumber] <= 0)
    {
        [self showFreeGiftView];
    }


    
    [self cleanStoreData:nil];
}


-(void)showFreeGiftView
{
    
    NSDictionary   *dicInfo = [[NSUserDefaults standardUserDefaults] valueForKey:@"storeFreeGoldCount"];
    if (dicInfo)
    {
        int count = [[dicInfo valueForKey:@"count"] intValue];
        if (count >= 3)
        {
            return;
        }
    }
    /*
    JFFreeGiftView  *giftView = [[JFFreeGiftView alloc] initWithFrame:CGRectZero];
    giftView.delegate = self;
    [giftView show];
    [giftView release];*/
    
}


#pragma mark  freeGiftView

-(void)getFreeGiftReward:(id)sender
{
    NSDictionary   *dicInfo = [[NSUserDefaults standardUserDefaults] valueForKey:@"storeFreeGoldCount"];
    
    int count = 0;
    if (dicInfo)
    {
        count = [[dicInfo valueForKey:@"count"] intValue];
    }
    
    count++;
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithObjectsAndKeys:@(count),@"count", nil] forKey:@"storeFreeGoldCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    int  rewardnumber = 500;//[sender getRewardNumber];
    [JFPlayAniManger addGoldWithAni:rewardnumber];
    [JFLocalPlayer addgoldNumber:rewardnumber];
    
    [self refreshSelfView:nil];

    
}


#pragma ADBannerViewDelegate

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    DLOG(@"bannerViewWillLoadAd:%@",banner);
}

/*!
 * @method bannerViewDidLoadAd:
 *
 * @discussion
 * Called each time a banner loads a new ad. Once a banner has loaded an ad, it
 * will display it until another ad is available.
 *
 * It's generally recommended to show the banner view when this method is called,
 * and hide it again when bannerView:didFailToReceiveAdWithError: is called.
 */
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    DLOG(@"bannerViewDidLoadAd:%@",banner);
}

/*!
 * @method bannerView:didFailToReceiveAdWithError:
 *
 * @discussion
 * Called when an error has occurred while attempting to get ad content. If the
 * banner is being displayed when an error occurs, it should be hidden
 * to prevent display of a banner view with no ad content.
 *
 * @see ADError for a list of possible error codes.
 */
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    DLOG(@"bannerView:%@ error:%@",banner,error);
    
}

/*!
 * @method bannerViewActionShouldBegin:willLeaveApplication:
 *
 * Called when the user taps on the banner and some action is to be taken.
 * Actions either display full screen content modally, or take the user to a
 * different application.
 *
 * The delegate may return NO to block the action from taking place, but this
 * should be avoided if possible because most ads pay significantly more when
 * the action takes place and, over the longer term, repeatedly blocking actions
 * will decrease the ad inventory available to the application.
 *
 * Applications should reduce their own activity while the advertisement's action
 * executes.
 */
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

/*!
 * @method bannerViewActionDidFinish:
 *
 * Called when a modal action has completed and control is returned to the
 * application. Games, media playback, and other activities that were paused in
 * bannerViewActionShouldBegin:willLeaveApplication: should resume at this point.
 */
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}



@end
