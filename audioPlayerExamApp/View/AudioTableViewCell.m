//
//  AudioTableViewCell.m
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 1/20/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import "AudioTableViewCell.h"

@implementation AudioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) constractCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.playAudioBtn.userInteractionEnabled = false;
    [self.loadingActivityIndicator startAnimating];
    [self.downloadedPercentLbl setText:@"0%"];
}

@end
