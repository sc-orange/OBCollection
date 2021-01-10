//
//  OBNSURLSessionCollectManager.m
//  ForORTest
//
//  Created by orange on 2020/11/28.
//

#import "OBNSURLSessionCollectManager.h"

static OBNSURLSessionCollectManager *manager = nil;

@implementation OBNSURLSessionCollectManager

+ (OBNSURLSessionCollectManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OBNSURLSessionCollectManager alloc] init];
    });
    return manager;
}

@end
