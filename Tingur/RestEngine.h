//
//  RestEngine.h
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "IMGSession.h"
#import "FLAnimatedImage.h"

@interface RestEngine : NSObject <IMGSessionDelegate>

+ (RestEngine *)sharedSingleton;

-(void)requestHotGalleryPage:(NSInteger)pageIndex onComplete:(void(^)(NSArray* galleryItems))completed onFailure:(void(^)(NSError* error))failed;
-(void)getStaticImageWithURL:(NSURL*)url onComplete:(void(^)(UIImage* image))complete onFailure:(void(^)(void))failure;
-(void)getAnimatedGifWithURL:(NSURL*)url onComplete:(void(^)(FLAnimatedImage* image))complete onFailure:(void(^)(void))failure;

@end
