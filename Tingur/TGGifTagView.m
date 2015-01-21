//
//  TGGifTagView.m
//  Tingur
//
//  Created by James Dunay on 1/20/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "TGGifTagView.h"

@interface TGGifTagView()
@property(nonatomic, strong)UILabel* gifLabel;
@property(nonatomic)BOOL hasConstraintsSet;
@end

@implementation TGGifTagView

-(id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];

        self.gifLabel = [[UILabel alloc] init];
        self.gifLabel.text = @"GIF";
        self.gifLabel.textColor = [UIColor whiteColor];
        self.gifLabel.font = [UIFont boldSystemFontOfSize:9.f];
        self.gifLabel.textAlignment = NSTextAlignmentCenter;
        self.gifLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.gifLabel];
    }
    return self;
}

-(void)updateConstraints{
    if (!self.hasConstraintsSet){
        [self addConstraints:[self defaultConstraints]];
        self.hasConstraintsSet = YES;
    }
    [super updateConstraints];
}

-(NSArray*)defaultConstraints{
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.gifLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.gifLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.gifLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.gifLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    return [constraints copy];
}

@end
