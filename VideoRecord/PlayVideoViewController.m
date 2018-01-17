//
//  PlayVideoViewController.m
//  VideoRecord
//
//  Created by lwq on 15/4/27.
//  Copyright (c) 2015年 lwq. All rights reserved.
//

#import "PlayVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayVideoViewController ()<UITextFieldDelegate>

@end

@implementation PlayVideoViewController
{

    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    AVPlayerItem *playerItem;
    UIImageView* playImg;    
}

@synthesize videoURL;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"预览";
    
    float videoWidth = self.view.frame.size.width;
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 64, videoWidth, videoWidth);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];
    
    UITapGestureRecognizer *playTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
    [self.view addGestureRecognizer:playTap];
    
    [self pressPlayButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    playImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    playImg.center = CGPointMake(videoWidth/2, videoWidth/2);
    [playImg setImage:[UIImage imageNamed:@"videoPlay"]];
    [playerLayer addSublayer:playImg.layer];
    playImg.hidden = YES;
    

    
    UIButton *finishBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    finishBt.center = CGPointMake(videoWidth-35,80+64+videoWidth+20);
    finishBt.adjustsImageWhenHighlighted = NO;
    finishBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBt setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    [finishBt setTitle:@"上传" forState:UIControlStateNormal];
    [finishBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self resizeWithDistance:5 offset:0 but:finishBt];
    [finishBt addTarget:self action:@selector(finishBtTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBt];
    
    UIButton *finishBt2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    finishBt2.center = CGPointMake(35,80+64+videoWidth+20);
    finishBt2.adjustsImageWhenHighlighted = NO;
    finishBt2.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBt2 setImage:[UIImage imageNamed:@"review"] forState:UIControlStateNormal];
    [finishBt2 setTitle:@"重拍" forState:UIControlStateNormal];
    [finishBt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self resizeWithDistance:5 offset:0 but:finishBt2];
    [finishBt2 addTarget:self action:@selector(review) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBt2];
}



//重录
- (void)review
{
    [self.navigationController popViewControllerAnimated:YES];
}

//上传
- (void)finishBtTap
{
    NSData *data1 = [NSData dataWithContentsOfFile:_URLStr];
    [self send:data1];
}


- (void)send:(NSData *)data{
   
}



-(void)playOrPause{
    if (playImg.isHidden) {
        playImg.hidden = NO;
        [player pause];
        
    }else{
        playImg.hidden = YES;
        [player play];
    }
}

- (void)pressPlayButton
{
    [playerItem seekToTime:kCMTimeZero];
    [player play];
}

- (void)playingEnd:(NSNotification *)notification
{
    if (playImg.isHidden) {
        [self pressPlayButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)resizeWithDistance:(int)distance offset:(CGFloat)offset but:(UIButton *)but{
    if (distance % 2) {
        distance ++;
    }
    [but.imageView setContentMode:UIViewContentModeCenter];
    [but.titleLabel setContentMode:UIViewContentModeCenter];
    NSString *title = [but titleForState:UIControlStateNormal];
    UIImage *image = [but imageForState:UIControlStateNormal];
    CGSize titleSize =  [self sizeWithFont:but.titleLabel.font forWidth:0 title:title];
    //    title sizewithfoir
    float y = titleSize.height + distance / 4.0f;
    UIEdgeInsets titleInset = UIEdgeInsetsMake(distance / 2.0f - y + offset, -image.size.width, -(image.size.height + titleSize.height), 0.0);
    UIEdgeInsets imageInset = UIEdgeInsetsMake(-distance / 2.0f - y + offset, floorf((but.frame.size.width - image.size.width) / 2.0f), 0, floorf((but.frame.size.width - image.size.width) / 2.0f));
    [but setTitleEdgeInsets:titleInset];
    [but setImageEdgeInsets:imageInset];
}


- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width title:(NSString *)str{
    NSParameterAssert(font);
    if (width > 0) {
        CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
        return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
    } else {
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName: font}];
        return CGSizeMake(ceil(size.width), ceil(size.height));
    }
}

@end
