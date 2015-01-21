//
//  TGImage.h
//  
//
//  Created by james.dunay on 1/16/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IMGGalleryImage.h"

typedef NS_ENUM(NSInteger, TGVoteType) {
    TGUpVote = 0,
    TGNoVote,
    TGDownVote
};

@interface TGItem : NSObject

@property(nonatomic, strong)IMGGalleryImage* galleryImage;
@property(nonatomic) BOOL isOpened;
@property(nonatomic) BOOL hasBeenShownToUser;
@property(nonatomic) TGVoteType voteType;

-(id)initWithGalleryImage:(IMGGalleryImage*)galleryImage;
-(void)toggleOpened;

-(BOOL)imageIsAnimatedAndGif;
-(BOOL)fullSizedImageIsInCache;

-(NSURL*)thumbnailURL;

@end