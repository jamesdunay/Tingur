//
//  ViewController.m
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "ViewController.h"
#import "TGImageService.h"

#import "TGImageAdjustments.h"

#import "TGTableViewCell.h"
#import "TGItem.h"

#import <QuartzCore/QuartzCore.h>

static CGFloat defaultCellHeight = 120.f;

@interface ViewController ()

@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)NSArray* items;
@property(nonatomic, strong)NSIndexPath* selectedIndex;
@property(nonatomic) CGPoint offsetAtTap;
@property(nonatomic)BOOL hasCellOpen;

@property(nonatomic) BOOL hasSetDefaultTransform;
@property(nonatomic) CATransform3D defaultTransform;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 00)];
    [self.tableView registerClass:[TGTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.clipsToBounds = NO;
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self getNewPage];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([indexPath isEqual:self.selectedIndex]) {
        return self.view.frame.size.height;
    }else{
        return defaultCellHeight;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[TGImageService sharedInstance] shouldUpdateData:indexPath.row]) {
        [self getNewPage];
    }
    
    __block TGTableViewCell *cell = (TGTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (!self.hasSetDefaultTransform) {
        self.defaultTransform = cell.layer.transform;
        self.hasSetDefaultTransform = YES;
    }else if(!self.hasCellOpen){
        cell.layer.transform = self.defaultTransform;
    }

    
    TGItem* item = self.items[indexPath.row];
    cell.item = item;
    
    if (!item.hasBeenShownToUser) {
//        cell.frame = CGRectMake(0, cell.frame.origin.y + 150, cell.frame.size.width, cell.frame.size.height);
//        cell.alpha = 0.f;
//        [UIView animateWithDuration:.4f delay:0.1f
//                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
//                         animations:^{
//                             cell.frame = cell.restingFrame;
//                             cell.alpha = 1.f;
//                       } completion:nil];
//        
        item.hasBeenShownToUser = YES;
    }
    
    [cell setOnCellTap:^{
        
        TGItem* item = self.items[indexPath.row];
        CGPoint newOffset;
        UITableViewScrollPosition tableViewScrollPosition;
        
        if (item.isOpened) {
//      ^^ Cell returning to inital position
            self.selectedIndex = nil;
            newOffset = self.offsetAtTap;
            tableView.scrollEnabled = YES;
        }else{
//      ^^ Cell will expand to full view
            self.selectedIndex = indexPath;
            self.offsetAtTap = tableView.contentOffset;
            newOffset = CGPointMake(0, indexPath.row * defaultCellHeight);
            tableViewScrollPosition = UITableViewScrollPositionTop;
        }
        
//      >> Future improvment -- Disable scrolling on tableview when cell is opened
//      This would allow the cell to contain a second scrollview, containing the image.
//      Allowing the user to browse the full image height (currently it's a bit off when browsing a large image
        
        [item toggleOpened];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            self.hasCellOpen = item.isOpened;
            tableView.scrollEnabled = !item.isOpened;
        }];
        [tableView beginUpdates];
        [tableView endUpdates];
        [CATransaction commit];
        
        [tableView setContentOffset:newOffset animated:YES];
        [self returnAllCellsToDefaultLayerTransform];
    }];
    
    __weak typeof(self) wSelf = self;
    
    [cell setOnVote:^(TGVoteType voteType){
        TGItem* item = self.items[indexPath.row];
        if (item.voteType != voteType) {
            item.voteType = voteType;
            [wSelf advanceToNextCell];
        }
    }];
    
    return cell;
}

-(void)getNewPage{
    [[TGImageService sharedInstance] getNextPageOnComplete:^(NSArray *items) {
        self.items = items;
        [self.tableView reloadData];
    }];
}

#pragma Mark Delegates

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(TGTableViewCell* cell, NSUInteger idx, BOOL *stop) {
        CGPoint pointInView = CGPointMake(0, (cell.frame.origin.y - self.tableView.contentOffset.y));
        [cell adjustYImageOffsetWithVerticalPercentage:[self getVerticalPercentageWithPointInView:pointInView]];
        [self getTransformForCell:cell onComplete:^(CATransform3D transform) {
            cell.layer.transform = transform;
        }];
    }];
}

#pragma Mark Helpers

-(void)getTransformForCell:(TGTableViewCell*)cell onComplete:(void(^)(CATransform3D transform))complete{
    if (!self.hasCellOpen) {
        CGRect frameInTableView = [self.tableView convertRect:cell.frame toView:[self.tableView superview]];
        cell.layer.anchorPoint = CGPointMake(.5, .5);
        [[TGImageAdjustments sharedInstance] getTransFormForFrame:frameInTableView offset:self.tableView.contentOffset onComplete:^(CATransform3D transform) {
                complete(transform);
        }];
    }
}

-(void)returnAllCellsToCorrectLayerTransform{
    for (TGTableViewCell* cell in self.tableView.visibleCells){
        [self getTransformForCell:cell onComplete:^(CATransform3D transform) {
            cell.layer.transform = transform;
        }];
    }
}

-(void)returnAllCellsToDefaultLayerTransform{
    for (TGTableViewCell* cell in self.tableView.visibleCells){
        cell.layer.transform = self.defaultTransform;
    }
}

-(CGFloat)getVerticalPercentageWithPointInView:(CGPoint)pointInView{
    return pointInView.y/self.view.frame.size.height;
}

-(void)advanceToNextCell{
    
    TGItem* currentItem = self.items[self.selectedIndex.row];
    if (currentItem.isOpened) {
        [currentItem toggleOpened];
        self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + 2);
//      ^^ hack to ensure next cell loads
        
        NSIndexPath* nextIndexPath = [NSIndexPath indexPathForItem:self.selectedIndex.row + 1 inSection:self.selectedIndex.section];
        TGTableViewCell *cell = (TGTableViewCell*)[self.tableView cellForRowAtIndexPath:nextIndexPath];
        [cell userTappedCell];
    }
}

@end