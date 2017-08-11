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
    NSInteger _topItemIndex;
    
}

@property (nonatomic,strong) NSMutableDictionary *reusableCellCache;
@property (nonatomic,strong) NSMutableDictionary *cellSourceCache;

@property (nonatomic,strong) NSMutableArray *visibleCells;

@property (nonatomic,assign) CGPoint startPoint;

@property (nonatomic,assign, readonly) CGPoint cellCenter;

@property (nonatomic,assign) NSInteger nextItemIndex;

@end

@implementation KCSwipeCard

#pragma mark -Getter

- (CGPoint)cellCenter
{
    return CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
}

- (NSMutableArray *)visibleCells
{
    if (!_visibleCells) {
        _visibleCells = @[].mutableCopy;
    }
    return _visibleCells;
}

- (NSMutableDictionary *)reusableCellCache
{
    if (!_reusableCellCache) {
        _reusableCellCache = @{}.mutableCopy;
    }
    return _reusableCellCache;
}

- (NSMutableDictionary *)cellSourceCache
{
    if (!_cellSourceCache) {
        _cellSourceCache = @{}.mutableCopy;
    }
    return _cellSourceCache;
}

- (KCSwipeCardCell *)topCell
{
    return self.visibleCells.firstObject;;
}

- (NSInteger)nextItemIndex
{
    return self.topItemIndex + self.visibleCells.count;
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

- (CGPoint)offsetForItemAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(swipeCard:offsetForItemAtIndex:)]) {
        return [self.dataSource swipeCard:self offsetForItemAtIndex:index];
    }
    return self.offsetForItem;
}

#pragma mark -Setter

#pragma mark -Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
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
    _animationDuration = 0.5;
    
}

#pragma mark -Event

- (void)handlePan:(UIPanGestureRecognizer *)pan cell:(KCSwipeCardCell *)cell
{
    
//    if (cell != self.topCell) {
//        return;
//    }
    
    NSInteger index = [self indexForCell:cell];
    
    // 判断是否允许滑动
    if ([self.delegate respondsToSelector:@selector(swipeCard:shouldBeginSwipeItemAtIndex:)]) {
        
        if (![self.delegate swipeCard:self shouldBeginSwipeItemAtIndex:index]) {
            return;
        }
    }
    
    _swipeLocation = [pan locationInView:self];
    _swipeTranslation = [pan translationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        // 将要开始滑动
        if ([self.delegate respondsToSelector:@selector(swipeCard:willBeginSwipeItemAtIndex:)]) {
            [self.delegate swipeCard:self willBeginSwipeItemAtIndex:index];
        
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
    
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        cell.center = CGPointMake(self.cellCenter.x + _swipeTranslation.x, self.cellCenter.y + _swipeTranslation.y);
        CGFloat angle = (cell.center.x - cell.frame.size.width / 2.0) / cell.frame.size.width / 4.0;
        
        cell.transform = CGAffineTransformMakeRotation(angle);
        
        
        // 正在滑动
        if ([self.delegate respondsToSelector:@selector(swipeCard:swipeItemAtIndex:inDirection:)]) {
            
            [self.delegate swipeCard:self swipeItemAtIndex:index inDirection:direction];
        }
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (cell != self.topCell) {
            
            [self cancelSwipeToDirection:direction cell:cell];
            return;
        }
        
        CGPoint velocity = [pan velocityInView:self];
        
        switch (self.swipeDirection) {
            case KCSwipeCardSwipeDirectionHorizontal:{
                
                if (velocity.x > 1000 || velocity.x < -1000 || fabs(_swipeTranslation.x) > 50) {
                    
                    if (_swipeTranslation.x < 0) {
                        
                        [self swipeToDirection:KCSwipeCardSwipeDirectionLeft cell:cell];
                        
                    }else { 
                        
                        [self swipeToDirection:KCSwipeCardSwipeDirectionRight cell:cell];
                    }
                    
                }else {
                    
                    [self cancelSwipeToDirection:direction cell:cell];
                    
                }
                
            }
                
                break;
            case KCSwipeCardSwipeDirectionVertical:{
                
                if (velocity.y > 1000 || velocity.y < -1000 || fabs(_swipeTranslation.y) > 50) {
                    
                    if (_swipeTranslation.y < 0) {
                        
                        [self swipeToDirection:KCSwipeCardSwipeDirectionTop cell:cell];
                        
                    }else {
                        
                        [self swipeToDirection:KCSwipeCardSwipeDirectionBottom cell:cell];
                    }
                    
                }else {
                    
                    [self cancelSwipeToDirection:direction cell:cell];
                    
                }
                
            }
                
                break;
                
            default:
                [self cancelSwipeToDirection:direction cell:cell];
                break;
        }
        
    }else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
        
        [self cancelSwipeToDirection:direction cell:cell];
        
    }
    
}


#pragma mark -Public Method

- (NSInteger)indexForCell:(KCSwipeCardCell *)cell
{
    NSInteger index = [self.visibleCells indexOfObject:cell];
    return index + self.topItemIndex;
}

- (void)swipeItemToDirection:(KCSwipeCardSwipeDirection)direction
{
    [self swipeToDirection:direction cell:self.topCell];
}


- (void)swipeItemFromDirection:(KCSwipeCardSwipeDirection)direction
{
    [self swipeFromDirection:direction];
}


- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    self.cellSourceCache[identifier] = cellClass;
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier
{
    self.cellSourceCache[identifier] = nib;
}

- (KCSwipeCardCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    KCSwipeCardCell *cell = [self.reusableCellCache[identifier] anyObject];
    
    if (!cell) {
       
        id cellSource = self.cellSourceCache[identifier];
        
        if ([cellSource isKindOfClass:[UINib class]]) {
            
            UINib *cellNib = cellSource;
            
            cell = [[cellNib instantiateWithOwner:nil options:nil] lastObject];
            
        }else {
            
            cell = [[[cellSource class] alloc] initWithReuseIdentifier:identifier];
        }
        
    }else {
        
        [self.reusableCellCache[identifier] removeObject:cell];
        
    }
    
    return cell;
}

- (void)reloadData
{
    
    [self.visibleCells makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.visibleCells removeAllObjects];
    [self.reusableCellCache removeAllObjects];
    _topItemIndex = 0;
    
    
    for (int i = 0; i < self.numberOfActiveItems; i++) {
        
        [self nextCell];
        
    }
    
    [self refreshLayoutAnimated:NO];
}

#pragma mark -Private Method

- (void)swipeFromDirection:(KCSwipeCardSwipeDirection)direction {
    
    if (_topItemIndex == 0) {
        return;
    }
    
    _topItemIndex -= 1;
    
    KCSwipeCardCell *cell = [self previousCell];
    
    NSInteger index = [self indexForCell:cell];
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:shouldSwipeItemAtIndex:inDirection:)]) {
        
        if (![self.delegate swipeCard:self shouldSwipeItemAtIndex:index inDirection:direction]) {
            
            return;
        }
        
    }
    
    CGFloat translationX = 0;
    CGFloat translationY = 0;
    switch (direction) {
        case KCSwipeCardSwipeDirectionTop:
            translationY = -[UIScreen mainScreen].bounds.size.height * 2;
            
            break;
        case KCSwipeCardSwipeDirectionBottom:
            
            translationY = [UIScreen mainScreen].bounds.size.height * 2;
            
            break;
        case KCSwipeCardSwipeDirectionLeft:
            translationX = -[UIScreen mainScreen].bounds.size.width * 2;
            
            break;
        case KCSwipeCardSwipeDirectionRight:
            
            translationX = [UIScreen mainScreen].bounds.size.width * 2;
            break;
            
        default:
            break;
    }
    
    cell.center = CGPointMake(cell.center.x + translationX, cell.center.y + translationY);
    CGFloat angle = (cell.center.x - cell.frame.size.width / 2.0) / cell.frame.size.width / 4.0;
    cell.transform = CGAffineTransformMakeRotation(angle);
    
    KCSwipeCardCell *bottomCell;
    if (self.visibleCells.count > self.numberOfActiveItems) {
        
        bottomCell = self.visibleCells.lastObject;
        [self.visibleCells removeObject:bottomCell];
        
    }
    
    [UIView animateWithDuration:_animationDuration animations:^{
        cell.center = self.cellCenter;
        cell.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        
        [bottomCell removeFromSuperview];
        [self reuseCell:bottomCell];
        
        if ([self.delegate respondsToSelector:@selector(swipeCard:didEndSwipeItemAtIndex:inDirection:)]) {
            [self.delegate swipeCard:self didEndSwipeItemAtIndex:index inDirection:direction];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:didSwipeItemAtIndex:inDirection:)]) {
        [self.delegate swipeCard:self didSwipeItemAtIndex:index inDirection:direction];
    }
    [self refreshLayoutAnimated:YES];
    
}


- (void)swipeToDirection:(KCSwipeCardSwipeDirection)direction cell:(KCSwipeCardCell *)cell
{
    if (!cell) {
        return;
    }
    
    NSInteger index = [self indexForCell:cell];
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:shouldSwipeItemAtIndex:inDirection:)]) {
        
        if (![self.delegate swipeCard:self shouldSwipeItemAtIndex:index inDirection:direction]) {
            
            [self cancelSwipeToDirection:direction cell:cell];
            
            return;
        }
        
    }
    
    CGFloat translationX = 0;
    CGFloat translationY = 0;
    switch (direction) {
        case KCSwipeCardSwipeDirectionTop:
            translationY = -[UIScreen mainScreen].bounds.size.height * 2;
            
            break;
        case KCSwipeCardSwipeDirectionBottom:
            
            translationY = [UIScreen mainScreen].bounds.size.height * 2;
            
            break;
        case KCSwipeCardSwipeDirectionLeft:
            translationX = -[UIScreen mainScreen].bounds.size.width * 2;
            
            break;
        case KCSwipeCardSwipeDirectionRight:
            
            translationX = [UIScreen mainScreen].bounds.size.width * 2;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:_animationDuration animations:^{
        
        cell.center = CGPointMake(cell.center.x + translationX, cell.center.y + translationY);
        CGFloat angle = (cell.center.x - cell.frame.size.width / 2.0) / cell.frame.size.width / 4.0;
        cell.transform = CGAffineTransformMakeRotation(angle);
        
    }completion:^(BOOL finished) {
        
        [cell removeFromSuperview];
        [self reuseCell:cell];
        
        if ([self.delegate respondsToSelector:@selector(swipeCard:didEndSwipeItemAtIndex:inDirection:)]) {
            [self.delegate swipeCard:self didEndSwipeItemAtIndex:index inDirection:direction];
        }
        
    }];
    
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:didSwipeItemAtIndex:inDirection:)]) {
        [self.delegate swipeCard:self didSwipeItemAtIndex:index inDirection:direction];
    }
    
    [self.visibleCells removeObject:cell];
    
    if (_topItemIndex < self.numberOfItems) {
        
        _topItemIndex += 1;
        [self nextCell];
        [self refreshLayoutAnimated:YES];
        
    }
    
    
}

- (void)cancelSwipeToDirection:(KCSwipeCardSwipeDirection)direction cell:(KCSwipeCardCell *)cell
{
    NSInteger index = [self indexForCell:cell];
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:didCancelSwipeItemAtIndex:inDirection:)]) {
        [self.delegate swipeCard:self didCancelSwipeItemAtIndex:index inDirection:direction];
    }
    
    [UIView animateWithDuration:_animationDuration animations:^{
        cell.transform = CGAffineTransformIdentity;
        cell.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    } completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(swipeCard:didEndCancelSwipeItemAtIndex:inDirection:)]) {
            [self.delegate swipeCard:self didEndCancelSwipeItemAtIndex:index inDirection:direction];
        }
    }];
}

- (KCSwipeCardCell *)previousCell
{
    if (!self.dataSource || self.topItemIndex < 0) {
        
        return nil;
    }
    
    
    NSInteger index = self.topItemIndex;
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:shouldLoadItemAtIndex:)]) {
        if ([self.delegate swipeCard:self shouldLoadItemAtIndex:index]) {
            return nil;
        }
        
    }
    
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:willLoadItemAtIndex:)]) {
        [self.delegate swipeCard:self willLoadItemAtIndex:index];
    }
    
    KCSwipeCardCell *cell = [self.dataSource swipeCard:self cellForItemAtIndex:index];
    CGSize size = [self sizeForItemAtIndex:index];
    cell.frame = CGRectMake(0, 0, size.width, size.height);
    
    NSAssert(cell, @"cell不能为空");
    __weak typeof(self) weakSelf = self;
    cell.panBlock = ^(KCSwipeCardCell *cell, UIPanGestureRecognizer *pan) {
        [weakSelf handlePan:pan cell:cell];
    };
    
    [self addSubview:cell];
    
    [self.visibleCells insertObject:cell atIndex:0];
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:didLoadItemAtIndex:)]) {
        [self.delegate swipeCard:self didLoadItemAtIndex:index];
    }
    
    return cell;
}

- (void)nextCell
{
    
    if (!self.dataSource || self.nextItemIndex == self.numberOfItems) {
        return;
    }
    NSInteger index = self.nextItemIndex;
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:shouldLoadItemAtIndex:)]) {
        if ([self.delegate swipeCard:self shouldLoadItemAtIndex:index]) {
            return;
        }
        
    }
    
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:willLoadItemAtIndex:)]) {
        [self.delegate swipeCard:self willLoadItemAtIndex:index];
    }
    
    KCSwipeCardCell *cell = [self.dataSource swipeCard:self cellForItemAtIndex:index];
    CGSize size = [self sizeForItemAtIndex:index];
    cell.frame = CGRectMake(0, 0, size.width, size.height);
    
    
    NSAssert(cell, @"cell不能为空");
    
    __weak typeof(self) weakSelf = self;
    cell.panBlock = ^(KCSwipeCardCell *cell, UIPanGestureRecognizer *pan) {
        
        [weakSelf handlePan:pan cell:cell];
    };
    
    [self insertSubview:cell atIndex:0];
    
    [self.visibleCells addObject:cell];
    
    if ([self.delegate respondsToSelector:@selector(swipeCard:didLoadItemAtIndex:)]) {
        [self.delegate swipeCard:self didLoadItemAtIndex:index];
    }
    
//    self.nextItemIndex += 1;
}

- (void)refreshLayoutAnimated:(BOOL)animated
{
    
    [UIView animateWithDuration:animated ? _animationDuration : 0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        for (int i = 0; i < self.visibleCells.count; i++) {
            
            NSInteger index = self.topItemIndex + i;
            
            KCSwipeCardCell *cell = self.visibleCells[i];
            
            if (i == 0) {
                
                cell.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
                
            }else {
                
                CGPoint offset = [self offsetForItemAtIndex:index];
                
                KCSwipeCardCell *previousCell = self.visibleCells[i - 1];
                
                cell.center = CGPointMake(previousCell.center.x + offset.x, previousCell.center.y + offset.y);
                
            }
            
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)reuseCell:(KCSwipeCardCell *)cell
{
    if (!cell) {
        return;
    }
    
    cell.transform = CGAffineTransformMakeRotation(0);
    cell.center = self.cellCenter;
    NSMutableSet *set = self.reusableCellCache[cell.reuseIdentifier];
    
    if (!set) {
        set = [NSMutableSet set];
        self.reusableCellCache[cell.reuseIdentifier] = set;
    }
    
    [set addObject:cell];
    
}


@end
