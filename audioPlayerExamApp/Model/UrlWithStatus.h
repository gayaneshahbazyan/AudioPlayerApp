//
//  UrlWithStatus.h
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 1/20/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlWithStatus : NSObject
// status = 0 loading
// status = 1 loaded
// in perfect code I will keep it as a struct.
@property NSInteger status;
@property NSString* urlPath;
@property NSURL* savedPath;
@property NSInteger downloadedPercent;
@property NSURLSessionDownloadTask *loadingTaskOfUrl;
@property Boolean shouldResume;
@property Boolean didResumed;

-(instancetype)initWithUrlPath:(NSString*)url;
@end
