//
//  ImageService.h
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageService : NSObject

+ (ImageService *)sharedSingleton;

@property(nonatomic) NSInteger currentPage;
@property(nonatomic, strong)NSArray* items;

//Grabs full page of IMGImage objects
//Make TGImages
-(void)getNextPageAtIndex:(NSInteger)index onComplete:(void(^)(NSArray* items))complete;



@end
