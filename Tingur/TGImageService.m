//
//  ImageService.m
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "TGImageService.h"
#import "IMGGalleryImage.h"
#import "IMGGalleryAlbum.h"
#import "TGRestEngine.h"

static TGImageService *sImageService;

@interface TGImageService()
@property (nonatomic)NSInteger downloadIndex;
@end

@implementation TGImageService

+ (TGImageService *)sharedInstance {
    return sImageService;
}

+ (void)initialize {
    sImageService = [TGImageService new];
    sImageService.items = [NSArray new];
    sImageService.currentPage = 0;
    sImageService.downloadIndex = 0;
}

-(BOOL)shouldUpdateData:(NSInteger)activeIndex{
    return self.items.count - activeIndex < 10;
}

-(BOOL)itemHasAtleastOneCachedImage:(TGItem*)item{
    if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[item.galleryImage.url absoluteString]]) {
        return YES;
    }
    if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[item.thumbnailURL absoluteString]]) {
        return YES;
    }
    
    return NO;
}

-(void)getNextPageOnComplete:(void(^)(NSArray* items))complete{
    
    [[TGRestEngine sharedInstance] requestHotGalleryPage:self.currentPage onComplete:^(NSArray *galleryItems) {
        NSMutableArray* currentImages = [self.items mutableCopy];
        [galleryItems enumerateObjectsUsingBlock:^(IMGGalleryImage* galleryItem, NSUInteger idx, BOOL *stop) {
            if (![galleryItem.class isEqual:[IMGGalleryAlbum class]]) {
//           ^^ Not handling GalleryAlbums at the moment
//           Future improvment -- Add image array to TGItem
//           Use that array pump images into cell's scrollview
                
                TGItem* item = [[TGItem alloc] initWithGalleryImage:galleryItem];
                [currentImages addObject:item];
            }
        }];
        
        if(galleryItems.count){
            self.items = [currentImages copy];
            self.currentPage++;
            complete(self.items);
        }
    } onFailure:^(NSError *error) {
//     Future Improvement -- Should alert the user that page load failed.
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
                [[TGRestEngine sharedInstance] getAnimatedGifWithURL:item.galleryImage.url
                                                         onComplete:^(FLAnimatedImage *image) {
                                                             complete(image);
                                                         } onFailure:^{
//                                                          Future Improvement -- Should handle failure, probably best with some sort of image for the user, as is done on Imgur's site
                                                         }];
            }else{
                [[TGRestEngine sharedInstance] getStaticImageWithURL:item.galleryImage.url
                                                         onComplete:^(UIImage *image) {
                                                             complete(image);
                                                           [[SDImageCache sharedImageCache] removeImageForKey:[item.thumbnailURL absoluteString] fromDisk:YES];
//                                                            ^^ Remove medium image from cache once large has been loaded
                                                         } onFailure:^{
//                                                          Future Improvement -- Should handle failure, probably best with some sort of image for the user, as is done on Imgur's site
                                                         }];
            }
        return;
    }else{
        [[TGRestEngine sharedInstance] getStaticImageWithURL:item.thumbnailURL
                                                 onComplete:^(UIImage *image) {
                                                     complete(image);
                                                 } onFailure:^{
//                                                  Future Improvement -- Should handle failure, probably best with some sort of image for the user, as is done on Imgur's site
                                                 }];
        return;
    }
}


@end