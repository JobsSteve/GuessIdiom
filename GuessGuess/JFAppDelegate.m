//
//  JFAppDelegate.m
//  GuessGuess
//
//  Created by Ran Jingfu on 2/24/14.
//  Copyright (c) 2014 Ran Jingfu. All rights reserved.
//

#import "JFAppDelegate.h"
#import "JFLauchViewController.h"
#import "JFUtilityForGuess.h"
#import "UMSocial.h"
#import "MyStoreObserver.h"
//#import "UMSocialFacebookHandler.h"
//#import "UMSocialLaiwangHandler.h"
#import "UMSocialWechatHandler.h"
//#import "UMSocialTwitterHandler.h"
#import "UMSocialSinaHandler.h"



@implementation JFAppDelegate


- (void)SaveLogInfo
{
    
#if DEBUG
    pid_t   ppid = getppid();
    if (ppid == 1)
    {
        NSString  *strFileName = @"log0.txt";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //strFileName = [documentsDirectory stringByAppendingPathComponent:strFileName];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc]init] autorelease];
        [formatter setDateFormat:@"yyyyMMddHHmm"];
        NSString *timeStr = [formatter stringFromDate:date];
        
        NSString  *strDoc = [documentsDirectory stringByAppendingPathComponent:@"lelechat_debuglogdoc"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:strDoc])
        {
            BOOL  suc =  [[NSFileManager defaultManager] createDirectoryAtPath:strDoc withIntermediateDirectories:NO attributes:nil error:nil];
            if (!suc)
            {
                DLOG(@"createDirectoryAtPath :%@  fail",strDoc);
            }
        }
        strFileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"lelechat_debuglogdoc/log%@.txt", timeStr]];
        // freopen([strFileName UTF8String],"w",stdout);
        freopen([strFileName UTF8String],"w",stderr);
        
    }
#endif
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    
    
    [JFUtilityForGuess copyDabaToDoc];
    JFLauchViewController   *control = [[JFLauchViewController alloc] init];
    UINavigationController  *nav = [[UINavigationController alloc] initWithRootViewController:control];
    [control release];
    
    [self.window addSubview:nav.view];
    [self.window makeKeyAndVisible];
    
    
    self.window.rootViewController = nav;
    
    
    [self SaveLogInfo];
    
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    

    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx6be4bacc3e102286" appSecret:@"7e2497d26356f181e0ab2eb49e075a2e" url:@"http://www.umeng.com/social"];
    
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开腾讯微博SSO开关，设置回调地址
   // [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    

 
    

    
    
    
    //设置facebook应用ID，和分享纯文字用到的url地址
    //    [UMSocialFacebookHandler setFacebookAppID:@"91136964205" shareFacebookWithURL:@"http://www.umeng.com/social"];
    

    
    //[UMSocialTwitterHandler openTwitter];
    
    
    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionCenter];
    
    
    
    MyStoreObserver *tempObserver = [[MyStoreObserver alloc] init];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:tempObserver];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

@end
