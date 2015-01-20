//
//  ImageService.h
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGItem.h"

@interface ImageService : NSObject

+ (ImageService *)sharedSingleton;

@property(nonatomic) NSInteger currentPage;
@property(nonatomic, strong)NSArray* items;

-(void)getNextPageAtIndex:(NSInteger)index onComplete:(void(^)(NSArray* items))complete;
-(void)getBestImageForItem:(TGItem*)item OnComplete:(void(^)(NSObject* image))complete;

@end
