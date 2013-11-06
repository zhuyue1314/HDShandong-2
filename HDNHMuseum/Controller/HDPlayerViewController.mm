//
//  HDPlayerViewController.m
//  HDDGMuseum
//
//  Created by Li Shijie on 13-4-22.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HDItem.h"
#import "HDDeclare.h"
#import "HDConnectModel.h"
#import "HDScrollView.h"


@interface HDPlayerViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *textView;
@property (weak, nonatomic) IBOutlet UILabel *audioCurrentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioLeftTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *audioImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UISlider *audioSlider;
@property (weak, nonatomic) IBOutlet UIButton *audioControlButton;
@property (strong,nonatomic)id timeObserver;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet HDScrollView *hdImageScrollView;


@property (strong,nonatomic) HDItem *currentItem;
@property (strong,nonatomic) AVPlayer *audioPlayer;
@property (strong,nonatomic) MPMoviePlayerViewController *moviePlayerViewController;
@property (nonatomic) BOOL firstLoad;

- (IBAction)updateCurrentTime:(UISlider *)sender;
- (IBAction)audioControlAction:(UIButton *)sender;
-(void)updateSliderValue;
@end
static HDDeclare *declare;
static HDConnectModel *connect;

@implementation HDPlayerViewController

void audioRouteChangeListenerCallback (
                                       void                      *inUserData,
                                       AudioSessionPropertyID    inPropertyID,
                                       UInt32                    inPropertyValueS,
                                       const void                *inPropertyValue
                                       )
{
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange)
        return;
    CFDictionaryRef routeChangeDictionary = (CFDictionaryRef)inPropertyValue;
    
    CFNumberRef routeChangeReasonRef =(CFNumberRef) CFDictionaryGetValue (
                                                                          routeChangeDictionary,
                                                                          CFSTR (kAudioSession_AudioRouteChangeKey_Reason)
                                                                          );
    
    SInt32 routeChangeReason;
    
    CFNumberGetValue (
                      routeChangeReasonRef,
                      kCFNumberSInt32Type,
                      &routeChangeReason
                      );
    //NSLog(@" ======================= RouteChangeReason : %d", (int)routeChangeReason);
    if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Pause"
                                                            object:nil];
    }
    
    UInt32 propertySize = sizeof(CFStringRef);
    CFStringRef state = nil;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
                            ,&propertySize,&state);
    //NSLog(@"audioRouteChangeListenerCallback:%@",(__bridge NSString *)state);
    if ([(__bridge NSString *)state isEqualToString:@"ReceiverAndMicrophone"])
    {
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    }

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _audioPlayer = [[AVPlayer alloc]init];
        declare = [HDDeclare sharedDeclare];
        connect = [HDConnectModel sharedConnect];
        _firstLoad = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollview.contentSize = CGSizeMake(320, self.scrollview.frame.size.height+1);
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.opaque = NO;
    self.textView.dataDetectorTypes = UIDataDetectorTypeNone;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0, 0.0, 50.0, 29.0);
    [leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    
    [self.audioImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTap:)];
    [self.audioImage addGestureRecognizer:singleTap];
    
    
    [self.audioSlider setMinimumTrackImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [self.audioSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    
    [self.audioSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateHighlighted];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioControlAction:)
                                                 name:@"Pause"
                                               object:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if (self.firstLoad == YES)
        {
            self.firstLoad = NO;
            [self stopAudio];
            [self playItem:self.currentItem];
        }

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setAudioCurrentTimeLabel:nil];
    [self setAudioLeftTimeLabel:nil];
    [self setAudioImage:nil];
    [self setBackgroundImage:nil];
    [self setTextView:nil];
    [self setAudioSlider:nil];
    [self setAudioControlButton:nil];
    [self setScrollview:nil];
    [super viewDidUnload];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self hasMicphone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoDemand:)
                                                 name:@"result"
                                               object:nil];
    UInt32 audioRouteOverride = [self hasHeadset] ?kAudioSessionOverrideAudioRoute_None:kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    void *player = (__bridge void *)self;
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,audioRouteChangeListenerCallback,player);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self stopAudio];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"result"
                                                 object:nil];
}
-(void)back
{
    [self stopAudio];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)autoDemand:(NSNotification*)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *number = [dic objectForKey:@"content"];
    for (int i = 0; i<[self.itemArray count]; i++)
    {
        HDItem *item = [self.itemArray objectAtIndex:i];
        if ([number intValue] == [item.identifier intValue])
        {
            if (item == self.currentItem)
            {
                return;
            }
            NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[declare applicationLibraryDirectory],declare.language,item.audio];
            if (![[NSFileManager defaultManager]fileExistsAtPath:path])
            {
                [self back];
                return;
            }
             dispatch_queue_t mainQueue = dispatch_get_main_queue();
             dispatch_async(mainQueue,^{
                 [self playItem:item];
             });
        }
    }

}
- (BOOL)hasMicphone
{
    return [[AVAudioSession sharedInstance] inputIsAvailable];
}
-(BOOL)hasHeadset
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    CFStringRef route = NULL;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    NSString* routeStr = (__bridge  NSString*)route;
    if(route == nil)
    {
        // Silent Mode
       // NSLog(@"AudioRoute: SILENT, do nothing!");
    } else {
        // NSString* routeStr = ( NSString*)route;
       //  NSLog(@"AudioRoute: %@", routeStr);
        
        /* Known values of route:
         * "Headset"
         * "Headphone"
         * "Speaker"
         * "SpeakerAndMicrophone"
         * "HeadphonesAndMicrophone"
         * "HeadsetInOut"
         * "ReceiverAndMicrophone"
         * "Lineout"
         */
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        if (headphoneRange.location != NSNotFound) {
            return YES;
        } else if(headsetRange.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
#endif
}

- (void)addTimeObserverToPlayer
{
    if (self.timeObserver)
		return;
    double interval = 0.1;
    CMTime time = [self.audioPlayer.currentItem duration];
    double duration = CMTimeGetSeconds(time);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([self.audioSlider bounds]);
        interval = 0.5 * duration / width;
    }
    __block __weak HDPlayerViewController *player = self;
    self.timeObserver = [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                                  queue:dispatch_get_main_queue()
                                                                  usingBlock:^(CMTime time){
                                                                      [player updateSliderValue];
                                                                  }];
}
-(void)updateSliderValue
{
    double duration = CMTimeGetSeconds([self.audioPlayer.currentItem duration]);
	double time = CMTimeGetSeconds([self.audioPlayer currentTime]);
	if (isfinite(duration))
	{
        if (time == duration)
        {
            [self back];
            return;
        }
        [self.audioSlider setValue:time / duration];
		NSString *currentTime = @"0:00:00";
        NSString *leftTime  = @"0:00:00";
        if (isfinite(time))
        {
            if (time < 0.0)
            {
                time = 0.0;
            }
            int secondsInt = round(time);
            int minutes = secondsInt/60;
            int minutesOnes = minutes%10;
            int minutesTens = minutes/10;
            secondsInt -= minutes*60;
            int secondsOnes = secondsInt%10;
            int secondsTens = secondsInt/10;
            
             currentTime= [NSString stringWithFormat:@"0:%i%i:%i%i", minutesTens,minutesOnes,secondsTens, secondsOnes];
        }
        double lefttime = duration -time;
        if (isfinite(lefttime))
        {
            if (lefttime < 0.0)
            {
                lefttime = 0.0;
            }
            int secondsInt = round(lefttime);
            int minutes = secondsInt/60;
            int minutesOnes = minutes%10;
            int minutesTens = minutes/10;
            secondsInt -= minutes*60;
            int secondsOnes = secondsInt%10;
            int secondsTens = secondsInt/10;
            leftTime = [NSString stringWithFormat:@"0:%i%i:%i%i", minutesTens,minutesOnes,secondsTens, secondsOnes];
        }
        if ([leftTime isEqualToString:@"0:00:00"])
        {
            [self back];
        }
        _audioCurrentTimeLabel.text = currentTime;
        _audioLeftTimeLabel.text = leftTime;
	}	
}
-(void)stopAudio
{
    [self.audioPlayer pause];
    self.audioPlayer = nil;
    audioPlaying = NO;
    [self removeTimeObserverFromPlayer];
    self.audioSlider.value = 0;
    self.audioLeftTimeLabel.text = @"0:00:00";
    self.audioCurrentTimeLabel.text = @"0:00:00";
}
- (void)removeTimeObserverFromPlayer
{
    if (self.timeObserver)
	{
		[self.audioPlayer removeTimeObserver:self.timeObserver];
		self.timeObserver = nil;
	}
}
-(void)playItem:(HDItem *)item
{
    self.currentItem = item;
    if (audioPlaying)
    {
        [self stopAudio];
    }
    [self playAudio:item];
}

- (IBAction)updateCurrentTime:(UISlider *)sender
{
    if (self.audioSlider.value == 1.0)
    {
        [self back];
    }
    double duration = CMTimeGetSeconds([self.audioPlayer.currentItem duration]);
	
	if (isfinite(duration))
	{
        float value = [sender value];
		double time = duration*value;
        [self removeTimeObserverFromPlayer];
        float  _playRateToRestore = [self.audioPlayer rate];
        [self.audioPlayer setRate:0.0];
        [self.audioPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
        [self.audioPlayer setRate:_playRateToRestore];
        [self addTimeObserverToPlayer];
    }
}

- (IBAction)audioControlAction:(UIButton *)sender
{
    if (audioPlaying)
    {
        [self.audioPlayer pause];
        audioPlaying = NO;
        [self.audioControlButton setImage:[UIImage imageNamed:@"playAudio.png"] forState:UIControlStateNormal];
        [self removeTimeObserverFromPlayer];
    }
    else
    {
        [self.audioPlayer play];
        audioPlaying = YES;
        [self.audioControlButton setImage:[UIImage imageNamed:@"pauseAudio.png"] forState:UIControlStateNormal];
        [self addTimeObserverToPlayer];
    }
}

-(void)playAudio:(HDItem *)item
{
    //playn文件编号（8位）
    self.title = item.name;
    NSString *content = [NSString stringWithFormat:@"playn0000%@",item.identifier];
    [connect sendContent:content WithTarget:[[HDDeclare sharedDeclare] channel] WithCompleteBlock:^(NSDictionary *re){
        NSLog(@"统计播放%@",re);
    }];
    NSString *audioPath = [NSString stringWithFormat:@"%@/%@/%@",[declare applicationLibraryDirectory],declare.language,item.audio];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@",[declare applicationLibraryDirectory],declare.language,item.image];
    NSString *hdImagePath = [NSString stringWithFormat:@"%@/%@/%@_hd.png",[declare applicationLibraryDirectory],declare.language,[item.image stringByDeletingPathExtension]];
    NSString *textPath = [NSString stringWithFormat:@"%@/%@/%@.txt",[declare applicationLibraryDirectory],declare.language,[item.desc stringByDeletingPathExtension]];
    NSString *textViewFormat = @"<style>body{margin:0;background-color:transparent;text-indent: 2em;font:16px/23px Custom-Font-Name}</style>";
    NSString *textViewText = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:nil];
    NSString *text = [textViewFormat stringByAppendingFormat:@"%@",textViewText];
    [self.textView loadHTMLString:text baseURL:nil];
    
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    self.audioPlayer = [[AVPlayer alloc]initWithURL:audioURL];
    self.hdImageScrollView.hidden = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        self.audioImage.image = [UIImage imageWithContentsOfFile:imagePath];
        self.hdImageScrollView.imageView.image = [UIImage imageWithContentsOfFile:hdImagePath];
    }
    else
    {
        self.audioImage.image = [UIImage imageNamed:@"audioImage"];
        self.hdImageScrollView.imageView.image = [UIImage imageNamed:@"audioImage"];
    }
    
    
    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    AudioSessionSetActive(true);
    CMTime time = [self.audioPlayer.currentItem duration];
    double duration = CMTimeGetSeconds(time);
	if (isfinite(duration))
    {
		if (duration < 0.0)
        {
			duration = 0.0;
		}
		int secondsInt = round(duration);
		int minutes = secondsInt/60;
        int minutesOnes = minutes%10;
        int minutesTens = minutes/10;
		secondsInt -= minutes*60;
		int secondsOnes = secondsInt%10;
		int secondsTens = secondsInt/10;
        
		_audioLeftTimeLabel.text = [NSString stringWithFormat:@"0:%i%i:%i%i", minutesTens,minutesOnes,secondsTens, secondsOnes];
	}
    [self.audioPlayer play];
    audioPlaying = YES;
    [self.audioControlButton setImage:[UIImage imageNamed:@"pauseAudio.png"] forState:UIControlStateNormal];
    
    [self addTimeObserverToPlayer];
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (self.hdImageScrollView.hidden)
    {
        self.hdImageScrollView.hidden = NO;
        //        [self.hdDelegate HDScrollViewDelegateZoomOut:self];
        //        scaled = NO;
    }
    else
    {
        self.hdImageScrollView.hidden = YES;
        //        [self.hdDelegate HDScrollViewDelegateZoomIn:self];
        //        scaled = YES;
    }
}

@end
