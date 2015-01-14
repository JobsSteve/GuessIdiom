//
//  JFYouMIManger.m
//  i366
//
//  Created by ran on 13-11-22.
//
//
#if 0
#import "JFYouMIManger.h"
#import "YouMiWall.h"
#import "JFAppDelegate.h"
#import "YouMiView.h"
#import "JFLocalPlayer.h"
#import "DMAdView.h"
#import  <iAd/iAd.h>
//dbab71e4686f0d3e
//4cb7892a392e2049
#define  YOUMISDKAPPID       @"3699b6f7a99d1a25"
#define  YOUMISDKAPPSECRECT  @"b302c8923bf9d3e9"
#define  DuoMengPusherID @"56OJwAq4uNDopLgfvX"
#define  DuoMengADID     @"16TLuRqlApUkiNU0bFIy9Hgs"

#define ISDUOMENGTEST       0

#ifndef isPad
#define isPad                           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif


//#define  YOUMISDKAPPID       @"dbab71e4686f0d3e"
//#define  YOUMISDKAPPSECRECT  @"4cb7892a392e2049"

static  JFYouMIManger   *youMiinstance = nil;
static  YouMiView       *youmiViewshanece = nil;

@interface JFYouMIManger ()<DMAdViewDelegate,ADBannerViewDelegate>
{
    DMAdView       *dmView;
    ADBannerView   *m_appleIadView;
}
@property(nonatomic,strong)UIView   *superView;
@property(nonatomic,strong)UIViewController   *roortViewContrller;
@property(nonatomic)CGRect  frame;
@end

@implementation JFYouMIManger
@synthesize delegate;
@synthesize app_userID;
@synthesize superView;
@synthesize frame;
@synthesize roortViewContrller;


-(void)deallocDmView
{
    dmView.delegate = nil;
    dmView.rootViewController = nil;
    [dmView removeFromSuperview];
    dmView = nil;
    
}
+(id)shareInstanceWithUserID:(int)userID
{
    if (youMiinstance == nil)
    {
        youMiinstance = [[JFYouMIManger alloc] init];
    }
    [youMiinstance setApp_userID:userID];
    
    return youMiinstance;
}

+(void)addYouMiadView:(UIView*)superView frame:(CGRect)frame rootViewController:(UIViewController*)rootViewController
{

    if (!youmiViewshanece)
    {
        if (!youMiinstance)
        {
            youMiinstance = [JFYouMIManger shareInstanceWithUserID:[[[JFLocalPlayer shareInstance] userID] intValue]];
        }
        
#if ISDUOMENGTEST
        youMiinstance.superView = superView;
        youMiinstance.frame = frame;
        youMiinstance.roortViewContrller = rootViewController;
        [youMiinstance addDmView];
        return;
#endif
        
        if (!isPad)
        {
            youmiViewshanece = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:youMiinstance];
        }else
        {
            youmiViewshanece = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier728x90 delegate:youMiinstance];
        }
        [youmiViewshanece start];
    }
    [youmiViewshanece setFrame:frame];
    if ([youmiViewshanece superview])
    {
        [youmiViewshanece removeFromSuperview];
    }
    [superView addSubview:youmiViewshanece];
    
    youMiinstance.roortViewContrller = rootViewController;
    youMiinstance.superView = superView;
    youMiinstance.frame = frame;
    
}

+(void)removeYouMiView
{
    if (youmiViewshanece && youmiViewshanece.superview)
    {
        [youmiViewshanece removeFromSuperview];
    }
    
    [youMiinstance deallocDmView];
    
    
}

+(void)sharedealloc
{
    #if __has_feature(objc_arc)
        youMiinstance = nil;
    #else
    if (youMiinstance == nil)
    {
        [youMiinstance release];
        youMiinstance = nil;
    }
    #endif
#if __has_feature(objc_arc)
    
#endif
}

+(void)showSpotView
{
    [YouMiWallSpot showSpotViewWithBlock:^
    {
        DLOG(@"showSpotView ");
    }];
}

-(void)setUserID:(int)TempuserID
{
    self.app_userID = TempuserID;
   [YouMiConfig setUserID:[NSString stringWithFormat:@"%d",TempuserID]];
    
}

-(void)addDmView
{
    [youmiViewshanece removeFromSuperview];
    
    if (!dmView)
    {
        dmView = [[DMAdView alloc] initWithPublisherId:DuoMengPusherID placementId:DuoMengADID autorefresh:YES];
        dmView.delegate = self;
        dmView.rootViewController = self.roortViewContrller;
        dmView.frame = self.frame;
        [self.superView addSubview:dmView];
    }
    
    [dmView loadAd];
}
-(id)init
{
 
    self = [super init];
    if (self)
    {
        
        m_arrayData = [[NSMutableArray alloc] init];
        
        JFAppDelegate  *appdelegate = (JFAppDelegate*)[UIApplication sharedApplication].delegate;
        [YouMiConfig launchWithAppID:YOUMISDKAPPID appSecret:YOUMISDKAPPSECRECT];
        [YouMiConfig setChannelID:100 description:@"App Store"];
        [YouMiPointsManager enable];
        [YouMiWall enable];
        [YouMiPointsManager enableManually];
#if DEBUG
        [YouMiConfig setIsTesting:YES];
#else
        [YouMiConfig setIsTesting:NO];
#endif
        [YouMiConfig setFullScreenWindow:appdelegate.window];
        [YouMiConfig setUseInAppStore:NO];
        [YouMiConfig setShouldGetLocation:NO];
        [YouMiConfig setUserID:[NSString stringWithFormat:@"%d",self.app_userID]];
       
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointerGeted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];
    }
    return self;
}


-(void)addAppleiAd
{
    if (!m_appleIadView)
    {
        m_appleIadView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        m_appleIadView.delegate = self;
        [self.superView addSubview:m_appleIadView];
    }
 
  
  //  CGRect  frame = [UIScreen mainScreen].bounds;
    [m_appleIadView setFrame:self.frame];
    m_appleIadView.alpha = 0;
    
}



-(void)showYouMiPointAppViewController
{
    
    
    JFAppDelegate  *appdelegate = (JFAppDelegate*)[UIApplication sharedApplication].delegate;
    static   UIWindow  *view = nil;
    if (view != nil)
    {
        [view release];
        view = nil;
    }
    view =     [[UIWindow alloc] initWithFrame:appdelegate.window.bounds];
    [view setBackgroundColor:[UIColor whiteColor]];
    [appdelegate.window addSubview:view];
    [view makeKeyAndVisible];

    
    [YouMiConfig setFullScreenWindow:view];
    [YouMiWall showOffers:NO didShowBlock:^
     {
         DLOG(@"showYouMiPointAppViewController");
     } didDismissBlock:^
     {
         
         [self performSelectorOnMainThread:@selector(makeOnMainThread:) withObject:view waitUntilDone:YES];
         DLOG(@"dismiss showYouMiPointAppViewController");
     }];
    
}

-(void)makeOnMainThread:(UIWindow*)window
{
    
    JFAppDelegate  *appdelegate = (JFAppDelegate*)[UIApplication sharedApplication].delegate;
    [window setHidden:YES];
    [window resignKeyWindow];
   // [window resignFirstResponder];
    [window removeFromSuperview];
    [appdelegate.window makeKeyAndVisible];
    
}


-(void)GetYouMiAppSourceData:(int)page count:(int)count
{
    [YouMiWall requestOffersOpenData:YES page:page count:count revievedBlock:^(NSArray *arraydata,NSError *error)
     {
         if (!error)
         {
             DLOG(@"arraydata:%@ ",arraydata);
         }else
         {
             DLOG(@"GetYouMiAppSourceData error:%@",error);
         }
     }];
}


- (void)pointerGeted:(NSNotification *)notification
{
    
    NSDictionary *dict = [notification userInfo];
    // 手动积分管理可以通过下面这种方法获得每份积分的信息。
    NSArray *pointInfos = [dict objectForKey:kYouMiPointsManagerPointInfosKey];
    for (NSDictionary *aPointInfo in pointInfos)
    {
        // aPointInfo 是每份积分的信息，包括积分数，userID，下载的APP的名字
        DLOG(@"积分数：%@", aPointInfo[kYouMiPointsManagerPointAmountKey]);
        DLOG(@"userID：%@", aPointInfo[kYouMiPointsManagerPointUserIDKey]);
        DLOG(@"产品名字：%@", aPointInfo[kYouMiPointsManagerPointProductNameKey]);
        
        // TODO 按需要处理
    }
}

-(void)dealloc

{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    #if __has_feature(objc_arc)
    [m_arrayData release];
    m_arrayData = nil;
    #else
    m_arrayData = nil;
    #endif
    [super dealloc];
}


- (void)didReceiveAd:(YouMiView *)adView
{
    
}

// Send after fail to receive ad data from server
// p.s. send after the first failed request and every following failed request
//
// 请求广告条数据失败后调用
//
// 详解:
//      当接收服务器返回的广告数据失败后调用该方法
// 补充:
//      第一次和接下来每次如果请求失败都会调用该方法
//
- (void)didFailToReceiveAd:(YouMiView *)adView  error:(NSError *)error
{
    if (error)
    {
        DLOG(@"didFailToReceiveAd:%@",error);
        [self addDmView];
    }
}




#pragma mark Click-Time Notifications Methods

// Send before presenting the full screen view
//
// 将要显示全屏广告前调用
//
// 详解:
//      将要显示一次全屏广告内容前调用该方法
//
- (void)willPresentScreen:(YouMiView *)adView
{
    
}

// Send after presenting the full screen view
//
// 显示全屏广告成功后调用
//
// 详解:
//      显示一次全屏广告内容后调用该方法
//
- (void)didPresentScreen:(YouMiView *)adView
{
    
}

// Send before dismiss the full screen view
//
// 将要关闭全屏广告前调用
//
// 详解:
//      全屏广告将要关闭前调用该方法
//
- (void)willDismissScreen:(YouMiView *)adView
{
    
}

// Send after sucessful dismiss the full screen view
//
// 成功关闭全屏广告后调用
//
// 详解:
//      全屏广告显示完成，关闭全屏广告后调用该方法
//
- (void)didDismissScreen:(YouMiView *)adView
{
    
}


#pragma mark    DMAdViewDelegate
// Sent when an ad request success to loaded an ad
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    
}
// Sent when an ad request fail to loaded an ad
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    #if DEBUG
    NSLog(@"dmAdViewFailToLoadAd:%@ error:%@",adView,error);
    #endif
    if (error)
    {
        [self addAppleiAd];
    }
}
// Sent when the ad view is clicked
- (void)dmAdViewDidClicked:(DMAdView *)adView
{
     #if DEBUG
    NSLog(@"dmAdViewDidClicked:%@",adView);
    #endif
}
// Sent just before presenting the user a modal view
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView
{
    #if DEBUG
    NSLog(@"dmWillPresentModalViewFromAd:%@",adView);
    #endif
}
// Sent just after dismissing the modal view
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView
{
    
#if DEBUG
    NSLog(@"dmDidDismissModalViewFromAd:%@",adView);
#endif
}
// Sent just before the application will background or terminate because the user's action
// (Such as the user clicked on an ad that will launch App Store).
- (void)dmApplicationWillEnterBackgroundFromAd:(DMAdView *)adView
{
#if DEBUG
    NSLog(@"dmApplicationWillEnterBackgroundFromAd:%@",adView);
#endif
}




#pragma mark ADBannerViewdelegate
- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    // banner.alpha = 1;
    NSLog(@"bannerViewWillLoadAd:%@",banner);
}

/*!
 * @method bannerViewDidLoadAd:
 *
 * @discussion
 * Called each time a banner loads a new ad. Once a banner has loaded an ad, it
 * will display it until another ad is available.
 *
 * It's generally recommended to show the banner view when this method is called,
 * and hide it again when bannerView:didFailToReceiveAdWithError: is called.
 */
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"bannerViewDidLoadAd:%@",banner);
    banner.alpha = 1;
}

/*!
 * @method bannerView:didFailToReceiveAdWithError:
 *
 * @discussion
 * Called when an error has occurred while attempting to get ad content. If the
 * banner is being displayed when an error occurs, it should be hidden
 * to prevent display of a banner view with no ad content.
 *
 * @see ADError for a list of possible error codes.
 */
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    banner.alpha = 0;
    NSLog(@"bannerView:%@  didFailToReceiveAdWithError:%@",banner,error);
    
}

/*!
 * @method bannerViewActionShouldBegin:willLeaveApplication:
 *
 * Called when the user taps on the banner and some action is to be taken.
 * Actions either display full screen content modally, or take the user to a
 * different application.
 *
 * The delegate may return NO to block the action from taking place, but this
 * should be avoided if possible because most ads pay significantly more when
 * the action takes place and, over the longer term, repeatedly blocking actions
 * will decrease the ad inventory available to the application.
 *
 * Applications should reduce their own activity while the advertisement's action
 * executes.
 */
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"bannerViewActionShouldBegin:%@  willLeaveApplication:%d",banner,willLeave);
    return YES;
}


- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
   NSLog(@"bannerViewActionDidFinish:%@",banner);
}
@end

#endif
