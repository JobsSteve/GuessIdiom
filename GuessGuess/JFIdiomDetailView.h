//
//  JFIdiomDetailView.h
//  GuessImageWar
//
//  Created by ran on 13-12-17.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFPuzzleModel.h"
#import "JFPropModel.h"
#import "JFPuzzleModel.h"
#import "JFAudioPlayerManger.h"
#import "JFButtonTrace.h"
typedef enum
{
    JFIdiomDetailViewStatusDefault,         //什么都不做
    JFIdiomDetailViewStatusCounting,        // 倒计时中
    JFIdiomDetailViewStatusCounted        //倒计时结束
}JFIdiomDetailViewStatus;

typedef enum
{
    JFIdiomDetailViewTypeNormal,         //闯关模式
    JFIdiomDetailViewTypeRace           //竞赛模式
}JFIdiomDetailViewType;

@protocol JFIdiomDetailViewDelegate <NSObject>
-(void)answerIdiomSuc:(JFPuzzleModel*)model isUsedAvoidprop:(BOOL)isUsed isTimeOut:(BOOL)isTimeOut wrontTime:(int)wrongTime;

-(JFPuzzleModel*)getAnotherpuzzleModel;
@end
@interface JFIdiomDetailView : UIView
{
    
    NSMutableArray                  *m_arrayOption;
    NSMutableArray                  *m_arrayBtnOption;
    NSMutableArray                  *m_arrayBtnAnswer;
    UIImageView                     *m_imageAnswer;
    UIImageView                     *m_imageContentType;
    
    
    
    int                             m_ianswercount;
    int                             m_iRightAnswerCount;
    id<JFIdiomDetailViewDelegate>   delegate;
    
    
    int                             m_iTotalSecond;
    int                             m_iSecond;
    NSTimer                         *m_timer;
    JFIdiomDetailViewStatus         m_iViewStatus;
    JFIdiomDetailViewType           m_iViewType;
    
    JFAudioPlayerManger             *m_audioManger;
    BOOL                            m_bisAnswerRight;
    
    int                             m_oldTimeInter;
    int                             m_iWrongTime;
    BOOL                            m_bIsNeedCount;
    BOOL                            m_bIsFailed;
    NSLock                          *m_lock;
    
    NSMutableString                 *m_strOption;
    
    UITextView                      *m_textQuestion;
}

@property(nonatomic,assign)id<JFIdiomDetailViewDelegate>  delegate;
@property(nonatomic,retain)JFPuzzleModel  *model;
@property(nonatomic,readonly)JFIdiomDetailViewStatus viewStatus;
@property(nonatomic)JFIdiomDetailViewType  viewType;
@property(nonatomic)int     remainCountDown;
@property(nonatomic)BOOL    answerRight;
@property(nonatomic)BOOL    isFailed;
@property(nonatomic)int     wrongTime;

-(BOOL)isRightAnswerInForm;
-(void)updateViewAccordModel:(JFPuzzleModel*)tempModel;
-(NSString*)getNowOptionStr;
-(NSString*)getNowAnswerStr;

- (id)initWithFrame:(CGRect)frame  withModel:(JFPuzzleModel*)tempModel;
- (id)initWithFrame:(CGRect)frame;
-(void)startAnswer:(int)totalTimer;
-(void)usePropWithType:(JFPropModelType)modelType;
-(void)setStringAfterLoadModel:(NSString*)optionStr answerStr:(NSString*)strAnswer;
@end
