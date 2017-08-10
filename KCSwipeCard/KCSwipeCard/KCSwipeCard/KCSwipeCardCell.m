//
//  KCSwipeCardCell.m
//  KCSwipeCard
//
//  Created by iMac on 2017/8/8.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "KCSwipeCardCell.h"

@interface KCSwipeCardCell (){
    NSString *_reuseIdentifier;
    UIPanGestureRecognizer *_panGestureRecognizer;
}

@end

@implementation KCSwipeCardCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super init]) {
        
        _reuseIdentifier = reuseIdentifier;
        [self setup];
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    _panGestureRecognizer = pan;
    
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    !self.panBlock ? : self.panBlock(self, pan);
}




@end
