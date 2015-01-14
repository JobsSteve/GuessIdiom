//
//  JFNormalAnswerViewController.h
//  GuessImageWar
//
//  Created by ran on 13-12-17.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFAlertView.h"
#import "JFPuzzleModel.h"
#import "JFIdiomDetailView.h"
#import "JFPropButton.h"
#import "JFAnswerRightView.h"
#import "JFAudioPlayerManger.h"
#import "JFSQLManger.h"
#import "iToast.h"
#import "JFYouMIManger.h"
#import "JFAnswerRightViewController.h"

@interface JFNormalAnswerViewController : UIViewController<JFAlertViewDeledate,JFIdiomDetailViewDelegate,JFPropButtonDelegate,JFAnswerRightViewDelegate>
{
    
    JFLabelTrace        *m_labelLevel;
    UIImageView         *m_goldView;
    JFIdiomDetailView   *m_idiomView;
    JFAudioPlayerManger *m_playerbgManger;
    

   // immobView           *m_bannerView;
    
}

@property(nonatomic,retain)JFPuzzleModel  *idiomModel;
@property(nonatomic,retain)JFPropButton  *trashProp;
@property(nonatomic,retain)JFPropButton  *ideaShowProp;
@property(nonatomic,retain)JFPropButton  *avoidProp;


@end
