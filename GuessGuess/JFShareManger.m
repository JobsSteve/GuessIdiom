//
//  JFShareManger.m
//  DrawSelf
//
//  Created by Ran Jingfu on 2/22/14.
//  Copyright (c) 2014 com.jingfu.ran. All rights reserved.
//

#import "JFShareManger.h"
#import "UMSocial.h"
#define APPLINK     @"https://itunes.apple.com/us/app/cai-mi-yu/id832088951?ls=1&mt=8"
#define SHAREHEAD   @"#猜谜语#"

static JFShareManger    *shareManger = nil;
@implementation JFShareManger


+(id)shareInstance
{
    if (!shareManger)
    {
        shareManger = [[JFShareManger alloc] init];
    }
    return shareManger;
}


+(void)shareWithMsg:(NSString*)strMsg image:(UIImage*)image viewController:(UIViewController*)viewController
{
    [[JFShareManger shareInstance] shareWithMsg:strMsg image:image viewController:viewController];
}

-(void)shareWithMsg:(NSString*)strMsg image:(UIImage*)image viewController:(UIViewController*)viewController
{

    strMsg = [NSString stringWithFormat:@"%@ %@ %@",SHAREHEAD,strMsg,APPLINK];
    //如果得到分享完成回调，需要设置delegate为self
    [UMSocialSnsService presentSnsIconSheetView:viewController appKey:UmengAppkey shareText:strMsg shareImage:image shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToEmail,UMShareToSms,UMShareToWechatSession,UMShareToWechatTimeline, nil] delegate:self];
}



-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess)
    {
        DLOG(@"didFinishGetUMSocialDataInViewController:%@",response);
    }
}

-(void)didCloseShakeView
{
    NSLog(@"didCloseShakeView");
}

-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    NSLog(@"finish share with response is %@",response);
}

@end
