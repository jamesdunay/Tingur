//
//  TGTableViewCell.h
//  Tingur
//
//  Created by James Dunay on 1/17/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGItem.h"

typedef void (^OnCellTap)(void);
typedef void (^OnVote)(TGVoteType voteType);

@interface TGTableViewCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, copy) OnCellTap onCellTap;
@property (nonatomic, copy) OnVote onVote;
@property (nonatomic, copy) TGItem* item;

-(void)setVoteDisplay:(TGVoteType)voteType;
-(void)adjustYImageOffsetWithVerticalPercentage:(CGFloat)percent;
-(void)userTappedCell;



@end
