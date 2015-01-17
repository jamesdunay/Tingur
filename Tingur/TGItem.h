//
//  TGImage.h
//  
//
//  Created by james.dunay on 1/16/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IMGImage.h"

@interface TGItem : NSObject

@property(nonatomic, strong)IMGImage* imgImage;
@property(nonatomic, strong)UIImage* image;

-(id)initWithIMGImage:(IMGImage*)imgImage;
-(void)getURLImage;

@end