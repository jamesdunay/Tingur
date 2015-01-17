//
//  RestEngine.m
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#define imgurClientID @"aaf51e9b0424644"

#import "IMGGalleryRequest.h"
#import "RestEngine.h"


//E-TAGS


//Gallery service
//    holds all images


static RestEngine *sRestEngine;

@implementation RestEngine

+ (RestEngine *)sharedSingleton {
    return sRestEngine;
}

+ (void)initialize {
    sRestEngine = [RestEngine new];
    [IMGSession anonymousSessionWithClientID:imgurClientID withDelegate:sRestEngine];
}


-(void)requestHotGalleryPage:(NSInteger)pageIndex onComplete:(void(^)(NSArray* galleryItems))completed onFailure:(void(^)(NSError* error))failed{
    [IMGGalleryRequest hotGalleryPage:pageIndex success:^(NSArray *galleryItems) {
        completed(galleryItems);
    } failure:^(NSError *error) {
        failed(error);
    }];
}


@end