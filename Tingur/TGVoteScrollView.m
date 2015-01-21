//
//  TGVoteScrollView.m
//  Tingur
//
//  Created by James Dunay on 1/18/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "TGVoteScrollView.h"

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
        self.left.backgroundColor = [UIColor colorWithRed:51.f/255.f green:12.f/255.f blue:20.f/255.f alpha:1.f];
        self.left.alpha = .85f;
        [self addSubview:self.left];
        
        self.right = [[UIImageView alloc] init];
        self.right.translatesAutoresizingMaskIntoConstraints = NO;
        self.right.backgroundColor = [UIColor colorWithRed:33.f/255.f green:211.f/255.f blue:17.f/255.f alpha:1.f];
        self.right.alpha = .85f;
        [self addSubview:self.right];
        
        self.upVoteLabel = [[UILabel alloc] init];
        self.upVoteLabel.text = @"UP VOTED";
        self.upVoteLabel.font = [UIFont boldSystemFontOfSize:9];
        self.upVoteLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.upVoteLabel.textAlignment = NSTextAlignmentLeft;
        self.upVoteLabel.textColor = [UIColor colorWithRed:200.f/255.f green:211.f/255.f blue:200.f/255.f alpha:1.f];
        [self.right addSubview:self.upVoteLabel];
        
        self.downVoteLabel = [[UILabel alloc] init];
        self.downVoteLabel.text = @"DOWN VOTED";
        self.downVoteLabel.font = [UIFont boldSystemFontOfSize:9];
        self.downVoteLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.downVoteLabel.textAlignment = NSTextAlignmentRight;
        self.downVoteLabel.textColor = [UIColor redColor];
        [self.left addSubview:self.downVoteLabel];
    
//       ^^ Future Improvment -- Could be cool to see some blur under the bars for both left and right views
        
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
                                                         constant:35.f
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
                                                         constant:35.f
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
    
//    Future Improvemnt -- align text to is far side, (left -> align left), then position the outer edge to the desired position.
    
    if (pagePostion > 1.f) {
        self.upVoteXPosLayoutAttribute.constant = adjustment;
//       ^^ Creates velocity effect for sliding text
    }
    
    if (pagePostion < 1.f) {
        self.downVoteXPosLayoutAttribute.constant = adjustment;
//       ^^ Creates velocity effect for sliding text
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger pageNumber = (NSInteger)(scrollView.contentOffset.x / 320.f);
    self.onEndDecelerating(pageNumber);
}


@end
