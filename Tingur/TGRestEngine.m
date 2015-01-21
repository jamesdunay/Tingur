//
//  RestEngine.m
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#define imgurClientID @"aaf51e9b0424644"

#import "IMGGalleryRequest.h"
#import "TGRestEngine.h"

static TGRestEngine *sRestEngine;

@implementation TGRestEngine

+ (TGRestEngine *)sharedInstance {
    return sRestEngine;
}

+ (void)initialize {
    sRestEngine = [TGRestEngine new];
    [IMGSession anonymousSessionWithClientID:imgurClientID withDelegate:sRestEngine];
}

-(void)requestHotGalleryPage:(NSInteger)pageIndex onComplete:(void(^)(NSArray* galleryItems))completed onFailure:(void(^)(NSError* error))failed{
    [IMGGalleryRequest hotGalleryPage:pageIndex success:^(NSArray *galleryItems) {
        completed(galleryItems);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

-(void)getStaticImageWithURL:(NSURL*)url onComplete:(void(^)(UIImage* image))complete onFailure:(void(^)(void))failure{
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize){
                                                       
                                                   }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                       if(image){
//                                                      ^^ Hand-check image, occasionally a missing image link will be returned.
//                                                      ^^ Could remove image from stack, leave it alone for now.
                                                           complete(image);
                                                       }else{
                                                           failure();
                                                       }
                                                   }];
}

-(void)getAnimatedGifWithURL:(NSURL*)url onComplete:(void(^)(FLAnimatedImage* image))complete onFailure:(void(^)(void))failure{
//  Test gif url http://i.giphy.com/7MZ0v9KynmiSA.gif
    
    FLAnimatedImage *gifImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
//   ^^ Doesnt handle some Imgur gif's, something seems to be up with the decoding (Probably on FL's end).
//   ^^ On occastion the URL provided will only point to a static image or an image that is of type public.jpeg, which causes FLAnimatedImage to spit out some VERBOSE errors..
    
    if (gifImage) {
        complete(gifImage);
    }
}

@end