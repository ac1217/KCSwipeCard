//
//  ViewController.m
//  KCSwipeCard
//
//  Created by iMac on 2017/8/8.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ViewController.h"
#import "KCSwipeCard.h"

@interface ViewController ()<KCSwipeCardDataSource, KCSwipeCardDelegate>
@property (nonatomic,strong) KCSwipeCard *swipeCard;
@end

@implementation ViewController

- (KCSwipeCard *)swipeCard
{
    if (!_swipeCard) {
        _swipeCard = [KCSwipeCard new];
        [_swipeCard registerClass:[KCSwipeCardCell class] forCellReuseIdentifier:KCSwipeCardCellReuseID];
        _swipeCard.dataSource = self;
        _swipeCard.delegate = self;
    }
    return _swipeCard;
}
static NSString * KCSwipeCardCellReuseID = @"KCSwipeCardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITableView *tb;
//    [tb registerClass:nil forCellReuseIdentifier:nil];
//    tb.visibleCells
//    [tb indexPathForCell:<#(nonnull UITableViewCell *)#>]
//    tb cellForRowAtIndexPath:<#(nonnull NSIndexPath *)#>
    
    [self.view insertSubview:self.swipeCard atIndex:0];
    
    self.swipeCard.frame = self.view.bounds;
    
//    self.swipeCard.offsetForItem = CGPointMake(5, 5);
    
    [self.swipeCard reloadData];
    
}

#pragma mark -KCSwipeCardDataSource

- (NSInteger)numberOfItemsInSwipeCard:(KCSwipeCard *)swipeCard
{
    return 5;
}

- (KCSwipeCardCell *)swipeCard:(KCSwipeCard *)swipeCard cellForItemAtIndex:(NSInteger)index
{
    
    KCSwipeCardCell *cell = [swipeCard dequeueReusableCellWithIdentifier:KCSwipeCardCellReuseID];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    
//    cell.layer.cornerRadius = 10;
//    cell.clipsToBounds = YES;
    
    return cell;
    
}

- (KCSwipeCardCell *)swipeCard:(KCSwipeCard *)swipeCard cellForPreviousItemAtIndex:(NSInteger)index
{
    KCSwipeCardCell *cell = [swipeCard dequeueReusableCellWithIdentifier:KCSwipeCardCellReuseID];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    
    cell.layer.cornerRadius = 10;
    cell.clipsToBounds = YES;
    
    return cell;
}

#pragma mark -KCSwipeCardDelegate

- (void)swipeCard:(KCSwipeCard *)swipeCard didEndSwipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction
{
//    NSLog(@"didEndSwipeItemAtIndex---&=%zd", index);
}

- (IBAction)right {
    [self.swipeCard swipeItemToDirection:KCSwipeCardSwipeDirectionRight];
}

- (IBAction)left {
    [self.swipeCard swipeItemToDirection:KCSwipeCardSwipeDirectionLeft];
}

- (IBAction)reload {
    [self.swipeCard reloadData];
}
- (IBAction)previous {
    [self.swipeCard swipeItemFromDirection:KCSwipeCardSwipeDirectionLeft];
}

@end
