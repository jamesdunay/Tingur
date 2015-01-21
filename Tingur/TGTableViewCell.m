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
#import "ImageService.h"
#import "TGGifTagView.h"

@interface TGTableViewCell()

@property(nonatomic, strong)TGVoteScrollView* scrollView;
@property(nonatomic, strong)FLAnimatedImageView* contentImageView;
@property(nonatomic, strong)TGGifTagView* gifTagView;

@property(nonatomic, strong)NSLayoutConstraint* imageViewCenterY;
@property(nonatomic, strong)NSLayoutConstraint* imageViewHeightConstraint;
@property(nonatomic, strong)NSLayoutConstraint* imageViewWidthConstratint;

@property(nonatomic, strong)FLAnimatedImageView* loader;
@property(nonatomic)CGAffineTransform baseLoaderTransform;

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
        self.contentImageView.backgroundColor = [UIColor clearColor];
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
        
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loader3" ofType: @"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:filePath];
        
        FLAnimatedImage* gifImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
        
        self.loader = [[FLAnimatedImageView alloc] init];
        self.loader.animatedImage = gifImage;
        self.loader.contentMode = UIViewContentModeScaleAspectFit;
        self.loader.translatesAutoresizingMaskIntoConstraints = NO;
        self.baseLoaderTransform = self.loader.transform;
        [self.contentView addSubview:self.loader];
        
        self.gifTagView = [[TGGifTagView alloc] init];
        self.gifTagView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.gifTagView];
        
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
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_scrollView)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_loader]-(>=0)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_loader)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_loader]-(>=0)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_loader)
                                      ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.loader
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.contentView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.loader
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:50.f
                            ]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.loader
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:50.f
                            ]];
    
    if (!self.imageViewCenterY) {
        [self setImageViewCenterY:[NSLayoutConstraint constraintWithItem:self.contentImageView
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.f
                                                                constant:0.f
                                   ]];
    }
    [constraints addObject:self.imageViewCenterY];
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
    
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.gifTagView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.contentView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.gifTagView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.contentView
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.gifTagView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:20.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.gifTagView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:50.f
                                   ]];
    
    return [constraints copy];
}


#pragma Mark Helpers ----

-(void)adjustYImageOffsetWithVerticalPercentage:(CGFloat)percentYLocation{
    self.currentImageYOffset = [self calculateImageYOffsetWithPercent:percentYLocation];
}

-(CGFloat)calculateImageYOffsetWithPercent:(CGFloat)percent{
//    adjust % to correct scrolling direction
    percent = -percent;
    
    CGFloat imageOffestAmount = percent * (self.contentImageView.frame.size.height/3);
    return imageOffestAmount;
}

-(void)adjustConstraintsForNewImageSize:(CGSize)imageSize{
    NSLog(@"Size : %@", NSStringFromCGSize(imageSize));
    CGFloat imageViewHeight = (320.f/imageSize.width) * imageSize.height;
    
    self.imageViewHeightConstraint.constant = imageViewHeight;
    self.imageViewWidthConstratint.constant = 320.f;
    
    [self setNeedsUpdateConstraints];
}

-(void)startLoader{
    [self.loader startAnimating];
    [UIView animateWithDuration:.2f
                     animations:^{
                         self.loader.alpha = 1.f;
                         self.loader.transform = self.baseLoaderTransform;
                     } completion:nil];
}

-(void)pauseLoader{
    [self.loader stopAnimating];
    [UIView animateWithDuration:.2f
                     animations:^{
                         self.loader.alpha = 0.f;
                         self.loader.transform = CGAffineTransformScale(self.loader.transform, .4, .4);
                     } completion:nil];
}

#pragma Mark Setters/Getters ----

-(void)setCurrentImageYOffset:(CGFloat)currentImageYOffset{
    _currentImageYOffset = currentImageYOffset;
    self.imageViewCenterY.constant = currentImageYOffset;
}

-(void)setItem:(TGItem *)item{
    _item = item;
    [self requestImage];
    [self setVoteDisplay:item.voteType];
    self.gifTagView.hidden = !self.item.galleryImage.animated;
}


#pragma Mark Requests ----

-(void)requestImage{
    
    [self startLoader];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[ImageService sharedSingleton] getBestImageForItem:self.item OnComplete:^(NSObject *image) {
            if(image){
                if ([image isKindOfClass:[UIImage class]]) {
                    UIImage* staticImage = (UIImage*)image;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.contentImageView.image = staticImage;
                        [self adjustConstraintsForNewImageSize:staticImage.size];
                        [self pauseLoader];
                    });
                }else{
                    FLAnimatedImage* animatedImage = (FLAnimatedImage*)image;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.contentImageView.animatedImage = animatedImage;
                        [self adjustConstraintsForNewImageSize:animatedImage.size];
                        [self pauseLoader];
                    });
                }
            }
        }];
    });
}


#pragma Mark Actions ----

- (void)userTappedCell{
    NSLog(@"URL : %@", self.item.galleryImage.url);
    self.onCellTap();
    if(!self.item.fullSizedImageIsInCache) [self requestImage];
    [self setNeedsUpdateConstraints];
}

-(void)setVoteDisplay:(TGVoteType)voteType{
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * voteType, 0) animated:NO];
}



@end
