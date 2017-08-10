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

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont boldSystemFontOfSize:30];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super init]) {
        
        _reuseIdentifier = reuseIdentifier;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        _panGestureRecognizer = pan;
        
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
}


- (void)pan:(UIPanGestureRecognizer *)pan
{
    !self.panBlock ? : self.panBlock(self, pan);
}




@end
