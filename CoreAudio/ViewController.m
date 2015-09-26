//
//  ViewController.m
//  CoreAudio
//
//  Created by Bhavik Panchal on 9/25/15.
//  Copyright © 2015 Bhavik Panchal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   
    dispatch_async(dispatchQueue, ^(void)
    {
        NSError *audioSessionError = nil;
        
        // Create the audio session object and Set the session active or inactive for the core audio
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        [audioSession setActive:YES error:nil];
    
        if ([audioSession setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError])
        
        {
            NSLog(@"Successfully set the audio session.");
        }
        
        else
         {
                NSLog(@"Could not set the audio session");
         }
        
        //create thr bundle object and set filepath of the audio and set into the nsdata object with the filepath
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        
        NSString *filePath = [mainBundle pathForResource:@"song"
                                                  ofType:@"mp3"];
        
        NSData   *fileData = [NSData dataWithContentsOfFile:filePath];
        
        NSError  *error = nil;
       
        /* Start the audio player */
        
        //alloc the audio player of the avaudio player
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData
                                                         error:&error];
        
        /* Did we get an instance of AVAudioPlayer? 
         if audio not nil than prepare the audio for playing */
        
        if (self.audioPlayer != nil)
        
        {
            /* Set the delegate and start playing */
            
            self.audioPlayer.delegate = self;
          
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play])
            {
                NSLog(@"Successfully started playing...");
            }
            
            else
            {
                NSLog(@"Failed to play.");
            }
        } });
                       // Do any additional setup after loading the view, typically from a nib.
}


- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    /* Audio Session is interrupted.The player will be paused here */
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
                       withOptions:(NSUInteger)flags
{
    /* Check the flags, if we can resume the audio,then we should do it here */
    
    if (flags == AVAudioSessionInterruptionOptionShouldResume)
    {
        [player play];
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Finished playing the song");
    /* The flag parameter tells us if the playback was successfully
     finished or not */
    if ([player isEqual:self.audioPlayer])
    {
        self.audioPlayer = nil;
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
