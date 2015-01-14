//
//  JFChagreCell.m
//  GuessImageWar
//
//  Created by ran on 13-12-14.
//  Copyright (c) 2013年 com.lelechat.GuessImageWar. All rights reserved.
//

#import "JFChargeCell.h"
#import "PublicClass.h"
#import "JFAudioPlayerManger.h"
@implementation JFChargeCell
@synthesize model;
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateDataWithModel:(JFChargeProductModel*)tempModel
{
    self.model = tempModel;
    

    
    if (!m_imageIcon)
    {
        m_imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(7, (70-15)/2, 27, 15)];
        [self.contentView addSubview:m_imageIcon];
    }
    
    
    UIImage *image = [PublicClass getImageAccordName:@"gold_icon.png"];
    m_imageIcon.image  = image;
    [m_imageIcon setFrame:CGRectMake(20, (70-image.size.height/2)/2, image.size.width/2, image.size.height/2)];

    if (!m_labelMoney)
    {
        m_labelMoney = [[JFLabelTrace alloc] initWithFrame:CGRectMake(100, (70-20)/2, 100, 20) withShadowColor:TEXTCOMMONCOLORSecond offset:CGSizeMake(1, 1) textColor:[UIColor whiteColor]];
        [m_labelMoney setFont:TEXTFONTWITHSIZE(20)];
        [m_labelMoney setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:m_labelMoney];
        
    }
    
    [m_labelMoney setText:[NSString stringWithFormat:@"%0.0f",self.model.productValue]];
    
    if (!m_btnPurchase)
    {
        m_btnPurchase = [[JFButtonTrace alloc] initWithFrame:CGRectMake(200, (70-70)/2, 80, 70) withshadowColor:[UIColor colorWithRed:0x15*1.0/255.0 green:0x75*1.0/255.0 blue:0x06*1.0/255.0 alpha:1] withTextColor:[UIColor whiteColor] title:@""];
        [m_btnPurchase setBackgroundImage:[PublicClass getImageAccordName:@"charge_btn.png"] forState:UIControlStateNormal];
        [m_btnPurchase setBackgroundImage:[PublicClass getImageAccordName:@"charge_btn_pressed.png"] forState:UIControlStateHighlighted];
        [m_btnPurchase addTarget:self action:@selector(clickChargeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [m_btnPurchase setTextFont:TEXTFONTWITHSIZE(13)];
        [self.contentView addSubview:m_btnPurchase];
    }
    [m_btnPurchase setTextTitle:[NSString stringWithFormat:@"%0.2f",self.model.productMoney*1.0]];
    
    
}

-(void)clickChargeBtn:(id)sender
{
    [JFAudioPlayerManger playWithMediaType:JFAudioPlayerMangerTypeButtonClick];
    if (delegate && [delegate respondsToSelector:@selector(chargeProductModel:)])
    {
        [delegate chargeProductModel:self.model];
    }
//[self getSelfImageAndWritoFile];
}



-(void)getSelfImageAndWritoFile
{
    UIImage  *submage = [UIImage getScreenImageWithView:self size:self.contentView.frame.size];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:submage];
    UIView  *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 960)];
    [bgview setBackgroundColor:[UIColor clearColor]];
    [bgview addSubview:imageView];
    imageView.center = bgview.center;
    
    
    UIImage *mainImage = [UIImage getScreenImageWithView:bgview size:bgview.frame.size];

    NSData  *data = UIImagePNGRepresentation(mainImage);
    static int i = 0;
    NSString    *time = [NSString stringWithFormat:@"%d.png",i];
    i++;
    NSString    *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:time];
    [data writeToFile:path atomically:NO];
    
}

-(void)dealloc
{
    [m_btnPurchase release];
    m_btnPurchase = nil;
    [m_labelMoney release];
    m_labelMoney = nil;
    [m_imageIcon release];
    m_imageIcon = nil;
    self.model = nil;
    [super dealloc];
}

@end
