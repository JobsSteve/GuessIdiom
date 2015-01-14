//
//  JFAnswerRightViewController.m
//  GuessGuess
//
//  Created by Ran Jingfu on 3/16/14.
//  Copyright (c) 2014 Ran Jingfu. All rights reserved.
//

#import "JFAnswerRightViewController.h"

@interface JFAnswerRightViewController ()

@end

@implementation JFAnswerRightViewController
@synthesize delegate;
@synthesize islast;
@synthesize frame;
@synthesize puzzleModel;
@synthesize goldNumber;
@synthesize bgImage;

-(void)dealloc
{
    self.puzzleModel = nil;
    self.bgImage = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)tempframe  withModel:(JFPuzzleModel*)Tempmodel  gold:(int)rewardNumber  islastidiom:(BOOL)islasvaliue withImage:(UIImage*)image
{
    self = [super init];
    if (self)
    {
        self.puzzleModel = Tempmodel;
        self.frame = tempframe;
        self.goldNumber = rewardNumber;
        self.islast = islasvaliue;
        self.bgImage = image;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.view.layer.contents = (id)self.bgImage.CGImage;
    JFAnswerRightView  *view = [[JFAnswerRightView alloc] initWithFrame:CGRectZero withModel:self.puzzleModel gold:self.goldNumber progress:1 islastidiom:self.islast wrongtime:0];
    view.delegate =  self;
    [self.view addSubview:view];
    [view release];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)clickToshare:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(clickToshare:)])
    {
        [delegate clickToshare:self];
    }
    
}
-(void)clickToNextIdiom:(JFPuzzleModel*)model addGoldNumber:(int)number;
{
    if (delegate && [delegate respondsToSelector:@selector(clickToNextIdiom:addGoldNumber:)])
    {
        [delegate clickToNextIdiom:model addGoldNumber:number];
    }
    [self.navigationController popViewControllerAnimated:YES];
        
    
}
-(void)clickMoreIdioms:(id)sender addGoldNumber:(int)number
{
    if (delegate && [delegate respondsToSelector:@selector(clickMoreIdioms:addGoldNumber:)])
    {
        [delegate clickMoreIdioms:sender addGoldNumber:number];
    }
     [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickBackButtonInAnswerview:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(clickBackButtonInAnswerview:)])
    {
        [delegate clickBackButtonInAnswerview:sender];
    }
    
   //[self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
