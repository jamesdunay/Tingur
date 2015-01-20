//
//  ImageService.m
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "ImageService.h"

#import "IMGGalleryImage.h"
#import "IMGGalleryAlbum.h"
#import "RestEngine.h"

static ImageService *sImageService;

@interface ImageService()
@property (nonatomic)NSInteger downloadIndex;
@end

@implementation ImageService

+ (ImageService *)sharedSingleton {
    return sImageService;
}

+ (void)initialize {
    sImageService = [ImageService new];
    sImageService.items = [NSArray new];
    sImageService.currentPage = 0;
    sImageService.downloadIndex = 0;
}

-(void)getNextPageAtIndex:(NSInteger)index onComplete:(void(^)(NSArray* items))complete{
    
    [[RestEngine sharedSingleton] requestHotGalleryPage:index onComplete:^(NSArray *galleryItems) {

        NSMutableArray* currentImages = [self.items mutableCopy];
        
        [galleryItems enumerateObjectsUsingBlock:^(IMGGalleryImage* galleryItem, NSUInteger idx, BOOL *stop) {
            
            if (![galleryItem.class isEqual:[IMGGalleryAlbum class]]) {
                TGItem* item = [[TGItem alloc] initWithGalleryImage:galleryItem];
                [currentImages addObject:item];
            }
        }];
        
        self.items = [currentImages copy];
        self.currentPage++;
        
        complete(self.items);
    } onFailure:^(NSError *error) {
        
    }];
}

-(void)getBestImageForItem:(TGItem*)item OnComplete:(void(^)(NSObject* image))complete{
    
    UIImage* image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[item.galleryImage.url absoluteString]];
    if (image) {
//   ^^ check to see if large image is already cached
        complete(image);
        return;
    }
    
    if (item.isOpened) {
            if (item.imageIsAnimatedAndGif){
                [[RestEngine sharedSingleton] getAnimatedGifWithURL:item.galleryImage.url
                                                         onComplete:^(FLAnimatedImage *image) {
                                                             complete(image);
                                                         } onFailure:^{
                                                             
                                                         }];
            }else{
                [[RestEngine sharedSingleton] getStaticImageWithURL:item.galleryImage.url
                                                         onComplete:^(UIImage *image) {
                                                             complete(image);
                                                           [[SDImageCache sharedImageCache] removeImageForKey:[item.mediumImageURL absoluteString] fromDisk:YES];
//                                                            ^^ Remove medium image from cache once large has been loaded
                                                         } onFailure:^{
                                                             
                                                         }];
            }
        return;
    }else{
        [[RestEngine sharedSingleton] getStaticImageWithURL:item.mediumImageURL
                                                 onComplete:^(UIImage *image) {
                                                     complete(image);
                                                 } onFailure:^{
            
                                                 }];
        return;
    }
}


@end