//
//  KCSwipeCard.m
//  KCSwipeCard
//
//  Created by iMac on 2017/8/8.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "KCSwipeCard.h"

@interface KCSwipeCard (){
    CGPoint _swipeLocation;
    CGPoint _swipeTranslation;
}

@property (nonatomic,strong) NSMutableSet *usageCells;
@property (nonatomic,strong) NSMutableDictionary *reusableCellCache;

@property (nonatomic,assign) CGPoint startPoint;

@property (nonatomic,assign) NSInteger index;

@end

@implementation KCSwipeCard

#pragma mark -Getter

- (NSMutableDictionary *)reusableCellCache
{
    if (!_reusableCellCache) {
        _reusableCellCache = @{}.mutableCopy;
    }
    return _reusableCellCache;
}

- (KCSwipeCardCell *)topCell
{
    return self.subviews.lastObject;
}

- (NSInteger)currentIndex
{
    return self.index - self.numberOfActiveItems;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(swipeCard:sizeForItemAtIndex:)]) {
        
        return [self.dataSource swipeCard:self sizeForItemAtIndex:index];
        
    }else {
        
        return self.bounds.size;
    }
}

- (NSInteger)numberOfActiveItems
{
    if ([self.dataSource respondsToSelector:@selector(numberOfActiveItemsInSwipeCard:)]) {
        return [self.dataSource numberOfActiveItemsInSwipeCard:self];
    }
     
    return 3;
}

- (NSInteger)numberOfItems
{
    return [self.dataSource numberOfItemsInSwipeCard:self];
}


- (NSMutableSet *)usageCells
{
    if (!_usageCells) {
        _usageCells = [NSMutableSet set];
    }
    return _usageCells;
}

#pragma mark -Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _animationDuration = 0.5;
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//        [self addGestureRecognizer:pan];
        
        
    }
    return self;
}

#pragma mark -Event

- (void)handlePan:(UIPanGestureRecognizer *)pan cell:(KCSwipeCardCell *)cell
{
    CGPoint point = [pan locationInView:self];
    
    // 判断是否允许滑动
    if ([self.delegate respondsToSelector:@selector(swipeCard:shouldBeginSwipeItemAtIndex:)]) {
        
        if (![self.delegate swipeCard:self shouldBeginSwipeItemAtIndex:self.currentIndex]) {
            return;
        }
    }
    
    _swipeLocation = point;
    CGPoint translation = [pan translationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        self.startPoint = point;
        
        // 将要开始滑动
        if ([self.delegate respondsToSelector:@selector(swipeCard:willBeginSwipeItemAtIndex:)]) {
            [self.delegate swipeCard:self willBeginSwipeItemAtIndex:self.currentIndex];
        }
        return;
    }
    
    KCSwipeCardSwipeDirection direction;
    if (fabs(_swipeTranslation.x) > fabs(_swipeTranslation.y)) {
        
        if (_swipeTranslation.x < 0) {
            
            direction = KCSwipeCardSwipeDirectionLeft;
            
        }else {
            
            direction = KCSwipeCardSwipeDirectionRight;
            
        }
        
    }else {
        
        if (_swipeTranslation.y < 0) {
            
            direction = KCSwipeCardSwipeDirectionTop;
            
        }else {
            
            direction = KCSwipeCardSwipeDirectionBottom;
            
        }
        
    }
    
    // 正在滑动
    if ([self.delegate respondsToSelector:@selector(swipeCard:didSwipeItemAtIndex:inDirection:)]) {
        
        [self.delegate swipeCard:self didSwipeItemAtIndex:self.currentIndex inDirection:direction];
    }
    
    _swipeTranslation = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGFloat angle = (cell.frame.size.width * 0.5 + translation.x - cell.frame.size.width / 2.0) / cell.frame.size.width / 4.0;
        
        CGAffineTransform transform = CGAffineTransformTranslate(cell.transform, translation.x, translation.y);
        
        cell.transform = CGAffineTransformRotate(transform, angle);
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [pan velocityInView:self];
        
        switch (self.swipeDirection) {
            case KCSwipeCardSwipeDirectionHorizontal:{
                
                if (velocity.x > 1000 || velocity.x < -1000 || fabs(_swipeTranslation.x) > 50) {
                    
                    if (_swipeTranslation.x < 0) {
                        
                        [self swipeToDirection:KCSwipeCardSwipeDirectionLeft translation:translation cell:cell];
                        
                    }else {
                        
                        [self swipeToDirection:KCSwipeCardSwipeDirectionRight translation:translation cell:cell];
                    }
                    
                }else {
                    
                    [self cancelSwipeToDirection:direction translation:translation cell:cell];
                    
                }
                
            }
                
                break;
            case KCSwipeCardSwipeDirectionVertical:{
                
                if (velocity.y > 1000 || velocity.y < -1000 || fabs(_swipeTranslation.y) > 50) {
                    
                    if (_swipeTranslation.y < 0) {
                        
                        [self swipeToDirection:KCSwipeCardSwipeDirectionTop translation:translation cell:cell];
                        
                    }else {
                        
                        [self swipeToDirection:KCSwipeCardSwipeDirectionBottom translation:translation cell:cell];
                    }
                    
                }else {
                    
                    [self cancelSwipeToDirection:direction translation:translation cell:cell];
                    
                }
                
            }
                
                break;
                
            default:
                break;
        }
        
        
        if ([self.delegate respondsToSelector:@selector(swipeCard:didEndSwipeItemAtIndex:inDirection:)]) {
            [self.delegate swipeCard:self didEndSwipeItemAtIndex:self.currentIndex inDirection:direction];
        }
        
    }else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
        
        [self cancelSwipeToDirection:direction translation:translation cell:cell];
        
        if ([self.delegate respondsToSelector:@selector(swipeCard:didEndSwipeItemAtIndex:inDirection:)]) {
            [self.delegate swipeCard:self didEndSwipeItemAtIndex:self.currentIndex inDirection:direction];
        }
        
    }
    
    [pan setTranslation:CGPointZero inView:self];
}


#pragma mark -Public Method


- (KCSwipeCardCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    return [self.reusableCellCache[identifier] anyObject];
}

- (void)reloadData
{
    
    [self.usageCells makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < self.numberOfActiveItems; i++) {
        
        [self nextCell];
        
    }
    
}

- (void)swipeToDirection:(KCSwipeCardSwipeDirection)direction translation:(CGPoint)translation cell:(KCSwipeCardCell *)cell
{
    if (cell != self.topCell) {
        
        [self cancelSwipeToDirection:direction translation:translation cell:cell];
        
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:shouldSwipeItemAtIndex:inDirection:)]) {
        
        if (![self.delegate swipeCard:self shouldSwipeItemAtIndex:self.currentIndex inDirection:direction]) {
            
            [self cancelSwipeToDirection:direction translation:translation cell:cell];
            
            return;
        }
        
    }
    
    switch (direction) {
        case KCSwipeCardSwipeDirectionTop:
            
            translation.y = -[UIScreen mainScreen].bounds.size.height;
            
            break;
        case KCSwipeCardSwipeDirectionBottom:
            
            translation.y = [UIScreen mainScreen].bounds.size.height;
            break;
        case KCSwipeCardSwipeDirectionLeft:
            
            translation.x = -[UIScreen mainScreen].bounds.size.width;
            
            break;
        case KCSwipeCardSwipeDirectionRight:
            
            translation.x = [UIScreen mainScreen].bounds.size.width;
            break;
            
        default:
            break;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:didSwipeItemAtIndex:inDirection:)]) {
        [self.delegate swipeCard:self didSwipeItemAtIndex:self.currentIndex inDirection:direction];
    }
    
    CGFloat angle = (cell.frame.size.width * 0.5 + translation.x - cell.frame.size.width / 2.0) / cell.frame.size.width / 4.0;
    
    CGAffineTransform transform = CGAffineTransformTranslate(cell.transform, translation.x, translation.y);
    
    [UIView animateWithDuration:_animationDuration animations:^{
        
        cell.transform = CGAffineTransformRotate(transform, angle);
        
        
    }completion:^(BOOL finished) {
        
        [self nextCell];
        [self reuseCell];
        
    }];
    
}

- (void)cancelSwipeToDirection:(KCSwipeCardSwipeDirection)direction translation:(CGPoint)translation cell:(KCSwipeCardCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(swipeCard:didCancelSwipeItemAtIndex:inDirection:)]) {
        [self.delegate swipeCard:self didCancelSwipeItemAtIndex:self.currentIndex inDirection:direction];
    }
    
    [UIView animateWithDuration:_animationDuration animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}

- (void)previousCell
{
    
}

- (void)nextCell
{
    if (self.index == self.numberOfItems) {
        return;
    }
    
    KCSwipeCardCell *cell = [self.dataSource swipeCard:self cellForItemAtIndex:self.index];
    __weak typeof(self) weakSelf = self;
    cell.panBlock = ^(KCSwipeCardCell *cell, UIPanGestureRecognizer *pan) {
//        if (cell != self.topCell) {
//            return;
//        }
        [weakSelf handlePan:pan cell:cell];
    };
    
    [self insertSubview:cell atIndex:0];
    
    [self.usageCells addObject:cell];
//    [self.reusableCells removeObject:cell];
    
    [self.reusableCellCache[cell.reuseIdentifier] removeObject:cell];
    
    CGSize size = [self sizeForItemAtIndex:self.index];
    cell.frame = CGRectMake(0, 0, size.width, size.height);
    cell.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
//    CGFloat scale = 1 - self.usageCells.count * 0.1;
    
//    cell.transform = CGAffineTransformMakeScale(scale, scale);
    
//    cell.transform = CGAffineTransformMakeTranslation(0, 10);
    
    self.index++;

}

- (void)reuseCell
{
    self.topCell.transform = CGAffineTransformIdentity;
    self.topCell.alpha = 1;
    
    NSMutableSet *set = self.reusableCellCache[self.topCell.reuseIdentifier];
    
    if (!set) {
        set = [NSMutableSet set];
        self.reusableCellCache[self.topCell.reuseIdentifier] = set;
    }
    
    [set addObject:self.topCell];
    [self.usageCells removeObject:self.topCell];
    [self.topCell removeFromSuperview];
    
}



@end
