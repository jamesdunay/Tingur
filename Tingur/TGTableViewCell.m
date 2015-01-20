//
//  TGTableViewCell.m
//  Tingur
//
//  Created by James Dunay on 1/17/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "TGTableViewCell.h"
#import "TGVoteScrollView.h"

#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface TGTableViewCell()

@property(nonatomic, strong)TGVoteScrollView* scrollView;

@property(nonatomic, strong)FLAnimatedImageView* contentImageView;

@property(nonatomic, strong)NSLayoutConstraint* testImageCenterY;

@property(nonatomic, strong)NSLayoutConstraint* imageViewHeightConstraint;
@property(nonatomic, strong)NSLayoutConstraint* imageViewWidthConstratint;


@property(nonatomic) CGFloat currentImageYOffset;

@property(nonatomic)BOOL hasSetInitialConstraints;

@end

@implementation TGTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
 
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        self.currentImageYOffset = 0;
        
        self.contentImageView = [[FLAnimatedImageView alloc] init];
        self.contentImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentImageView.backgroundColor = [UIColor purpleColor];
//        self.testImage.image = [UIImage imageNamed:@"test3.png"];
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.contentImageView];
        
        self.scrollView = [[TGVoteScrollView alloc] init];
        self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
//        self.scrollView.canCancelContentTouches = YES;
        self.scrollView.autoresizesSubviews = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.pagingEnabled = YES;
        [self.contentView addSubview:self.scrollView];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(userTappedCell)];
        [self.scrollView addGestureRecognizer:tap];
        
        [self updateConstraintsIfNeeded];
        
        __weak typeof(self) wSelf = self;
        [self.scrollView setOnEndDecelerating:^(NSInteger pageNumber){
            wSelf.onVote(pageNumber);
        }];
    }
    
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height - 10);
}


-(void)updateConstraints{
    if (!self.hasSetInitialConstraints) {
        [self.contentView addConstraints:[self defaultConstraints]];
        self.hasSetInitialConstraints = YES;
    }

    [super updateConstraints];
}

-(NSArray*)defaultConstraints{
    
    //remember you got 5px ontop and bottom
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_scrollView)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_scrollView]-5-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_scrollView)
                                      ]];
    
    if (!self.testImageCenterY) {
        [self setTestImageCenterY:[NSLayoutConstraint constraintWithItem:self.contentImageView
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.f
                                                                constant:0.f
                                   ]];
    }
    
    [constraints addObject:self.testImageCenterY];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentImageView
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.contentView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.f
                                                            constant:0.f
                               ]];
    
    self.imageViewHeightConstraint =[NSLayoutConstraint constraintWithItem:self.contentImageView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:0.f
                            ];
    
    [constraints addObject:self.imageViewHeightConstraint];
    
    self.imageViewWidthConstratint = [NSLayoutConstraint constraintWithItem:self.contentImageView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:0.f
                            ];
    
    [constraints addObject:self.imageViewWidthConstratint];
    
    
    
    
    return [constraints copy];
}




#pragma Mark Helpers ----

-(void)adjustYImageOffsetWithVerticalPercentage:(CGFloat)percentYLocation{
    self.currentImageYOffset = [self calculateImageYOffsetWithPercent:percentYLocation];
}

-(CGFloat)calculateImageYOffsetWithPercent:(CGFloat)percent{
//    adjust % to correct scrolling
    percent = -percent;
    
    CGFloat imageOffestAmount = percent * (self.contentImageView.frame.size.height/2);
    return imageOffestAmount;
}

-(void)adjustConstraintsForNewImageSize:(CGSize)imageSize{
    CGFloat imageViewHeight = (320.f/imageSize.width) * imageSize.height;
    
    self.imageViewHeightConstraint.constant = imageViewHeight;
    self.imageViewWidthConstratint.constant = 320.f;
    
    [self setNeedsUpdateConstraints];
}

#pragma Mark Setters/Getters ----

-(void)setCurrentImageYOffset:(CGFloat)currentImageYOffset{
    _currentImageYOffset = currentImageYOffset;
    self.testImageCenterY.constant = currentImageYOffset;
}

-(void)setItem:(TGItem *)item{
    _item = item;
    [self requestImage];
    [self setVoteDisplay:item.voteType];
}

-(NSURL*)imageURL{
    if (self.imageIsAnimatedAndGif) return self.item.galleryImage.url;
    else return [self.item.galleryImage URLWithSize:IMGMediumThumbnailSize];
}

-(BOOL)imageIsAnimatedAndGif{
    if (self.item.galleryImage.animated && [self.item.galleryImage.type isEqualToString:@"image/gif"]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma Mark Requests ----

-(void)requestImage{
    self.contentImageView.animatedImage = nil;
    self.contentImageView.image = nil;
    
    if (self.imageIsAnimatedAndGif) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            FLAnimatedImage *gifImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfURL:self.imageURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.contentImageView.animatedImage = gifImage;
                CGSize imageSize = CGSizeMake(self.item.galleryImage.width, self.item.galleryImage.height);
                [self adjustConstraintsForNewImageSize:imageSize];
            });
        });
    }else{
        [self.contentImageView sd_setImageWithURL:self.imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self adjustConstraintsForNewImageSize:image.size];
        }];
    }
}


#pragma Mark Actions ----

- (void)userTappedCell{
    NSLog(@"URL : %@", self.item.galleryImage.url);
    self.onCellTap();
}

-(void)setVoteDisplay:(TGVoteType)voteType{
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * voteType, 0) animated:NO];
}



@end
