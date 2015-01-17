//
//  RestEngine.h
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMGSession.h"

@interface RestEngine : NSObject <IMGSessionDelegate>

+ (RestEngine *)sharedSingleton;

-(void)requestHotGalleryPage:(NSInteger)pageIndex onComplete:(void(^)(NSArray* galleryItems))completed onFailure:(void(^)(NSError* error))failed;

@end
