//
//  AudioTableViewCell.h
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 1/20/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *audioUrlLbl;
@property (weak, nonatomic) IBOutlet UIButton *playAudioBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *downloadedPercentLbl;

-(void)constractCell;
@end
