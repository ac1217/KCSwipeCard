//
//  KCSwipeCardCell.h
//  KCSwipeCard
//
//  Created by iMac on 2017/8/8.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCSwipeCardCell : UIView

@property (nonatomic,strong,readonly) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic,copy) void(^panBlock)(KCSwipeCardCell *cell, UIPanGestureRecognizer *pan);

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,strong) UILabel *label;
@end
