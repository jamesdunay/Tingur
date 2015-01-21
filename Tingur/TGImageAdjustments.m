//
//  TGImageAdjustments.m
//  Tingur
//
//  Created by James Dunay on 1/21/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "TGImageAdjustments.h"

static TGImageAdjustments *sTGImageAdjustments;

@implementation TGImageAdjustments

+ (TGImageAdjustments *)sharedInstance {
    return sTGImageAdjustments;
}

+ (void)initialize {
    sTGImageAdjustments = [TGImageAdjustments new];
}

-(void)getTransFormForFrame:(CGRect)rect offset:(CGPoint)offset onComplete:(void(^)(CATransform3D transform))complete{

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSInteger frameHeight = 568;
            NSInteger adjustmentRange = 240;
            NSInteger cellDistanceFromBottom = frameHeight - rect.origin.y;
            
            if (cellDistanceFromBottom < adjustmentRange) {
                // make sure it's in range
                
                NSInteger distanceFromBottomSwap = adjustmentRange - cellDistanceFromBottom;
                CGFloat rangeLocationPercent = ((float)distanceFromBottomSwap/(float)adjustmentRange);
                
//                Division on range % will cause an ease Out effect when scrolling down
//                Multiplying range % will cause an ease In effect when scrolling down
                
                CATransform3D transform = CATransform3DIdentity;
                transform.m34 = 1.0f / (-100.f / rangeLocationPercent);
            
                CGFloat angle = (-45 * M_PI / 180.0f) * (rangeLocationPercent * 2.5);
                CGFloat zLocation = -200 * rangeLocationPercent;
                CGFloat yLocation = -200 * (rangeLocationPercent / 20);
                
                transform = CATransform3DTranslate(transform, 0, yLocation, zLocation);
                transform = CATransform3DRotate(transform, angle, 1.f, 0, 0);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(transform);
                });
            }else{
//                CATransform3D transform = CATransform3DIdentity;
//                transform.m34 = 1.0f / -100.f;
//                transform = CATransform3DRotate(transform, 0.f, 0.f, 0.f, 0.f);
//                transform = CATransform3DTranslate(transform, 0.f, 0.f, 0.f);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    complete(transform);
//                });
            }
        });
}

@end
