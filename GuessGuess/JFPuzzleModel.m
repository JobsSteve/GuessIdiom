//
//  JFPuzzleModel.m
//  GuessGuess
//
//  Created by ran on 14-2-26.
//  Copyright (c) 2014年 Ran Jingfu. All rights reserved.
//

#import "JFPuzzleModel.h"

@implementation JFPuzzleModel
@synthesize puzzleAnswer;
@synthesize puzzleQuestion;
@synthesize puzzlesubTypeString;
@synthesize mainType;
@synthesize subType;
@synthesize isAnswered;
@synthesize isUnlock;
@synthesize leveltype;
@synthesize levelIndex;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.mainType = JFPuzzleModelMainTypeMiyu;
        self.subType = JFPuzzleModelSubTypeDefault;
    }
    return self;
}

-(void)dealloc
{
    self.puzzleQuestion = nil;
    self.puzzleAnswer = nil;
    self.puzzlesubTypeString = nil;
    [super dealloc];
}
@end
