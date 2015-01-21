//
//  TGVoteScrollView.m
//  Tingur
//
//  Created by James Dunay on 1/18/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "TGVoteScrollView.h"
#import "ColorWithHexString.h"

@interface TGVoteScrollView()

@property(nonatomic, strong)UIImageView* left;
@property(nonatomic, strong)UIImageView* right;

@property(nonatomic, strong)UILabel* upVoteLabel;
@property(nonatomic, strong)UILabel* downVoteLabel;

@property(nonatomic, strong)NSLayoutConstraint* upVoteXPosLayoutAttribute;
@property(nonatomic, strong)NSLayoutConstraint* downVoteXPosLayoutAttribute;

@end

@implementation TGVoteScrollView

-(id)init{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        
        self.left = [[UIImageView alloc] init];
        self.left.translatesAutoresizingMaskIntoConstraints = NO;
        self.left.backgroundColor = [UIColor blackColor];
        self.left.alpha = .9f;
//        self.left.image = [UIImage imageNamed:@"left_shadow.png"];
        [self addSubview:self.left];
        
        self.right = [[UIImageView alloc] init];
        self.right.translatesAutoresizingMaskIntoConstraints = NO;
        
//        1C3A24
        self.right.backgroundColor = [UIColor ];
//        self.right.image = [UIImage imageNamed:@"right_shadow.png"];
        self.right.alpha = .7f;
        [self addSubview:self.right];
        
        self.upVoteLabel = [[UILabel alloc] init];
        self.upVoteLabel.text = @"UP VOTED";
        self.upVoteLabel.font = [UIFont boldSystemFontOfSize:9];
        self.upVoteLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.upVoteLabel.textAlignment = NSTextAlignmentLeft;
        self.upVoteLabel.textColor = [UIColor greenColor];
        [self.right addSubview:self.upVoteLabel];
        
        self.downVoteLabel = [[UILabel alloc] init];
        self.downVoteLabel.text = @"DOWN VOTED";
        self.downVoteLabel.font = [UIFont boldSystemFontOfSize:9];
        self.downVoteLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.downVoteLabel.textAlignment = NSTextAlignmentRight;
        self.downVoteLabel.textColor = [UIColor redColor];
        [self.left addSubview:self.downVoteLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!self.constraints.count) {
        [self addConstraints:[self scrollViewConstraints]];
        [self.right addConstraints:[self rightConstraints]];
        [self.left addConstraints:[self leftConstraints]];
    }
}

-(NSArray*)scrollViewConstraints{
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    NSDictionary* metrics = @{@"width" : [NSNumber numberWithFloat:self.frame.size.width]};
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_left(==width)]-(==width)-[_right(==width)]|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_left, _right)
                                      ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.left
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.left
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:20.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.right
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.right
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:20.f
                            ]];
    
    return [constraints copy];
}

-(NSArray*)rightConstraints{
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.upVoteLabel
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.right
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.upVoteLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.right
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.upVoteLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.right
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    if (!self.upVoteXPosLayoutAttribute) {
        
    
    self.upVoteXPosLayoutAttribute = [NSLayoutConstraint constraintWithItem:self.upVoteLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.right
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f
                                                         constant:0.f
                            ];
    }
    
    [constraints addObject:self.upVoteXPosLayoutAttribute];
    
    return [constraints copy];
}


-(NSArray*)leftConstraints{
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.downVoteLabel
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.left
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.downVoteLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.left
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.downVoteLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.left
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    if (!self.downVoteXPosLayoutAttribute) {
    
        self.downVoteXPosLayoutAttribute = [NSLayoutConstraint constraintWithItem:self.downVoteLabel
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.left
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.f
                                                                       constant:0.f
                                          ];
    }
    
    [constraints addObject:self.downVoteXPosLayoutAttribute];
    
    return [constraints copy];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pagePostion = scrollView.contentOffset.x/320;
    CGFloat adjustment = ((pagePostion - 1) * 320)/1.4f;
//   ^^ 1.4f is pretty arbitrary, depends on font size
//   Future Improvemnt -- align text to is far side, (left -> align left), then position the outer edge to the desired position.

    if (pagePostion > 1.f) {
        self.upVoteXPosLayoutAttribute.constant = adjustment;
//        ^^ Creates velocity effect for text movments
    }
    if (pagePostion < 1.f) {
        self.downVoteXPosLayoutAttribute.constant = adjustment;
//        ^^ Creates velocity effect for text movments
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger pageNumber = (NSInteger)(scrollView.contentOffset.x / 320.f);
    self.onEndDecelerating(pageNumber);
}


@end
