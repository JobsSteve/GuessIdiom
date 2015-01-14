//
//  JFPropButton.m
//  GuessImageWar
//
//  Created by ran on 13-12-17.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFPropButton.h"
#import "PublicClass.h"

#define GOLDBGVIEWTAG       11111111
#define GOLDICONTAG         11121111

@implementation JFPropButton
@synthesize delegate;
@synthesize propModel;


//54*(40+10)
- (id)initWithFrame:(CGRect)frame  withModel:(JFPropModel*)model
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self updatePropBtn:model];
        
        [self addTarget:self action:@selector(clickSelf:) forControlEvents:UIControlEventTouchUpInside];
        // Initialization code
    }
    return self;
}



-(void)setGoldIconGray:(BOOL)bIsGray
{
    UIView  *view = [self viewWithTag:GOLDBGVIEWTAG];
    UIImageView *goldIconview =(UIImageView*) [view viewWithTag:GOLDICONTAG];
    if (goldIconview)
    {
        if (bIsGray)
        {
            [goldIconview setImage:[PublicClass getImageAccordName:@"answer_goldgray_icon.png"]];
        }else
        {
            [goldIconview setImage:[PublicClass getImageAccordName:@"answer_gold_icon.png"]];
        }
    }
    
}
-(void)dealloc
{
   [m_imageIcon release];
    m_imageIcon = nil;
    self.propModel  = nil;
    [super dealloc];
}

-(void)clickSelf:(id)sender
{
    if (delegate  && [delegate respondsToSelector:@selector(clickPropButton:button:)])
    {
     
        [delegate clickPropButton:self.propModel button:self];
    }
}

-(void)updatePropBtn:(JFPropModel*)model
{
    self.propModel = model;
    
    
    
    UIImageView *propview = (UIImageView*)[self viewWithTag:3001];
    if (!propview)
    {
        propview =  [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-40)/2, 0, 40, 40)];
        [self addSubview:propview];
        propview.tag = 3001;
        [propview release];
    }
        propview.image = [PublicClass getImageAccordName:self.propModel.propIncName];
    
    UIImageView *goldBgView = (UIImageView*)[self viewWithTag:GOLDBGVIEWTAG];
    if (!goldBgView)
    {
        goldBgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-54)/2, self.frame.size.height-18, 54, 17)];
        goldBgView.image = [PublicClass getImageAccordName:@"answer_word_bg.png"];
        [self addSubview:goldBgView];
        goldBgView.tag = GOLDBGVIEWTAG;
        [goldBgView release];
    }
    
    if (self.propModel.modelType != JFPropModelTypeShareForHelp)
    {

        JFLabelTrace  *labelMoney = nil;
        UIImageView *goldiconViews = (UIImageView*)[goldBgView viewWithTag:GOLDICONTAG];
        if (!goldiconViews)
        {
            goldiconViews = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 18, 17)];
            goldiconViews.image = [PublicClass getImageAccordName:@"answer_gold_icon.png"];
            goldiconViews.tag = GOLDICONTAG;
            [goldBgView addSubview:goldiconViews];
            [goldiconViews release];
            
            labelMoney = [[JFLabelTrace alloc] initWithFrame:CGRectMake(5+18, 0, 80, 17) withShadowColor:[UIColor colorWithRed:0x07*1.0/255.0 green:0x42*1.0/255.0 blue:0x85*1.0/255.0 alpha:1] offset:CGSizeMake(1, 1) textColor:[UIColor whiteColor]];
            [labelMoney setBackgroundColor:[UIColor clearColor]];
            [labelMoney setFont:TEXTFONTWITHSIZE(13)];
            labelMoney.tag = 456;
            [goldBgView addSubview:labelMoney];
      
            [labelMoney release];
        }
        
        labelMoney = (JFLabelTrace*)[goldBgView viewWithTag:456];
        [labelMoney setText:[NSString stringWithFormat:@"%d",self.propModel.propPrice]];
        
    }else
    {
        JFLabelTrace  *labelMoney = [[JFLabelTrace alloc] initWithFrame:CGRectMake(0, 0, goldBgView.frame.size.width, 17) withShadowColor:[UIColor colorWithRed:0x07*1.0/255.0 green:0x42*1.0/255.0 blue:0x85*1.0/255.0 alpha:1] offset:CGSizeMake(1, 1) textColor:[UIColor whiteColor]];
        [labelMoney setBackgroundColor:[UIColor clearColor]];
        [labelMoney setFont:TEXTFONTWITHSIZE(15)];
        [goldBgView addSubview:labelMoney];
        [labelMoney setTextAlignment:NSTextAlignmentCenter];
        [labelMoney setText:@"分享"];
        [labelMoney release];
        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
