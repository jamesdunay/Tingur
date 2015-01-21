//
//  TGImageAdjustments.h
//  Tingur
//
//  Created by James Dunay on 1/21/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TGImageAdjustments : NSObject

+ (TGImageAdjustments *)sharedInstance;

-(void)getTransFormForFrame:(CGRect)rect offset:(CGPoint)offset onComplete:(void(^)(CATransform3D transform))complete;

@end
