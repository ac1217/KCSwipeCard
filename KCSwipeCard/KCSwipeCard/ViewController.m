//
//  ViewController.m
//  KCSwipeCard
//
//  Created by iMac on 2017/8/8.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ViewController.h"
#import "KCSwipeCard.h"

@interface ViewController ()<KCSwipeCardDataSource>
@property (nonatomic,strong) KCSwipeCard *swipeCard;
@end

@implementation ViewController

- (KCSwipeCard *)swipeCard
{
    if (!_swipeCard) {
        _swipeCard = [KCSwipeCard new];
        _swipeCard.dataSource = self;
    }
    return _swipeCard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.swipeCard];
    
    self.swipeCard.frame = CGRectMake(0, 0, 300, 300);
    
    self.swipeCard.center = self.view.center;
    
    [self.swipeCard reloadData];
}

#pragma mark -KCSwipeCardDataSource

- (NSInteger)numberOfItemsInSwipeCard:(KCSwipeCard *)swipeCard
{
    return 1000;
}

- (KCSwipeCardCell *)swipeCard:(KCSwipeCard *)swipeCard cellForItemAtIndex:(NSInteger)index
{
    
    NSString *ID = @"KCSwipeCardCell";
    
    KCSwipeCardCell *cell = [swipeCard dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[KCSwipeCardCell alloc] initWithReuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    
    return cell;
    
}



@end
