//
//  TGImage.m
//  
//
//  Created by james.dunay on 1/16/15.
//
//

#import "TGItem.h"

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

-(NSURL*)getURL{
//    ^^ will return best sized URL
    return nil;
    
    
}
@end