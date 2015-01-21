//
//  ViewController.m
//  Tingur
//
//  Created by james.dunay on 1/16/15.
//  Copyright (c) 2015 James.Dunay. All rights reserved.
//

#import "ViewController.h"
#import "TGImageService.h"

#import "TGTableViewCell.h"
#import "TGItem.h"

static CGFloat defaultCellHeight = 120.f;

@interface ViewController ()

@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)NSArray* items;
@property(nonatomic, strong)NSIndexPath* selectedIndex;
@property(nonatomic) CGPoint offsetAtTap;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.tableView registerClass:[TGTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    
    if ([[TGImageService sharedSingleton] shouldUpdateData:indexPath.row]) {
        [self getNewPage];
    }
    
    __block TGTableViewCell *cell = (TGTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TGItem* item = self.items[indexPath.row];
    cell.item = item;
    
    if (!item.hasBeenShownToUser) {
        cell.restingFrame = cell.frame;
        cell.frame = CGRectMake(0, cell.frame.origin.y + 150, cell.frame.size.width, cell.frame.size.height);
        cell.alpha = 0.f;
        [UIView animateWithDuration:.4f delay:0.1f
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             cell.frame = cell.restingFrame;
                             cell.alpha = 1.f;
                         } completion:nil];
        
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

        [tableView beginUpdates];
        [tableView endUpdates];
        [tableView setContentOffset:newOffset animated:YES];
//        itemHasAtleastOneCachedImage

        [item toggleOpened];
//       ^^ Toggle state change for cell's display
        
//      tableView.scrollEnabled = NO;
//       ^^ Future improvment -- Disable scrolling on tableview when cell is opened
//      This would allow the cell to contain a second scrollview, containing the image.
//      Allowing the user to browse the full image height (currently it's a bit off when browsing a large image
        
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
    [[TGImageService sharedSingleton] getNextPageOnComplete:^(NSArray *items) {
        self.items = items;
        [self.tableView reloadData];
    }];
}

#pragma Mark Delegates

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(TGTableViewCell* cell, NSUInteger idx, BOOL *stop) {
        CGPoint pointInView = CGPointMake(0, (cell.frame.origin.y - self.tableView.contentOffset.y));
        [cell adjustYImageOffsetWithVerticalPercentage:[self getVerticalPercentageWithPointInView:pointInView]];
    }];
}


#pragma Mark Helpers

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