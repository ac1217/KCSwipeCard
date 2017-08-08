//
//  KCSwipeCard.m
//  KCSwipeCard
//
//  Created by iMac on 2017/8/8.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "KCSwipeCard.h"

@interface KCSwipeCard (){
    NSInteger _currentIndex;
    KCSwipeCardSwipeDirection _currentSwipeDirection;
}

@property (nonatomic,strong) NSMutableSet *usageCells;
@property (nonatomic,strong) NSMutableSet *reusableCells;



@end

@implementation KCSwipeCard

#pragma mark -Getter
- (KCSwipeCardCell *)topCell
{
    return self.subviews.lastObject;
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
    
    return 2;
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

- (NSMutableSet *)reusableCells
{
    if (!_reusableCells) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

#pragma mark -Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _animationDuration = 0.5;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

#pragma mark -Event

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self];
    
    if (!CGRectContainsPoint(self.topCell.frame, point)) {
        return;
    }
    
    CGPoint translation = [pan translationInView:self];
    
    CGPoint delta = CGPointMake(self.bounds.size.width * 0.5 - point.x, self.bounds.size.height * 0.5 - point.y);
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGFloat angle = (self.topCell.frame.size.width * 0.5 + translation.x - self.topCell.frame.size.width / 2.0) / self.topCell.frame.size.width / 4.0;
        
        CGAffineTransform transform = CGAffineTransformTranslate(self.topCell.transform, translation.x, translation.y);
        
        self.topCell.transform = CGAffineTransformRotate(transform, angle);
        
        if (fabs(delta.x) > fabs(delta.y)) {
            
            if (delta.x < 0) {
                _currentSwipeDirection = KCSwipeCardSwipeDirectionRight;
            }else {
                _currentSwipeDirection = KCSwipeCardSwipeDirectionLeft;
            }
            
        }else {
            
            if (delta.y < 0) {
                _currentSwipeDirection = KCSwipeCardSwipeDirectionBottom;
            }else {
                _currentSwipeDirection = KCSwipeCardSwipeDirectionTop;
            }
        }
        
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [pan velocityInView:self];
        
        if (velocity.x > 1000 || velocity.x < -1000 || fabs(delta.x) > 50 || fabs(delta.y) > 50) {
            
            if (self.swipeDirection == KCSwipeCardSwipeDirectionHorizontal && (_currentSwipeDirection == KCSwipeCardSwipeDirectionLeft || _currentSwipeDirection == KCSwipeCardSwipeDirectionRight)) {
                
                switch (_currentSwipeDirection) {
                    case KCSwipeCardSwipeDirectionLeft:
                        
                        translation.x = -[UIScreen mainScreen].bounds.size.width;
                        
                        break;
                    case KCSwipeCardSwipeDirectionRight:
                        
                        translation.x = [UIScreen mainScreen].bounds.size.width;
                        break;
                        
                    default:
                        break;
                }
                
                CGFloat angle = (self.topCell.frame.size.width * 0.5 + translation.x - self.topCell.frame.size.width / 2.0) / self.topCell.frame.size.width / 4.0;
                
                CGAffineTransform transform = CGAffineTransformTranslate(self.topCell.transform, translation.x, translation.y);
                
                [UIView animateWithDuration:_animationDuration animations:^{
                    
                    self.topCell.transform = CGAffineTransformRotate(transform, angle);
                    
                    
                }completion:^(BOOL finished) {
                    
                    [self nextCell];
                    [self reuseCell];
                    
                }];
                
                
            }else if (self.swipeDirection == KCSwipeCardSwipeDirectionVertical && (_currentSwipeDirection == KCSwipeCardSwipeDirectionTop || _currentSwipeDirection == KCSwipeCardSwipeDirectionBottom)) {
                
                switch (_currentSwipeDirection) {
                    case KCSwipeCardSwipeDirectionTop:
                        
                        translation.y = -[UIScreen mainScreen].bounds.size.height;
                        
                        break;
                    case KCSwipeCardSwipeDirectionBottom:
                        
                        translation.y = [UIScreen mainScreen].bounds.size.height;
                        break;
                        
                    default:
                        break;
                }
                
                CGFloat angle = (self.topCell.frame.size.width * 0.5 + translation.x - self.topCell.frame.size.width / 2.0) / self.topCell.frame.size.width / 4.0;
                
                CGAffineTransform transform = CGAffineTransformTranslate(self.topCell.transform, translation.x, translation.y);
                
                [UIView animateWithDuration:_animationDuration animations:^{
                    
                    self.topCell.transform = CGAffineTransformRotate(transform, angle);
                    
                    
                }completion:^(BOOL finished) {
                    
                    [self nextCell];
                    [self reuseCell];
                    
                }];
                
            }else {
                
                [UIView animateWithDuration:_animationDuration animations:^{
                    self.topCell.transform = CGAffineTransformIdentity;
                }];
            }
            
        } else {
            
            [UIView animateWithDuration:_animationDuration animations:^{
                self.topCell.transform = CGAffineTransformIdentity;
            }];
        }
        
    }else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
        
//        self.swiping = NO;
        
        [UIView animateWithDuration:_animationDuration animations:^{
            self.topCell.transform = CGAffineTransformIdentity;
        }];
        
    }else if (pan.state == UIGestureRecognizerStateBegan) {
        
//        self.swiping = YES;
        
    }
    
    [pan setTranslation:CGPointZero inView:self];
}


#pragma mark -Public Method
- (KCSwipeCardCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{

    return self.reusableCells.anyObject;
    
}

- (void)reloadData
{
    
    [self.usageCells makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < self.numberOfActiveItems; i++) {
        
        [self nextCell];
        
    }
    
}

- (void)swipeToDirection:(KCSwipeCardSwipeDirection)direction
{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        switch (direction) {
            case KCSwipeCardSwipeDirectionLeft:
                
                self.topCell.transform = CGAffineTransformTranslate(self.topCell.transform, -1000, -1000);
                break;
            case KCSwipeCardSwipeDirectionRight:
                
                self.topCell.transform = CGAffineTransformTranslate(self.topCell.transform, 1000, 1000);
                break;
                
            default:
                break;
        }
        
        
        
    }completion:^(BOOL finished) {
        
        [self nextCell];
        [self reuseCell];
        
    }];
}

- (void)resetSwipe
{
    
    [UIView animateWithDuration:_animationDuration animations:^{
        self.topCell.transform = CGAffineTransformIdentity;
    }];
}

- (void)nextCell
{
    if (_currentIndex == self.numberOfItems) {
        return;
    }
    
    KCSwipeCardCell *cell = [self.dataSource swipeCard:self cellForItemAtIndex:_currentIndex];
    
    [self insertSubview:cell atIndex:0];
    
    [self.usageCells addObject:cell];
    [self.reusableCells removeObject:cell];
    
    CGSize size = [self sizeForItemAtIndex:_currentIndex];
    cell.frame = CGRectMake(0, 0, size.width, size.height);
    cell.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
//    CGFloat scale = 1 - self.usageCells.count * 0.1;
    
//    cell.transform = CGAffineTransformMakeScale(scale, scale);
    
//    cell.transform = CGAffineTransformMakeTranslation(0, 10);
    
    _currentIndex++;

}

- (void)reuseCell
{
    self.topCell.transform = CGAffineTransformIdentity;
    self.topCell.alpha = 1;
    [self.reusableCells addObject:self.topCell];
    [self.usageCells removeObject:self.topCell];
    [self.topCell removeFromSuperview];
    
}



@end
