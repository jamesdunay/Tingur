//
//  ViewController.m
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "ViewController.h"
#import "ImageService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [[ImageService sharedSingleton] getNextPageAtIndex:0];
}


@end
