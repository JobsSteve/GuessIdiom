//
//  JFSetViewController.m
//  GuessGuess
//
//  Created by Ran Jingfu on 3/3/14.
//  Copyright (c) 2014 Ran Jingfu. All rights reserved.
//
#import "PublicClass.h"
#import "JFSetViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JFButtonTrace.h"
#import "JFAppSet.h"
#import "JFLocalPlayer.h"
#import "iToast.h"
@interface JFSetViewController ()

@end

@implementation JFSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
	// Do any additional setup after loading the view.
}



-(void)randQuestionInView:(int)count view:(UIView*)view
{
    CGFloat  fminwidth = 10;
    CGFloat  fmaxWidth = view.frame.size.width;
    CGFloat  fminheight = 44;
    CGFloat  fmaxHeight = view.frame.size.width;
    
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

-(void)initView
{
    
    CGRect frame = self.view.frame;
    if (iPhone5)
    {
     
        self.view.layer.contents = (id)[PublicClass getImageAccordName:@"set_bg_iphone5.jpg"].CGImage;
    }else
    {
        self.view.layer.contents = (id)[PublicClass getImageAccordName:@"set_bg.jpg"].CGImage;
    }
    

    [self randQuestionInView:20 view:self.view];
    
    UIButton  *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [btnBack setBackgroundImage:[PublicClass getImageAccordName:@"back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    [btnBack release];
    
    JFLabelTrace    *labelVoice = [[JFLabelTrace alloc] initWithFrame:CGRectMake(0, 120, frame.size.width/2, 30) withShadowColor:[UIColor whiteColor] offset:CGSizeMake(1, 1) textColor:[UIColor orangeColor]];
    [labelVoice setText:@"音效"];
    [labelVoice setFont:TEXTFONTWITHSIZE(22)];
    [labelVoice setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:labelVoice];
    [labelVoice release];
    
    UISwitch       *swithVoice = [[UISwitch alloc] initWithFrame:CGRectMake(frame.size.width/2+(frame.size.width/2-120)/2, 120, 120, 30)];
    [swithVoice setOn:(int)[[JFAppSet shareInstance] SoundEffect]];
    [swithVoice addTarget:self action:@selector(voiceValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:swithVoice];
    [swithVoice release];
    
    
    
    JFLabelTrace    *labelbg = [[JFLabelTrace alloc] initWithFrame:CGRectMake(0, 180, frame.size.width/2, 30) withShadowColor:[UIColor whiteColor] offset:CGSizeMake(1, 1) textColor:[UIColor orangeColor]];
    [labelbg setText:@"音乐"];
    [labelbg setFont:TEXTFONTWITHSIZE(22)];
    [labelbg setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:labelbg];
    [labelbg release];
    
    UISwitch       *swithbg = [[UISwitch alloc] initWithFrame:CGRectMake(frame.size.width/2+(frame.size.width/2-120)/2, 180, 120, 30)];
    [swithbg setOn:(int)[[JFAppSet shareInstance] bgvolume]];
    [swithbg addTarget:self action:@selector(bgVolumeValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:swithbg];
    [swithbg release];
   
    
    
    JFButtonTrace    *btnStat = [[JFButtonTrace alloc] initWithFrame:CGRectMake((frame.size.width-180)/2, frame.size.height-140, 180, 33) withshadowColor:[UIColor whiteColor] withTextColor:[UIColor orangeColor] title:@"重置游戏"];
    //[btnStat setTitle:@"开始游戏" forState:UIControlStateNormal];
    [btnStat setBackgroundImage:[UIImage imageNamed:@"btn_begin.png"] forState:UIControlStateNormal];
    // [btnStat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnStat setTextFont:TEXTFONTWITHSIZE(17)];
    [btnStat addTarget:self action:@selector(clickReset:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStat];
    [btnStat release];
    

    
}


-(void)clickReset:(id)sender
{
    
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    JFAlertView *av = [[JFAlertView alloc] initWithTitle:@"提示" message:@"重置游戏将会清空您的金币和已玩关数，确认重置?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重置"];
    [av show];
    [av release];
    DLOG(@"clickReset:%@",sender);
}

-(void)bgVolumeValueChange:(UISwitch*)switcher
{
    
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    [[JFAppSet shareInstance] setBgvolume:switcher.isOn];
}
-(void)voiceValueChange:(UISwitch*)switcher
{
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    [[JFAppSet shareInstance] setSoundEffect:switcher.isOn];
}

-(void)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)JFAlertClickView:(JFAlertView *)alertView index:(JFAlertViewClickIndex)buttonIndex
{
    if (buttonIndex == JFAlertViewClickIndexRight)
    {
        [JFLocalPlayer resetUserInfo];
        
        iToast  *toast = [[iToast alloc] initWithText:@"重置成功"];
        [toast show];
        [toast release];
    }
}

@end
