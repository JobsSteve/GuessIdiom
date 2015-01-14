//
//  JFViewController.h
//  GuessGuess
//
//  Created by Ran Jingfu on 2/24/14.
//  Copyright (c) 2014 Ran Jingfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CABasicAnimation+someAniForProp.h"
#import "JFSetViewController.h"
#import "UtilitiesFunction.h"
#import "JFAlertView.h"
#import "JFAudioPlayerManger.h"
#import "JFYouMIManger.h"
@interface JFLauchViewController : UIViewController<JFAlertViewDeledate>
{
    JFAudioPlayerManger   *m_audioPlayer;
}

@end
