//
//  JFAnswerRightViewController.h
//  GuessGuess
//
//  Created by Ran Jingfu on 3/16/14.
//  Copyright (c) 2014 Ran Jingfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFAnswerRightView.h"



@interface JFAnswerRightViewController : UIViewController<JFAnswerRightViewDelegate>
{
    id<JFAnswerRightViewDelegate>    delegate;
}

@property(nonatomic,assign)id<JFAnswerRightViewDelegate> delegate;


@property(nonatomic)CGRect  frame;
@property(nonatomic,retain)JFPuzzleModel  *puzzleModel;
@property(nonatomic)BOOL islast;
@property(nonatomic)int  goldNumber;
@property(nonatomic,retain)UIImage  *bgImage;


- (id)initWithFrame:(CGRect)tempframe  withModel:(JFPuzzleModel*)Tempmodel  gold:(int)rewardNumber  islastidiom:(BOOL)islasvaliue withImage:(UIImage*)image;

@end
