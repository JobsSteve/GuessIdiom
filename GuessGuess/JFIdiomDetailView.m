//
//  JFIdiomDetailView.m
//  GuessImageWar
//
//  Created by ran on 13-12-17.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFIdiomDetailView.h"
#import "PublicClass.h"

@implementation JFIdiomDetailView
@synthesize delegate;
@synthesize model;
@synthesize viewStatus = m_iViewStatus;
@synthesize viewType = m_iViewType;
@synthesize remainCountDown = m_iSecond;
@synthesize answerRight = m_bisAnswerRight;
@synthesize isFailed = m_bIsFailed;
@synthesize wrongTime = m_iWrongTime;


-(void)defaultInit
{
    m_arrayOption = [[NSMutableArray alloc] init];
    m_arrayBtnAnswer = [[NSMutableArray alloc] init];
    m_arrayBtnOption = [[NSMutableArray alloc] init];
    m_bIsNeedCount = YES;
    m_bIsFailed = NO;
    m_iWrongTime = 0;
   // UIApplication
    
    
    m_strOption = [[NSMutableString alloc] init];
    //NSString    *optionfile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"chineseTable.txt"];
    NSString    *optionfile = [[NSBundle mainBundle] pathForResource:@"chineseTable" ofType:@".txt"];
    
    NSError     *error = nil;
    
    NSString    *strOption = [NSString stringWithContentsOfFile:optionfile encoding:NSUTF8StringEncoding error:&error];
   // NSString    *strOption = [NSString stringWithContentsOfFile:optionfile usedEncoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        DLOG(@"read file of %@ error:%@",optionfile,error);
    }
    [m_strOption setString:strOption];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
}

-(void)WillEnterForeground:(NSNotification*)note
{
   
    if (m_oldTimeInter > 0)
    {
      int  nowtimer = [[NSDate date] timeIntervalSince1970];
      m_iSecond  =  m_iSecond -(nowtimer-m_oldTimeInter);
      [self startAnswer:m_iSecond];
        
    }
    m_oldTimeInter = 0;

    DLOG(@"WillEnterForeground:%@   m_iSecond:%d",note,m_iSecond);
}

-(void)WillResignActive:(NSNotification*)note
{
    
    
    if (m_iViewStatus == JFIdiomDetailViewStatusCounting)
    {
        m_oldTimeInter = [[NSDate date] timeIntervalSince1970];
    }else
    {
        m_oldTimeInter = 0;
    }
    DLOG(@"WillResignActive:%@  m_iSecond:%d",note,m_iSecond);
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit];
        m_lock = [[NSLock alloc] init];
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame  withModel:(JFPuzzleModel*)tempModel
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        m_iViewStatus = JFIdiomDetailViewStatusDefault;
        [self defaultInit];
         m_lock = [[NSLock alloc] init];
         self.model = tempModel;
        [self updateViewAccordModel:tempModel];
        // Initialization code
    }
    return self;
}


-(void)checkAndFixAnswerAndOptionArray:(NSMutableArray*)array
{
    int   count =  24;
    
    if ([array count])
    {
        [array removeAllObjects];
    }
     NSString  *strAnswer = self.model.puzzleAnswer;
    for (int i = 0; i <  [strAnswer length]; i++)
    {
        [array addObject:[strAnswer substringWithRange:NSMakeRange(i, 1)]];
    }
    
    
    int   needCount = count-(int)[strAnswer length];
    int   randomcount = (int)[m_strOption length];
    while (needCount)
    {
        srandom((unsigned)(time(NULL)+needCount));
        int     index = random()%randomcount;
        NSString    *strOptin = [m_strOption substringWithRange:NSMakeRange(index, 1)];
        [array addObject:strOptin];
        needCount--;
    }
    
    
    
    if ([array count] == 24)
    {
        DLOG(@"checkAndFixAnswerAndOptionArray return because count as 24");
        return;
    }
   
    if ([array count] < count)
    {
        for (int i = 0; i < [strAnswer length]; i++)
        {
            [array insertObject:[strAnswer substringWithRange:NSMakeRange(i, 1)] atIndex:0];
            if ([array count] == count)
            {
                break;
            }
        }
    }else
    {
        while ([array count] > 24)
        {
            [array removeLastObject];
        }
    }
  
    
    
    
    for (int i = 0; i < [strAnswer length]; i++)
    {
        NSString *strA = [strAnswer substringWithRange:NSMakeRange(i, 1)];
        
        BOOL  bhas = NO;
        
        for (int j = 0; j < [array count]; j++)
        {
            if ([strA isEqualToString:[array objectAtIndex:j]])
            {
                bhas = YES;
                [array addObject:strA];
                break;
            }
        }
    }
    
    if ([array count] == [strAnswer length])
    {
        return;
    }
    
    
    for (int i = 0; i < [strAnswer length]; i++)
    {
        [array insertObject:[strAnswer substringWithRange:NSMakeRange(i, 1)] atIndex:0];
    }
    
    while ([array count] > 24)
    {
        [array removeLastObject];
    }
    
    
    
}

-(void)updateViewAccordModel:(JFPuzzleModel*)tempModel
{
    
    [m_audioManger pausePlay];
    self.model = tempModel;
    m_iWrongTime = 0;
    
    
    
    DLOG(@"tempModel:%@",self.model);
    m_iTotalSecond = 30;
    m_bIsFailed = NO;
    [m_arrayOption removeAllObjects];
    [self checkAndFixAnswerAndOptionArray:m_arrayOption];
    
    //CGFloat         fxpoint =  10;
    CGFloat         fypoint =  22;
    CGFloat         fysep = 5;
    UIImageView     *picbg = (UIImageView*)[self viewWithTag:1222];
    if (!picbg)
    {
        picbg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-142)/2, fypoint, 142, 142)];
        picbg.image = [PublicClass getImageAccordName:@"answer_pic_bg.png"];
        picbg.userInteractionEnabled = YES;
        [self addSubview:picbg];
        picbg.tag = 1222;
        [picbg release];
    }
    
    if (!m_textQuestion)
    {
        m_textQuestion = [[UITextView alloc] initWithFrame:CGRectMake((picbg.frame.size.width-120)/2, 10, 120, 120)];
        [m_textQuestion setBackgroundColor:[UIColor clearColor]];
        [m_textQuestion setTextAlignment:NSTextAlignmentCenter];
        [m_textQuestion setTextColor:[UIColor whiteColor]];
        [m_textQuestion setFont:TEXTFONTWITHSIZE(15)];
        [m_textQuestion setEditable:NO];
        [picbg addSubview:m_textQuestion];
    }
    
    
    [m_textQuestion setText:self.model.puzzleQuestion];
    /*
    if (!m_imageAnswer)
    {
        m_imageAnswer = [[UIImageView alloc] initWithFrame:CGRectMake((picbg.frame.size.width-125)/2, (picbg.frame.size.height-95)/2, 125, 95)];
        m_imageAnswer.userInteractionEnabled = YES;
        [picbg addSubview:m_imageAnswer];
    }*/


    
    fypoint += 8+fysep+142;
    
    m_iRightAnswerCount = (int)[self.model.puzzleAnswer length];
    for (UIButton  *btn in m_arrayBtnAnswer)
    {
        [btn removeFromSuperview];
    }
    [m_arrayBtnAnswer removeAllObjects];

    if (![m_arrayBtnAnswer count])
    {
        CGFloat  fXpoint = 0;//m_progressView.frame.origin.x - 15;
        CGFloat  fXsep = 3;
        
       // fXpoint = m_progressView.frame.origin.x;
    
        fXsep = (120-24*4)/3;
        
        fXpoint = (self.frame.size.width-fXsep*(m_iRightAnswerCount-1)-30*m_iRightAnswerCount)/2;
        for (int i = 0; i < m_iRightAnswerCount; i++)
        {
            JFButtonTrace    *btnanswer = [[JFButtonTrace alloc] initWithFrame:CGRectMake(fXpoint, fypoint, 30, 30)
                                                               withshadowColor:[UIColor colorWithRed:0x07*1.0/255.0 green:0x47*1.0/255.0 blue:0x85*1.0/255.0 alpha:1] withTextColor:[UIColor whiteColor] title:@""];
            [btnanswer setBackgroundImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
            [btnanswer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnanswer setTitle:@"" forState:UIControlStateNormal];
            [btnanswer addTarget:self action:@selector(clickAnswerBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btnanswer setTextFont:TEXTHEITIWITHSIZE(17)];
            btnanswer.tag = 10000+i;
            [self addSubview:btnanswer];
            [m_arrayBtnAnswer addObject:btnanswer];
            [btnanswer release];
            fXpoint += 30+fXsep;
        }
    }
    
    
    for (int i = 0; i < [m_arrayBtnAnswer count]; i++)
    {
        JFButtonTrace  *btnAnswer = [m_arrayBtnAnswer objectAtIndex:i];
        [btnAnswer setBackgroundImage:[UIImage imageNamed:@"answer_btn_bg.png"] forState:UIControlStateNormal];
        [btnAnswer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAnswer setTextShadowColor:[UIColor colorWithRed:0x07*1.0/255.0 green:0x47*1.0/255.0 blue:0x85*1.0/255.0 alpha:1]];
        [btnAnswer setTitle:@"" forState:UIControlStateNormal];
        [[btnAnswer titleLabel] setFont:TEXTHEITIWITHSIZE(17)];
    
    }
    
    //answer_optionbtn_bg
    fypoint +=  24+fysep;
    
    if (![m_arrayBtnOption count])
    {
        UIImageView   *optionBg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-320)/2, fypoint, 320, 200)];
        optionBg.userInteractionEnabled = YES;
        optionBg.tag =  11223344;
        [self addSubview:optionBg];
        
        
        int rowcount = 6;

        CGFloat   fyypoint = 10;
        CGFloat   fwwidth = 39;
        
        CGFloat   fxxSep = (optionBg.frame.size.width-fwwidth*rowcount)/7;
        CGFloat   fyySep = (optionBg.frame.size.height-fwwidth*4-fyypoint*3)/2-5;
        
        for (int i = 0; i < 24; i++)
        {
            
            CGFloat  fxxxpoint = fxxSep+(fwwidth+fxxSep)*(i%rowcount);
            CGFloat  fyyypoint = fyypoint;
            if (i >= 18)
            {
                fyyypoint += (fwwidth+fyySep)*3;
            }else  if (i >= 12)
            {
                fyyypoint += (fwwidth+fyySep)*2;
            }else if (i >= 6)
            {
                fyyypoint += (fwwidth+fyySep)*1;
            }
            
            JFButtonTrace  *btnOption = [[JFButtonTrace alloc] initWithFrame:CGRectMake(fxxxpoint, fyyypoint, fwwidth, fwwidth) withshadowColor:[UIColor whiteColor] withTextColor:[UIColor brownColor] title:@""];
            [btnOption setBackgroundImage:[PublicClass getImageAccordName:@"answer_optionbtn_bg.png"] forState:UIControlStateNormal];
            [btnOption setTitle:nil forState:UIControlStateNormal];
            [btnOption setTextFont:TEXTFONTWITHSIZE(20)];
            [btnOption addTarget:self action:@selector(clickOptionBtn:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *label = [btnOption titleLabel];
            [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y-3, label.frame.size.width, label.frame.size.height)];
            
            [optionBg addSubview:btnOption];
            btnOption.tag = 10000+i;
            [m_arrayBtnOption addObject:btnOption];
            [btnOption release];
            
            
        }
        
        
        [optionBg release];
    }
    
    [self randomArrayData:m_arrayOption];
    for (int i = 0;i < [m_arrayBtnOption count];i++)
    {
        UIButton  *btnOption = [m_arrayBtnOption objectAtIndex:i];
        if (i < [m_arrayOption count])
        {
           [btnOption setTitle:[m_arrayOption objectAtIndex:i] forState:UIControlStateNormal];
        }else
        {
            [btnOption setTitle:nil forState:UIControlStateNormal];
        }
        
        btnOption.hidden = NO;
    }

    if (!m_imageContentType)
    {
        m_imageContentType = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 55, 19)];
        [picbg addSubview:m_imageContentType];
    }
    m_ianswercount = 0;
    
    DLOG(@"answer:%@ question:%@",self.model.puzzleAnswer,self.model.puzzleQuestion);
}



-(BOOL)isRightAnswerInForm
{
    BOOL  isright = YES;
    
    if ([self.model.puzzleAnswer length])
    {
        for (int i = 0;i < [m_arrayBtnAnswer count];i++)
        {
            
            if (![[[m_arrayBtnAnswer objectAtIndex:i] titleForState:UIControlStateNormal] isEqualToString:[self.model.puzzleAnswer substringWithRange:NSMakeRange(i, 1)]])
            {
                isright = NO;
                break;
            }
        }
        
    }else
    {
        isright = NO;
    }
   
    return isright;
}


-(void)clickOptionBtn:(UIButton*)sender
{
    
    
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    if (m_ianswercount >= m_iRightAnswerCount)
    {
        return;
    }
    NSString  *strInfo = [sender titleForState:UIControlStateNormal];
    
    BOOL  bhasFill = NO;
    for (int i = 0; i < [m_arrayBtnAnswer count]; i++)
    {
        UIButton  *btnAnsewr = [m_arrayBtnAnswer objectAtIndex:i];
        NSString  *strAnswer = [btnAnsewr titleForState:UIControlStateNormal];
        if ([strAnswer isEqualToString:@""] || !strAnswer )
        {
            [btnAnsewr setTitle:strInfo forState:UIControlStateNormal];
            m_ianswercount++;
            bhasFill = YES;
            break;
        }
    }
    
    if (bhasFill)
    {
         [sender setHidden:YES];
    }else
    {
        DLOG(@"clickOptionBtn  no result");
         return;
    }
   
    
    
    [self judgeIsRightAnswer];
    
    
    DLOG(@"clickOptionBtn:%@",sender);
}

-(void)judgeIsRightAnswer
{
    if (m_ianswercount == m_iRightAnswerCount)
    {
        if ([self isRightAnswer])
        {
            [self performSelector:@selector(showRightAnswer) withObject:nil afterDelay:0.5];
        }else
        {
            [self answerErrorAni:nil];
        }
    }
    
}

-(void)showRightAnswer
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if (m_bisAnswerRight)
        {
            return;
        }
        if (delegate && [delegate respondsToSelector:@selector(answerIdiomSuc:isUsedAvoidprop:isTimeOut:wrontTime:)])
        {
            [delegate answerIdiomSuc:self.model isUsedAvoidprop:NO isTimeOut:(m_iSecond < 0) wrontTime:m_iWrongTime];
        }
        m_bisAnswerRight = YES;
        [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeNormalRight];
    });

    
}

-(void)startAnswer:(int)totalTimer
{
  
    
    [m_audioManger pausePlay];
    m_bisAnswerRight = NO;
    m_iSecond = totalTimer;
    
    

}


-(void)useDiceProp
{
    if ([delegate respondsToSelector:@selector(getAnotherpuzzleModel)])
    {
        JFPuzzleModel   *othermodel = [delegate getAnotherpuzzleModel];
        if (othermodel)
        {
            [self updateViewAccordModel:othermodel];
        }
    }
    
    DLOG(@"useDiceProp:%@",self.model);
}
-(void)usePropWithType:(JFPropModelType)modelType
{
    switch (modelType)
    {
        case JFPropModelTypeTrash:
            [self randomTrashThreeOption];
            break;
        case JFPropModelTypeIdeaShow:
            [self randomOneRightAnswer];
            break;
        case JFPropModelTypeAvoidAnswer:
            [self avoidAnswerPropUsed];
            break;
        case JFPropModelTypeTimeMachine:
            [self userTimeMachine];
            break;
        case JFPropModelTypeDice:
            [self useDiceProp];
            break;
        default:
            break;
    }
}


-(NSString*)getNowOptionStr
{
    NSString    *strReturn = @"";
    
    for (int i = 0;i < [m_arrayBtnOption count];i++)
    {
        UIButton *btnOption = [m_arrayBtnOption objectAtIndex:i];
        NSString    *strOption = [btnOption titleForState:UIControlStateNormal];
        if (btnOption.hidden || !strOption || [strOption isEqualToString:@""])
        {
            continue;
        }
        
        strReturn = [strReturn stringByAppendingString:strOption];
        
    }
    
    return strReturn;
}
-(NSString*)getNowAnswerStr
{
    NSString    *strReturn = @"";
    
    for (int i = 0;i < [m_arrayBtnAnswer count];i++)
    {
        UIButton *btnAnswer= [m_arrayBtnAnswer objectAtIndex:i];
        NSString    *strAnswer = [btnAnswer titleForState:UIControlStateNormal];
        
        if (!strAnswer || [strAnswer isEqualToString:@""])
        {
            strAnswer = @"0";
        }
        strReturn = [strReturn stringByAppendingString:strAnswer];
        
    }
    return strReturn;
}



-(void)setStringAfterLoadModel:(NSString*)optionStr answerStr:(NSString*)strAnswer
{
 
    
    for (int i = 0;i < [strAnswer length];i++)
    {
        NSString *strA = [strAnswer substringWithRange:NSMakeRange(i, 1)];
        
        for (UIButton  *btnOption in m_arrayBtnOption)
        {
            if (btnOption.hidden)
            {
                continue;
            }
            
            NSString    *strTitle = [btnOption titleForState:UIControlStateNormal];
            if ([strTitle isEqualToString:strA])
            {
                btnOption.hidden = YES;
                break;
            }
        }
        
    }
    
    
    m_ianswercount = 0;
    for (int i = 0; i < [strAnswer length]; i++)
    {
        NSString    *strSubString = [strAnswer substringWithRange:NSMakeRange(i, 1)];
        if ([strSubString isEqualToString:@"0"])
        {
            
            if (i < [m_arrayBtnAnswer count])
            {
               [[m_arrayBtnAnswer objectAtIndex:i] setTitle:@"" forState:UIControlStateNormal];
            }
            
        }else
        {
            if (i < [m_arrayBtnAnswer count])
            {
                [[m_arrayBtnAnswer objectAtIndex:i] setTitle:strSubString forState:UIControlStateNormal];
            }
          
            m_ianswercount++;
        }
    }
    
}

-(void)userTimeMachine
{
 
    m_iTotalSecond += 30;
    
    if (m_iSecond < 0)
    {
        m_iSecond  = 30;
    }else
    {
        m_iSecond += 30;
       
    }
     [self startAnswer:m_iSecond];
   
    [JFIdiomDetailView cancelPreviousPerformRequestsWithTarget:self selector:@selector(PlayMainCountMedia) object:nil];
    [m_audioManger pausePlay];
    
}

-(void)avoidAnswerPropUsed
{
    

    if (m_bisAnswerRight)
    {
        return;
    }
    if (delegate && [delegate respondsToSelector:@selector(answerIdiomSuc:isUsedAvoidprop:isTimeOut:wrontTime:)])
    {
        [delegate answerIdiomSuc:self.model isUsedAvoidprop:YES isTimeOut:(m_iSecond < 0) wrontTime:m_iWrongTime];
    }
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeNormalRight];
    m_bisAnswerRight = YES;

}

-(void)randomOneRightAnswer
{
    [m_lock lock];
    DLOG(@"m_ianswercount:%d",m_ianswercount);
    if (m_ianswercount >= m_iRightAnswerCount)
    {
        for (int i = 0;i < [m_arrayBtnAnswer count];i++)
        {
            JFButtonTrace  *btnAnswer = [m_arrayBtnAnswer objectAtIndex:i];
            [btnAnswer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnAnswer setTextShadowColor:[UIColor colorWithRed:0x07*1.0/255.0 green:0x47*1.0/255.0 blue:0x85*1.0/255.0 alpha:1]];

            NSString    *strTitle = [btnAnswer titleForState:UIControlStateNormal];
            NSString   *strSubString = [self.model.puzzleAnswer substringWithRange:NSMakeRange(i, 1)];
            if (![strSubString isEqualToString:strTitle])
            {
                [btnAnswer setTitle:@"" forState:UIControlStateNormal];
                m_ianswercount--;
                
                for (UIButton *btnOption in m_arrayBtnOption)
                {
                    if (btnOption.hidden && [[btnOption titleForState:UIControlStateNormal] isEqualToString:strTitle])
                    {
                        [btnOption setHidden:NO];
                        break;
                    }
                }
                
            }
            
        }
            //DLOG(@"randomOneRightAnswer fail");
       // return;
    }
    
    
    
    BOOL   bRandom = NO;
    while (!bRandom && m_ianswercount < m_iRightAnswerCount)
    {
        
        srandom((unsigned)time(NULL));
        int randIndex = (int)random()%[m_arrayBtnAnswer count];
        while (!bRandom)
        {
            UIButton    *btn = [m_arrayBtnAnswer objectAtIndex:randIndex];
            NSString    *strTitle = [btn titleForState:UIControlStateNormal];
            if ([strTitle isEqualToString:@""] || !strTitle)
            {
                strTitle = [self.model.puzzleAnswer substringWithRange:NSMakeRange(randIndex, 1)];
                [btn setTitle:strTitle forState:UIControlStateNormal];
                for (UIButton *btnOption in m_arrayBtnOption)
                {
                    if (!btnOption.hidden && [[btnOption titleForState:UIControlStateNormal] isEqualToString:strTitle])
                    {
                        [btnOption setHidden:YES];
                        break;
                    }
                }
                m_ianswercount++;
                bRandom = YES;
            }else
            {
               
                randIndex = (randIndex+1)%[m_arrayBtnAnswer count];
            }
            
        }
       
    }
    

    DLOG(@"judgeIsRightAnswer......");
    [self judgeIsRightAnswer];
    [m_lock unlock];
}
-(void)randomTrashThreeOption
{
    int  count = 3;
    

    while (count)
    {
        srandom((unsigned)time(NULL)+count);
        int randIndex = (int)random()%[m_arrayBtnOption count];
        DLOG(@"randomTrashThreeOption index:%d  time(NULL)：%ldd",randIndex,time(NULL));
        BOOL  bget = NO;
        while (!bget)
        {
            UIButton   *btn = [m_arrayBtnOption objectAtIndex:randIndex];
            if (!btn.hidden)
            {
                BOOL  bIsRightAnswer = NO;
                for (int i = 0;i < [self.model.puzzleAnswer length];i++)
                {
                    NSString   *strAnswerTemp = [self.model.puzzleAnswer substringWithRange:NSMakeRange(i, 1)];
                    if ([strAnswerTemp isEqualToString:[btn titleForState:UIControlStateNormal]])
                    {
                        bIsRightAnswer = YES;
                        break;
                    }
                }
                
                if (!bIsRightAnswer)
                {
                    btn.hidden = YES;
                    count--;
                    bget = YES;
                    break;
                }else
                {
                   randIndex = (randIndex+1)%[m_arrayBtnOption count];
                }
                
                
                
            }else
            {
                randIndex = (randIndex+1)%[m_arrayBtnOption count];
            }
            
            
        }
     
    }

}
-(void)PlayMainCountMedia
{
    JFAudioPlayerMangerType  type = JFAudioPlayerMangerTypeCountDown;
    if (!m_audioManger)
    {
        m_audioManger = [[JFAudioPlayerManger alloc] initWithType:type];
    }
    [m_audioManger playWithLoops:YES];
    
}

-(void)answerErrorAni:(id)thread
{
    m_iWrongTime++;
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeNormalWrong];
    [self flash];
}
-(void)flash
{
    for (JFButtonTrace  *btnanswer in m_arrayBtnAnswer)
    {
        [btnanswer.titleLabel setAlpha:0];
        [btnanswer setTextShadowColor:[UIColor colorWithRed:0x07*1.0/255.0 green:0x47*1.0/255.0 blue:0x85*1.0/255.0 alpha:1]];

    }
    
    [UIView beginAnimations:@"flash screen" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationRepeatCount:3];
    for (JFButtonTrace  *btnanswer in m_arrayBtnAnswer)
    {
         [btnanswer.titleLabel setAlpha:1];
         [btnanswer setTextShadowColor:[UIColor colorWithRed:0xd2*1.0/255.0 green:0x00*1.0/255.0 blue:0x00*1.0/255.0 alpha:1]];
    }
    [UIView commitAnimations];
}


-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    for (JFButtonTrace  *btnanswer in m_arrayBtnAnswer)
    {
        [btnanswer setAlpha:1];
        [btnanswer setTextShadowColor:[UIColor colorWithRed:0xd2*1.0/255.0 green:0x00*1.0/255.0 blue:0x00*1.0/255.0 alpha:1]];

    }
    
}

-(void)randomArrayData:(NSMutableArray*)array
{
    NSMutableArray *temparray = [NSMutableArray array];
    
    
    while ([array count])
    {
        srandom((unsigned)time(NULL)+(unsigned)[array count]);
        int index = (int)random()%[array count];
        [temparray addObject:[array objectAtIndex:index]];
        [array removeObjectAtIndex:index];
    }
    
    [array addObjectsFromArray:temparray];
    
}
-(BOOL)isRightAnswer
{
    
    if (m_ianswercount < m_iRightAnswerCount)
    {
        return NO;
    }
    
    NSString  *strAnswer = @"";
    for (UIButton  *btnAnswer in m_arrayBtnAnswer)
    {
        strAnswer = [strAnswer stringByAppendingString:[btnAnswer titleForState:UIControlStateNormal]];
    }
    
    return [strAnswer isEqualToString:self.model.puzzleAnswer];

}
-(void)clickAnswerBtn:(UIButton*)sender
{
    
    
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    NSString  *strInfo = [sender titleForState:UIControlStateNormal];
    if (!strInfo || [strInfo isEqualToString:@""])
    {
        return;
    }
    
    
    for (JFButtonTrace  *btnAnswer in m_arrayBtnAnswer)
    {
        [btnAnswer setTextShadowColor:[UIColor colorWithRed:0x07*1.0/255.0 green:0x47*1.0/255.0 blue:0x85*1.0/255.0 alpha:1]];
    }
    [sender setTitle:@"" forState:UIControlStateNormal];
  // int  index = 0;
    for (int i = 0; i < [m_arrayBtnOption count]; i++)
    {
        UIButton  *btnoption = [m_arrayBtnOption objectAtIndex:i];
        NSString  *strAnswer = [btnoption titleForState:UIControlStateNormal];
        if ([strAnswer isEqualToString:strInfo] && btnoption.hidden)
        {
            [btnoption setHidden:NO];
            m_ianswercount--;
            break;
        }
    }
  
    
 //   [sender setHidden:YES];
    DLOG(@"clickAnswerBtn:%@",sender);
}

-(void)dealloc
{
    [m_lock release];
    m_lock = nil;
    [m_strOption release];
    m_strOption = nil;
    self.model = nil;
    
    
    [m_textQuestion release];
    m_textQuestion= nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [m_audioManger stopPlay];
    [m_audioManger release];
    m_audioManger = nil;
    [m_arrayBtnAnswer release];
    m_arrayBtnAnswer = nil;
    [m_arrayBtnOption release];
    m_arrayBtnOption = nil;
    [m_arrayOption release];
    m_arrayOption = nil;
    [m_imageAnswer release];
    m_imageAnswer = nil;
    [m_imageContentType release];
    m_imageContentType = nil;
    [super dealloc];
}
@end
