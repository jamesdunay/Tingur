//
//  TGImage.m
//  
//
//  Created by james.dunay on 1/16/15.
//
//

#import "TGItem.h"

@implementation TGItem

-(id)initWithIMGImage:(IMGImage*)imgImage{
 
    self = [super init];
    if (self) {
        self.imgImage = imgImage;
    }
    return self;
}

//prbably cache with something like SDWebImage
//maybe load items into collectionview data source, 

/*
-(void)getURLImage{
 
    
    
    
    
    
//    NSURLConnection and NSURLRequest.
    
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL:self.imgImage.url];

        if ( data == nil ) return;

        dispatch_async(dispatch_get_main_queue(), ^{
//            Push back to main thread
            
//          WARNING: is the cell still using the same data by this point??
//          cell.image = [UIImage imageWithData: data];
        });
        
    });
}
*/







/*
- (void)loadImage:(NSURL *)imageURL
{
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(requestRemoteImage:)
                                        object:imageURL];
    [queue addOperation:operation];
}

- (void)requestRemoteImage:(NSURL *)imageURL
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    [self performSelectorOnMainThread:@selector(placeImageInUI:) withObject:image waitUntilDone:YES];
}

- (void)placeImageInUI:(UIImage *)image
{
    [_image setImage:image];
}
*/











@end