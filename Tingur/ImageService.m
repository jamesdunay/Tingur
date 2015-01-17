//
//  ImageService.m
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "ImageService.h"
#import "TGItem.h"
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

-(void)getNextPageAtIndex:(NSInteger)index{
    
    [[RestEngine sharedSingleton] requestHotGalleryPage:index onComplete:^(NSArray *galleryItems) {

        NSMutableArray* currentImages = [self.items mutableCopy];
        
        [galleryItems enumerateObjectsUsingBlock:^(IMGImage* galleryItem, NSUInteger idx, BOOL *stop) {
            TGItem* item = [[TGItem alloc] initWithIMGImage:galleryItem];
            [currentImages addObject:item];
        }];
        
        self.items = [currentImages copy];
        self.currentPage++;
        
    } onFailure:^(NSError *error) {
        
    }];
}

-(void)getNextBatchOfImages:(NSArray*)items{
    [items enumerateObjectsUsingBlock:^(TGItem* item, NSUInteger idx, BOOL *stop) {
        [item getURLImage];
    }];
}

-(void)getImageWithTGItems:(NSArray *)images{
    //Number of images to grab
    
    
    
}


@end