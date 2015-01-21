//
//  TGImage.m
//  
//
//  Created by james.dunay on 1/16/15.
//
//

#import "TGItem.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TGItem

-(id)initWithGalleryImage:(IMGGalleryImage*)galleryImage{
 
    self = [super init];
    if (self) {
        self.galleryImage = galleryImage;
        self.voteType = TGNoVote;
        NSLog(@"item Size %ld", galleryImage.size);
    }
    return self;
}

-(void)toggleOpened{
    self.isOpened = self.isOpened ? NO : YES;
}

-(NSURL*)thumbnailURL{    
    return [self.galleryImage URLWithSize:IMGLargeThumbnailSize];
}

-(BOOL)imageIsAnimatedAndGif{
    if (self.galleryImage.animated && [self.galleryImage.type isEqualToString:@"image/gif"]) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)fullSizedImageIsInCache{
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.galleryImage.url absoluteString]] ? YES : NO;
}

@end