//
//  MyUserDefaults.h
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 2/2/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlWithStatus.h"

@interface MyUserDefaults : NSObject

+ (void)saveUrls:(NSMutableArray<UrlWithStatus*>*)object;
+ (NSMutableArray<UrlWithStatus*>*)getSavedUrls;

@end
