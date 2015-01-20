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
        self.contentImageView.backgroundColor = [UIColor clearColor];
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
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|"
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
    NSLog(@"Size : %@", NSStringFromCGSize(imageSize));
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


#pragma Mark Requests ----

-(void)requestImage{
    [[ImageService sharedSingleton] getBestImageForItem:self.item OnComplete:^(NSObject *image) {
        if(image){
            if ([image isKindOfClass:[UIImage class]]) {
                UIImage* staticImage = (UIImage*)image;
                self.contentImageView.image = staticImage;
                [self adjustConstraintsForNewImageSize:staticImage.size];
            }else{
                FLAnimatedImage* animatedImage = (FLAnimatedImage*)image;
                self.contentImageView.animatedImage = animatedImage;
                [self adjustConstraintsForNewImageSize:animatedImage.size];
            }
        }
    }];
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
