//
//  TGVoteScrollView.h
//  Tingur
//
//  Created by James Dunay on 1/18/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TGVoteScrollView : UIScrollView <UIScrollViewDelegate>

typedef void (^OnEndDecelerating)(NSInteger pageNumber);

@property(nonatomic, copy)OnEndDecelerating onEndDecelerating;

@end
