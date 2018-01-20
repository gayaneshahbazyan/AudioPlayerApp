//
//  ViewController.m
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 1/20/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import "ViewController.h"
#import "UrlWithStatus.h"
#import "AudioTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "MyUserDefaults.h"

@interface ViewController () {
    UIButton* lastTappedButton;
    NSInteger lastTappedButtonIndex;
}
@property (strong, nonatomic) NSArray<NSString*> *mp3Urls;
@property (strong, nonatomic) NSMutableArray<UrlWithStatus*> *mp3WithStatusArr;

@property(nonatomic,strong) NSURLSession* mySession;
@property NSURLSessionConfiguration *configuration;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mp3Urls = [[NSArray alloc] initWithObjects:
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch10_32_Encouragement.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch11_33_HowToEncourage.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch12_41_CommunicationCycle.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch13_42_DialogueSkills.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch14_43_ListeningSkills.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch15_44_PersuadingSkills.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch16_51_SupportingEnvironment.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch17_52_HowHelpTeenager.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch1_11_Adolescence.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch2_12_ChildChanged.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch3_13_Growing.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch4_14_ProblemsAdolescence.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch5_21_WhatTeenagerWants.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch6_22_AdolescentEmotions.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch7_23_WhenClashOccur.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch8_24_AvoidClash.mp3",
                    nil];
    self.mp3WithStatusArr = [MyUserDefaults getSavedUrls] == nil ? [NSMutableArray new] : [MyUserDefaults getSavedUrls];
    self.audioTblView.delegate = self;
    self.audioTblView.dataSource = self;
    
    if (self.mp3WithStatusArr.count != 0 ) {
        [self performSelector:@selector(createURLSession) withObject:nil afterDelay:3];
        
        for (int i = 0; i < [self.mp3WithStatusArr count]; i++) {
            if (self.mp3WithStatusArr[i].status == 1) {
                // Each time when we launch app Document directory changes
                NSArray *pathSong = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *tempPath = [[pathSong objectAtIndex:0] stringByAppendingPathComponent:[[self.mp3WithStatusArr[i].savedPath.absoluteString componentsSeparatedByString:@"/"] lastObject]];
                NSURL *url = [NSURL fileURLWithPath:tempPath];
                self.mp3WithStatusArr[i].savedPath = url;
            }
        }
    } else {
        self.configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.xtech.background.DownloadManager1"];
        self.configuration.sessionSendsLaunchEvents = true;
        self.configuration.discretionary = true;
        self.mySession = [NSURLSession sessionWithConfiguration:self.configuration delegate:self delegateQueue:nil];
    }
}

-(void) createURLSession {
    
    self.configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.xtech.background.DownloadManager1"];
    self.configuration.sessionSendsLaunchEvents = true;
    self.configuration.discretionary = true;
    self.mySession = [NSURLSession sessionWithConfiguration:self.configuration delegate:self delegateQueue:nil];
    
    
}

-(void) saveAllData {
    [MyUserDefaults saveUrls: [self mp3WithStatusArr]];
}

- (IBAction)downloadAll:(id)sender {
    // Downloading and saving in document.
    if (self.mp3WithStatusArr.count != 0) {
        return;
    }
    
    //Clean Document directory before adding new mp3 files.
    NSArray *pathSong = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathSong objectAtIndex:0];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    for (NSString *urlStr in self.mp3Urls) {
        UrlWithStatus *myUrl = [[UrlWithStatus alloc] initWithUrlPath:urlStr];
        [self.mp3WithStatusArr addObject:myUrl];
    }
    // Reload table to show activity indicator.
    [self.audioTblView reloadData];
    
    for (int i = 0; i < [self.mp3WithStatusArr count]; i++) {
        NSURLSessionDownloadTask *task = [self.mySession downloadTaskWithURL: [NSURL URLWithString: self.mp3WithStatusArr[i].urlPath]];
        [task resume];
        self.mp3WithStatusArr[i].loadingTaskOfUrl = task;
    }
    [self saveAllData];
}

- (void) playBtnTapped:(UIButton *) sender {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        [lastTappedButton setTitle:@"Play" forState: UIControlStateNormal];
        if (lastTappedButtonIndex == sender.tag) {
            lastTappedButton = nil;
            lastTappedButtonIndex = -1;
            return;
        }
    }
    if (self.mp3WithStatusArr[sender.tag].savedPath != nil) {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.mp3WithStatusArr[sender.tag].savedPath error:nil];
        Boolean succeedPlaying = [self.audioPlayer prepareToPlay];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        if (succeedPlaying) {
            [sender setTitle:@"Stop" forState: UIControlStateNormal];
            [self.audioPlayer play];
        }
    }
    lastTappedButton = sender;
    lastTappedButtonIndex = sender.tag;
}

-(void) URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.backgroundSessionCompletionHandler) {
            void(^completionHandler)(void) = appDelegate.backgroundSessionCompletionHandler;
            appDelegate.backgroundSessionCompletionHandler = nil;
            completionHandler();
        }
    });
    
    NSLog(@"All tasks are finished");
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    for (int i = 0; i < [self.mp3WithStatusArr count]; i++) {
        if ([self.mp3WithStatusArr[i].urlPath isEqualToString: downloadTask.currentRequest.URL.absoluteString]) {
            if (downloadTask.countOfBytesExpectedToReceive < 0) {
                [downloadTask cancel];
                self.mp3WithStatusArr[i].status = -1;
                [self saveAllData];
                [self.audioTblView reloadData];
                return;
            }
            NSArray *pathSong = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *tempPath = [[pathSong objectAtIndex:0] stringByAppendingPathComponent:[[downloadTask.currentRequest.URL.absoluteString componentsSeparatedByString:@"/"] lastObject]];
            NSURL *url = [NSURL fileURLWithPath:tempPath];
            [[NSFileManager defaultManager]copyItemAtURL:location toURL:url error:nil];
            self.mp3WithStatusArr[i].savedPath = url;
            self.mp3WithStatusArr[i].status = 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.audioTblView reloadData];
            });
            break;
        }
    }
    [self saveAllData];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    for (int i = 0; i < [self.mp3WithStatusArr count]; i++) {
        if ([self.mp3WithStatusArr[i].urlPath isEqualToString: downloadTask.currentRequest.URL.absoluteString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AudioTableViewCell* cellToUpdate = [self.audioTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                NSInteger downloadedPercent = fabs(((totalBytesWritten * 1.0)/totalBytesExpectedToWrite) * 100);
                [cellToUpdate.downloadedPercentLbl setText: [NSString stringWithFormat:@"%ld%%",(long)downloadedPercent]];
                NSLog(@"*** %@   -> %li",downloadTask.currentRequest.URL, (long)downloadedPercent);
                if (self.mp3WithStatusArr[i].shouldResume && !self.mp3WithStatusArr[i].didResumed) {
                    self.mp3WithStatusArr[i].shouldResume = false;
                    self.mp3WithStatusArr[i].didResumed = false;
                    [downloadTask cancel];
                    [cellToUpdate.downloadedPercentLbl setText: @"0%"];
                }
            });
        }
        
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    for (int i = 0; i < [self.mp3WithStatusArr count]; i++) {
        if ([self.mp3WithStatusArr[i].urlPath isEqualToString: downloadTask.currentRequest.URL.absoluteString]) {
            self.mp3WithStatusArr[i].didResumed = true;
        }
    }
    NSLog(@"didResumeAtOffset %@",downloadTask.currentRequest.URL.absoluteString);
}


-(void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error != nil) {
        for (int i = 0; i < [self.mp3WithStatusArr count]; i++) {
            if ([self.mp3WithStatusArr[i].urlPath isEqualToString: [error.userInfo valueForKey:@"NSErrorFailingURLStringKey"]]) {
                NSURLSessionDownloadTask *taskik = nil;
                if ([error.userInfo valueForKey:@"NSURLSessionDownloadTaskResumeData"] != nil) {
                    self.mp3WithStatusArr[i].shouldResume = true;
                    taskik = [self.mySession downloadTaskWithResumeData:[error.userInfo valueForKey:@"NSURLSessionDownloadTaskResumeData"]];
                    [taskik resume];
                }
                else {
                    taskik = [self.mySession downloadTaskWithURL: [NSURL URLWithString: self.mp3WithStatusArr[i].urlPath]];
                    [taskik resume];
                    self.mp3WithStatusArr[i].loadingTaskOfUrl = taskik;
                }
            }
        }
        [self saveAllData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mp3WithStatusArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier   forIndexPath:indexPath] ;
    
    if (cell == nil) {
        cell = [[AudioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell constractCell];
    cell.tag = indexPath.row;
    cell.audioUrlLbl.text = [[self.mp3WithStatusArr[indexPath.row].urlPath componentsSeparatedByString:@"/"] lastObject];
    [cell.downloadedPercentLbl setText: [NSString stringWithFormat:@"%ld%%",self.mp3WithStatusArr[indexPath.row].downloadedPercent]];
    [cell.playAudioBtn setHidden: (!self.mp3WithStatusArr[indexPath.row].status)];
    NSLog(@"status = %li", (long)self.mp3WithStatusArr[indexPath.row].status);
    Boolean isNotLoading = (self.mp3WithStatusArr[indexPath.row].status == 1) || (self.mp3WithStatusArr[indexPath.row].status == -1);
    [cell.loadingActivityIndicator setHidden: isNotLoading];
    [cell.downloadedPercentLbl setHidden: isNotLoading];
    cell.playAudioBtn.userInteractionEnabled = (self.mp3WithStatusArr[indexPath.row].status == 1 );
    if (self.mp3WithStatusArr[indexPath.row].status == 1) {
        [cell.playAudioBtn setTitle:(self.audioPlayer.isPlaying && lastTappedButtonIndex == cell.tag) ? @"Stop" : @"Play" forState: UIControlStateNormal];
    }
    else if (self.mp3WithStatusArr[indexPath.row].status == -1) {
        [cell.playAudioBtn setTitle: @"Fail" forState: UIControlStateNormal];
        cell.playAudioBtn.userInteractionEnabled = false;
    }
    [cell.playAudioBtn addTarget:self action:@selector(playBtnTapped:) forControlEvents: UIControlEventTouchUpInside];
    cell.playAudioBtn.tag = indexPath.row;
    return cell;
}

@end

