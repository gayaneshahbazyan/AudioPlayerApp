//
//  UrlWithStatus.m
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 1/20/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import "UrlWithStatus.h"

@implementation UrlWithStatus

-(instancetype)initWithUrlPath:(NSString*)url {
    self = [super init];
    if (self) {
        self.urlPath = url;
        self.status = 0;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.urlPath forKey:@"urlPath"];
    [encoder encodeObject:self.savedPath forKey:@"savedPath"];
    [encoder encodeConditionalObject:self.loadingTaskOfUrl forKey:@"loadingTaskOfUrl"];
    [encoder encodeInteger:self.status forKey:@"status"];
    [encoder encodeInteger:self.downloadedPercent forKey:@"downloadedPercent"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.urlPath = [decoder decodeObjectForKey:@"urlPath"];
        self.savedPath = [decoder decodeObjectForKey:@"savedPath"];
        self.loadingTaskOfUrl = [decoder decodeObjectForKey:@"loadingTaskOfUrl"];
        self.status = [decoder decodeIntegerForKey:@"status"];
        self.downloadedPercent = [decoder decodeIntegerForKey:@"downloadedPercent"];
    }
    return self;
}

@end
