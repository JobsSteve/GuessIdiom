//
//  JFAnswerRightView.m
//  GuessImageWar
//
//  Created by ran on 13-12-17.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFAnswerRightView.h"
#import "PublicClass.h"
#import "UtilitiesFunction.h"
#import "JFLocalPlayer.h"
#import "JFAudioPlayerManger.h"
#import "JFAppSet.h"
#import "CABasicAnimation+someAniForProp.h"
#define NEXTBUTTONTAG           123443
#define NEEDAUTOCLIKNEXT        0
@implementation JFAnswerRightView
@synthesize delegate;
@synthesize model;
@synthesize addGoldNumber;
- (id)initWithFrame:(CGRect)frame  withModel:(JFPuzzleModel*)Tempmodel  gold:(int)rewardNumber progress:(CGFloat)fprogress islastidiom:(BOOL)islast wrongtime:(int)wrongTime
{
    
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self)
    {
        self.model = Tempmodel;
        
        self.addGoldNumber = rewardNumber;
        self.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];

        
        UIButton      *btnback = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [btnback setImage:[PublicClass getImageAccordName:@"back.png"] forState:UIControlStateNormal];
        [btnback addTarget:self action:@selector(clickBackbtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnback];
        
        
        CGFloat     fypoint = 100;
        
        
        
        UILabel *lableright = [[UILabel alloc] initWithFrame:CGRectMake(0, fypoint, self.frame.size.width, 30)];
        [lableright setBackgroundColor:[UIColor clearColor]];
        [lableright setTextColor:[UIColor orangeColor]];
        [lableright setText:@"您猜对了!"];
        [lableright setFont:TEXTFONTWITHSIZE(28)];
        [lableright setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lableright];
        [lableright release];
        
        
        CABasicAnimation    *ani = [CABasicAnimation aniWithScale:1.0 tovalue:2 fromValue:1];
        ani.repeatCount = CGFLOAT_MAX;
        [lableright.layer addAnimation:ani forKey:nil];
        
        
        
        
        fypoint += 30+50;
        UILabel *lableanswer = [[UILabel alloc] initWithFrame:CGRectMake(0, fypoint, self.frame.size.width, 24)];
        [lableanswer setBackgroundColor:[UIColor clearColor]];
        [lableanswer setTextColor:[UIColor orangeColor]];
        [lableanswer setText:[NSString stringWithFormat:@"谜底:%@",Tempmodel.puzzleAnswer]];
        [lableanswer setFont:TEXTFONTWITHSIZE(20)];
        [lableanswer setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lableanswer];
        [lableanswer release];
        
        
        
        fypoint += 24+50;
        JFLabelTrace  *labeljiangli = [[JFLabelTrace alloc] initWithFrame:CGRectMake(80, fypoint, 60, 24) withShadowColor:[UIColor colorWithRed:0x07*1.0/255.0 green:0x42*1.0/255.0 blue:0x85*1.0/255.0 alpha:1] offset:CGSizeMake(1, 1) textColor:[UIColor orangeColor]];
        [labeljiangli setBackgroundColor:[UIColor clearColor]];
        [labeljiangli setText:@"奖励："];
        [labeljiangli setFont:TEXTFONTWITHSIZE(20)];
        [self addSubview:labeljiangli];
        [labeljiangli release];
        
        
        UIImageView *goldiconview = [[UIImageView alloc] initWithFrame:CGRectMake(80+60+5, fypoint-5, 34, 34)];
        goldiconview.image = [PublicClass getImageAccordName:@"gold_icon.png"];
        [self addSubview:goldiconview];
        [goldiconview release];
        
        JFLabelTrace  *labelgoldvalue = [[JFLabelTrace alloc] initWithFrame:CGRectMake(80+60+5+34+5, fypoint, 100, 24) withShadowColor:[UIColor colorWithRed:0x07*1.0/255.0 green:0x42*1.0/255.0 blue:0x85*1.0/255.0 alpha:1] offset:CGSizeMake(1, 1) textColor:[UIColor orangeColor]];
        [labelgoldvalue setBackgroundColor:[UIColor clearColor]];
        [labelgoldvalue setText:[NSString stringWithFormat:@"%d",rewardNumber]];
        [labelgoldvalue setFont:TEXTFONTWITHSIZE(20)];
        [self addSubview:labelgoldvalue];
        [labelgoldvalue release];
        

        fypoint = self.frame.size.height-230+(iPhone5?0:50);
        JFButtonTrace   *shareBtn = [[JFButtonTrace alloc] initWithFrame:CGRectMake((self.frame.size.width-181)/2, fypoint, 181, 70) withshadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] withTextColor:[UIColor orangeColor] title:@"分享"];
        [shareBtn setBackgroundImage:[PublicClass getImageAccordName:@"answerright_btn_bg.png"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        [shareBtn release];
        
        
        
        fypoint += 70+10;
        if (islast)
        {
            JFButtonTrace   *moreBtn = [[JFButtonTrace alloc] initWithFrame:CGRectMake((self.frame.size.width-181)/2, fypoint, 181, 70) withshadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] withTextColor:[UIColor orangeColor] title:@"更多关卡"];
            [moreBtn setBackgroundImage:[PublicClass getImageAccordName:@"answerright_btn_bg.png"] forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:moreBtn];
            [moreBtn release];
            
        }else
        {
            
            JFButtonTrace   *nextBtn = [[JFButtonTrace alloc] initWithFrame:CGRectMake((self.frame.size.width-181)/2, fypoint, 181, 70) withshadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] withTextColor:[UIColor orangeColor] title:@"下一关"];
            [nextBtn setBackgroundImage:[PublicClass getImageAccordName:@"answerright_btn_bg.png"] forState:UIControlStateNormal];
            [nextBtn addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:nextBtn];
            nextBtn.tag = NEXTBUTTONTAG;
            [nextBtn release];
        }
        
        
       // [self addBannerView];

        // Initialization code
    }
    return self;
}


-(void)changeInterface:(NSNotification*)note
{
    
    int type = [[[note userInfo] valueForKey:UIApplicationStatusBarOrientationUserInfoKey] intValue];
    if (type == 4)
    {
        [self setTransform:CGAffineTransformMakeRotation(-M_PI_2*3)];
    }else if (type == 3)
    {
        [self setTransform:CGAffineTransformMakeRotation(M_PI_2*3)];
    }
    DLOG(@"note:%@  note userInfo:%@",note,[note userInfo]);
}

-(void)clickShareButton:(id)sender
{
    
    if (delegate  && [delegate respondsToSelector:@selector(clickToshare:)])
    {
        [delegate clickToshare:sender];
    }
    DLOG(@"clickShareButton:%@",sender);
    
    //[self removeFromSuperview];
}


-(void)checkNeedAutoClickNext
{
#if DEBUG
#if NEEDAUTOCLIKNEXT
    UIButton  *btn = (UIButton*)[self viewWithTag:NEXTBUTTONTAG];
    
    if (btn)
    {
        [self performSelector:@selector(clickNextButton:) withObject:nil afterDelay:0.05];
    }
#endif
#endif
}

-(void)clickBackbtn:(id)sender
{
     [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    if (delegate && [delegate respondsToSelector:@selector(clickBackButtonInAnswerview:)])
    {
        [delegate clickBackButtonInAnswerview:sender];
    }
    [self removeFromSuperview];
    
}
-(void)clickMoreButton:(id)sender
{
     [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    if (delegate  && [delegate respondsToSelector:@selector(clickMoreIdioms:addGoldNumber:)])
    {
        [delegate clickMoreIdioms:sender addGoldNumber:self.addGoldNumber];
    }
    DLOG(@"clickMoreButton:%@",sender);
    
    [self removeFromSuperview];
}
-(void)clickNextButton:(id)sender
{
     [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    
    if (delegate && [delegate respondsToSelector:@selector(clickToNextIdiom:addGoldNumber:)])
    {
        [delegate clickToNextIdiom:self.model addGoldNumber:addGoldNumber];
    }
    DLOG(@"clickNextButton:%@",sender);
    
    [self removeFromSuperview];
}
-(void)show
{

    UIWindow  *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.center = window.center;
    [self checkNeedAutoClickNext];
    [window addSubview:self];
    
    
   
}
-(void)addobserverForBarOrientationNotification
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInterface:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.model = nil;
    self.delegate = nil;
    DLOG(@"JFAnswerRightView dealloc");
    [super dealloc];
}



-(void)addBannerView
{
   //[JFSendAdInfo sendShowAD:[[JFLocalPlayer shareInstance] userID]];
}


#if 0
//immob
#pragma mark -
/**
 *查询积分接口回调
 */
- (void) immobViewQueryScore:(NSUInteger)score WithMessage:(NSString *)message
{
     DLOG(@"immobViewQueryScore:%d message:%@",score,message);
    // [uA release];
}

/**
 *减少积分接口回调
 */
- (void) immobViewReduceScore:(BOOL)status WithMessage:(NSString *)message
{
    DLOG(@"immobViewReduceScore:%d message:%@",status,message);
}

- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode
{
    
    NSLog(@"errorCode:%i",errorCode);
}
- (void) onDismissScreen:(immobView *)immobView
{
    
    [m_bannerView removeFromSuperview];
     NSLog(@"onDismissScreen:%@",immobView);
}


/**
 * Called when an page is created in front of the app.
 * 当广告页面被创建并且显示在覆盖在屏幕上面时调用本方法。
 */
- (void) onPresentScreen:(immobView *)immobView;
{
    [immobView setFrame:CGRectMake((480-immobView.frame.size.width)/2, 0, immobView.frame.size.width, immobView.frame.size.height)];
    
    immobView.center = CGPointMake(self.frame.size.width/2, immobView.frame.size.height/2);
    DLOG(@"onPresentScreen:%@",immobView);
}
/**
 *email phone sms等所需要
 *返回当前添加immobView的ViewController
 */
- (UIViewController *)immobViewController{
    
    NSLog(@"immobViewController:%@",self);
    return nil;
}


- (void) immobViewDidReceiveAd:(immobView *)immobView
{
    if (immobView != nil)
    {
        [self addSubview:immobView];
     //   immobView.center = CGPointMake(self.frame.size.width/2, immobView.frame.size.height/2);
        [immobView immobViewDisplay];
        immobView.hidden = NO;
        
    }
    
    //[immobView setFrame:CGRectMake((480-immobView.frame.size.width)/2, 0, immobView.frame.size.width, immobView.frame.size.height)];
    //immobView.center = CGPointMake(self.frame.size.width/2, immobView.frame.size.height/2);
    NSLog(@"immobViewDidReceiveAd:%@",immobView);
}
#endif


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
