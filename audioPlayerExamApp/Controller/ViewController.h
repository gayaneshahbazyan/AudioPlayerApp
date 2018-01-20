//
//  ViewController.h
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 1/20/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UITableView *audioTblView;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

