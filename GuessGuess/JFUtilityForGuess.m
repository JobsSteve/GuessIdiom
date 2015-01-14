//
//  JFUtilityForGuess.m
//  GuessGuess
//
//  Created by Ran Jingfu on 3/8/14.
//  Copyright (c) 2014 Ran Jingfu. All rights reserved.
//

#import "JFUtilityForGuess.h"
#import "UtilitiesFunction.h"
@implementation JFUtilityForGuess

+(void)copyDabaToDoc
{
    
     NSString    *copyPath = [UtilitiesFunction stroreDBPathInDoc];
    if ([[NSFileManager defaultManager] fileExistsAtPath:copyPath])
    {
        return;
    }else
    {
        DLOG(@"need copyDabaToDoc");
    }
    NSString    *localedb = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"puzzleInfo.db"];
    
    NSError *error = nil;
    NSData  *data = [NSData dataWithContentsOfFile:localedb options:NSDataReadingMappedIfSafe error:&error];
    if (error || !data)
    {
        DLOG(@"read file %@ occur error:%@",localedb,error);
    }
    
    if (data && !error)
    {
       
       BOOL bsuc =  [data writeToFile:copyPath options:NSDataWritingFileProtectionComplete error:&error];
        
        if (error || !bsuc)
        {
            [[NSFileManager defaultManager] removeItemAtPath:copyPath error:nil];
            DLOG(@"write to file:%@ error:%@",copyPath,error);
        }
    }
}

@end
