//
//  JFPuzzleModel.h
//  GuessGuess
//
//  Created by ran on 14-2-26.
//  Copyright (c) 2014年 Ran Jingfu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    JFPuzzleModelMainTypeMiyu = 1,  ///谜语
    JFPuzzleModelMainTypeChengyu = 2, ///成语
    JFPuzzleModelMainTypeXiehouyu = 3,///歇后语
    JFPuzzleModelMainTypeNaojinjizhuanwan = 4, ///脑筋急转弯

}JFPuzzleModelMainType;


typedef enum
{
    JFPuzzleModelSubTypeDefault,
    JFPuzzleModelSubTypedailyneces = 1, ///日常用品
    JFPuzzleModelSubTypelove = 2, ///爱情谜语
    JFPuzzleModelSubTypeword = 3, ///字谜
    JFPuzzleModelSubTypeanimal = 4, ///动物
    JFPuzzleModelSubTypefun = 5, ///有趣的事
    JFPuzzleModelSubTypepersonName= 6, ///人名
    JFPuzzleModelSubTypechild = 7, ///孩童谜语
    JFPuzzleModelSubTypeplant = 8, ///植物
    JFPuzzleModelSubTypemovie = 9, ///影视谜语
    JFPuzzleModelSubTypeplace = 10, ///地名
    JFPuzzleModelSubTypeOther = 11, ///其他
}JFPuzzleModelSubType;


typedef enum
{
    JFPuzzleModelLevelTypeDefault,
}JFPuzzleModelLevelType;

@interface JFPuzzleModel : NSObject


@property(nonatomic,copy)NSString *puzzleQuestion;
@property(nonatomic,copy)NSString *puzzleAnswer;
@property(nonatomic,copy)NSString *puzzlesubTypeString;
@property(nonatomic)JFPuzzleModelMainType mainType;
@property(nonatomic)JFPuzzleModelSubType  subType;
@property(nonatomic)BOOL  isAnswered;
@property(nonatomic)BOOL  isUnlock;
@property(nonatomic)JFPuzzleModelLevelType  leveltype;
@property(nonatomic)int   levelIndex;

@end
