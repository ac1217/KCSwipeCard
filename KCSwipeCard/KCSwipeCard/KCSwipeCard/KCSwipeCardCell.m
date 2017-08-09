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
}

@end

@implementation KCSwipeCardCell


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super init]) {
        
        _reuseIdentifier = reuseIdentifier;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}


- (void)pan:(UIPanGestureRecognizer *)pan
{
    !self.panBlock ? : self.panBlock(self, pan);
}




@end
