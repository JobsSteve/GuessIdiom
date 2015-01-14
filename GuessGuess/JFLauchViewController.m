//
//  JFViewController.m
//  GuessGuess
//
//  Created by Ran Jingfu on 2/24/14.
//  Copyright (c) 2014 Ran Jingfu. All rights reserved.
//

#import "JFLauchViewController.h"
#import "JFSQLManger.h"
#import "JFButtonTrace.h"
#import <QuartzCore/QuartzCore.h>
#import "PublicClass.h"
#import "JFNormalAnswerViewController.h"
#import "JFChargeViewController.h"
@interface JFLauchViewController ()

@end

@implementation JFLauchViewController


-(void)randQuestionInView:(int)count view:(UIView*)view
{
    CGFloat  fminwidth = 10;
    CGFloat  fmaxWidth = view.frame.size.width-15;
    CGFloat  fminheight = 44;
    CGFloat  fmaxHeight = view.frame.size.width-20;
    
    for (unsigned i = 0;i< count;i++)
    {
        srandom((unsigned)time(NULL)+i);
        CGFloat franxpoint = random()%(int)(fmaxWidth-fminwidth)+fminwidth;
        srandom((unsigned)time(NULL)+i+count);
        CGFloat franypoint = random()%(int)(fmaxHeight-fminheight)+fminheight;
        srandom((unsigned)time(NULL)+count-i);
        UIImageView  *subview = [[UIImageView alloc] initWithFrame:CGRectMake(franxpoint, franypoint, 15, 20)];
        subview.image = [UIImage imageNamed:[NSString stringWithFormat:@"question_icon%ld.png",random()%4+1]];
        [view addSubview:subview];
        [subview release];
    }
    
 
    
    
}
- (void)viewDidLoad
{

    [super viewDidLoad];
    
    [JFSQLManger createTable];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:YES];
    //NSMutableArray  *array = [JFSQLManger getAllPuzzleInfoFromDB];
   // DLOG(@"getAllPuzzleInfoFromDB:%@",array);
    
    
    if (iPhone5)
    {
        self.view.layer.contents = (id)[UIImage imageNamed:@"main_bg_iphone5.png"].CGImage;
    }else
    {
        self.view.layer.contents = (id)[UIImage imageNamed:@"main_bg.png"].CGImage;
    }
    
    [self initView];
    
    
 

	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [m_audioPlayer stopPlay];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startAniIcon];
    [self addConLoginAlertView];
    
    if (!m_audioPlayer)
    {
        m_audioPlayer = [[JFAudioPlayerManger alloc] initWithType:JFAudioPlayerMangerTypeMainBg];
    }
    
    [m_audioPlayer playWithLoops:YES];
}
-(void)dealloc
{
    
    [m_audioPlayer release];
    m_audioPlayer = nil;
    [super dealloc];
}


-(void)startAniIcon
{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAniIcon) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    UILabel *label = (UILabel*)[self.view viewWithTag:1000];
    
    UIImageView  *imageView = (UIImageView*)[self.view viewWithTag:1243];
    [imageView.layer removeAllAnimations];
    [imageView removeFromSuperview];
    
    
    CGRect  frame = self.view.bounds;
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-128)/2, 150, 128, 128)];
    imageView.image = [PublicClass getImageAccordName:@"guess_idioms.png"];
    [self.view insertSubview:imageView belowSubview:label];
    imageView.tag = 1243;
    [imageView release];

    
    CABasicAnimation  *ani = [CABasicAnimation aniRotate:1.5 tovalue:M_PI fromValue:0];
    ani.repeatCount = CGFLOAT_MAX;
    
    CABasicAnimation  *scale = [CABasicAnimation aniWithScale:1.5 tovalue:1.65 fromValue:1];
    scale.repeatCount = CGFLOAT_MAX;
    
    [imageView.layer addAnimation:ani forKey:nil];
    [imageView.layer addAnimation:scale forKey:nil];
}
-(void)initView
{

    
    [self randQuestionInView:40 view:self.view];
    CGRect  frame = self.view.bounds;
    JFLabelTrace  *labelName = [[JFLabelTrace alloc] initWithFrame:CGRectMake(0, 180, 320, 60) withShadowColor:[UIColor redColor] offset:CGSizeMake(1, 1) textColor:[UIColor orangeColor]];
    [labelName setText:@"猜 谜 语"];
    [labelName setFont:TEXTFONTWITHSIZE(50)];
    labelName.tag = 1000;
    [labelName setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:labelName];
    [labelName release];
    
    JFButtonTrace    *btnStat = [[JFButtonTrace alloc] initWithFrame:CGRectMake((frame.size.width-180)/2, frame.size.height-140, 180, 33) withshadowColor:[UIColor blackColor] withTextColor:[UIColor orangeColor] title:@"开始游戏"];
   //[btnStat setTitle:@"开始游戏" forState:UIControlStateNormal];
    [btnStat setBackgroundImage:[UIImage imageNamed:@"btn_begin.png"] forState:UIControlStateNormal];
   // [btnStat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnStat setTextFont:TEXTFONTWITHSIZE(17)];
    [btnStat addTarget:self action:@selector(clickStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStat];
    [btnStat release];
    
    
    
    
    UIButton        *btnGold = [[UIButton alloc] initWithFrame:CGRectMake(15, frame.size.height-60, 50, 50)];
    [btnGold setBackgroundImage:[PublicClass getImageAccordName:@"gold_icon.png"] forState:UIControlStateNormal];
    [btnGold addTarget:self action:@selector(clickGold:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGold];
    [btnGold release];
    
    
    UIButton        *btnset = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-50, frame.size.height-50, 37, 37)];
    [btnset setBackgroundImage:[PublicClass getImageAccordName:@"main_set.png"] forState:UIControlStateNormal];
    [btnset addTarget:self action:@selector(clickSet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnset];
    [btnset release];
    
    
    
    UIButton        *btnRecomand = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-50, 20, 32, 33)];
    [btnRecomand setBackgroundImage:[PublicClass getImageAccordName:@"apprecommand_icon.png"] forState:UIControlStateNormal];
    [btnRecomand addTarget:self action:@selector(clickRecomand:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addSubview:btnRecomand];
    [btnRecomand release];
    
    
    
    ///apprecommand_icon
    [self startAniIcon];
    
}


-(void)clickRecomand:(id)sender
{
#if 0
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    JFYouMIManger   *shance = [JFYouMIManger shareInstanceWithUserID:0];
    [shance showYouMiPointAppViewController];
#endif
}

-(void)addConLoginAlertView
{
    
    
    int conginDays = [[JFLocalPlayer shareInstance] getConloginDays];
    if (conginDays < 1)
    {
        return;
    }
    
    
    NSString    *strMsg = [NSString stringWithFormat:@"亲，今天是您第一次登录，系统奖励200金币哦！"];
    JFAlertView     *av = [[JFAlertView alloc] initWithTitle:@"提示"
                                                     message:strMsg
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"我知道了"];
    av.tag = 100;
    [av show];
    [av release];
}


-(void)JFAlertClickView:(JFAlertView *)alertView index:(JFAlertViewClickIndex)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == JFAlertViewClickIndexRight)
        {
            [JFLocalPlayer addgoldNumber:200];
            [JFLocalPlayer storeConLoginDays:1];
        }
    }
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickSet:(id)sender
{
   
    
    
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    JFSetViewController *set = [[JFSetViewController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
    [set release];
    DLOG(@"clickSet:%@",sender);
}
-(void)clickGold:(id)sender
{
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    JFChargeViewController  *controller = [[JFChargeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    DLOG(@"clickGold:%@",sender);
}

-(void)clickStart:(JFButtonTrace*)sender
{
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    DLOG(@"clickStart:%@",sender);
 //   [self checkChinesString];
    
    JFNormalAnswerViewController    *controller = [[JFNormalAnswerViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)checkChinesString
{
    
    NSError *error = nil;
    NSString *strFilePath = [[NSBundle mainBundle] pathForResource:@"chineseTable" ofType:@"txt"];
    if (!strFilePath)
    {
        strFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"chineseTable.txt"];
    }
    NSString    *strText = [NSString stringWithContentsOfFile:strFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        DLOG(@"checkChinesString error:%@",error);
    }
    
    
    NSString    *strLast = @"";
    for (int i = 0; i < [strText length]; i++)
    {
        NSString  *strTemp = [strText substringWithRange:NSMakeRange(i, 1)];
        if ([UtilitiesFunction checkIsChineseString:strTemp])
        {
            strLast = [strLast stringByAppendingString:strTemp];
        }else
        {
            DLOG(@"strTemp:%@ is not chinese",strTemp);
        }
    }
    
    DLOG(@"strLast:%@",strLast);
}

@end
