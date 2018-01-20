//
//  MyUserDefaults.m
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 2/2/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import "MyUserDefaults.h"

@implementation MyUserDefaults

+ (void)saveUrls:(NSMutableArray<UrlWithStatus*>*)object {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey: @"urls"];
    [defaults synchronize];
    
}

+ (NSMutableArray<UrlWithStatus*>*)getSavedUrls {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"urls"];
    NSMutableArray<UrlWithStatus*> *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
