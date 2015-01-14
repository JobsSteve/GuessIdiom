//
//  JFShareManger.h
//  DrawSelf
//
//  Created by Ran Jingfu on 2/22/14.
//  Copyright (c) 2014 com.jingfu.ran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialSnsService.h"
#import "UMSocialControllerService.h"
#import "UIImge-GetSubImage.h"
@interface JFShareManger : NSObject<UMSocialUIDelegate>


+(void)shareWithMsg:(NSString*)strMsg image:(UIImage*)image viewController:(UIViewController*)viewController;
@end
