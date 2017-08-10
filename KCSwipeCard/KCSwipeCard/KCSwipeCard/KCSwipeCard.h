//
//  KCSwipeCard.h
//  KCSwipeCard
//
//  Created by iMac on 2017/8/8.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCSwipeCardCell.h"
@class KCSwipeCard;

typedef enum : NSUInteger {
    KCSwipeCardSwipeDirectionHorizontal,
    KCSwipeCardSwipeDirectionVertical,
    KCSwipeCardSwipeDirectionAll,
    KCSwipeCardSwipeDirectionLeft,
    KCSwipeCardSwipeDirectionRight,
    KCSwipeCardSwipeDirectionTop,
    KCSwipeCardSwipeDirectionBottom
} KCSwipeCardSwipeDirection;

@protocol KCSwipeCardDataSource <NSObject>

- (NSInteger)numberOfItemsInSwipeCard:(KCSwipeCard *)swipeCard;
- (KCSwipeCardCell *)swipeCard:(KCSwipeCard *)swipeCard cellForItemAtIndex:(NSInteger)index;

@optional
- (NSInteger)numberOfActiveItemsInSwipeCard:(KCSwipeCard *)swipeCard;
- (NSInteger)numberOfHistoryItemsInSwipeCard:(KCSwipeCard *)swipeCard;
// default is equal to cardView's bounds
- (CGSize)swipeCard:(KCSwipeCard *)swipeCard sizeForItemAtIndex:(NSInteger)index;
- (CGPoint)swipeCard:(KCSwipeCard *)swipeCard offsetForItemAtIndex:(NSInteger)index;

@end

@protocol KCSwipeCardDelegate <NSObject>

@optional
// 下一张卡片将要加载
- (void)swipeCard:(KCSwipeCard *)swipeCard willLoadItemAtIndex:(NSInteger)index;
// 下一张卡片加载完成
- (void)swipeCard:(KCSwipeCard *)swipeCard didLoadItemAtIndex:(NSInteger)index;

// 正在滑动
- (void)swipeCard:(KCSwipeCard *)swipeCard swipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction;

// 成功滑过一张
- (void)swipeCard:(KCSwipeCard *)swipeCard didSwipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction;

// 滑动完毕
- (void)swipeCard:(KCSwipeCard *)swipeCard didEndSwipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction;

// 是否成功滑过一张
- (BOOL)swipeCard:(KCSwipeCard *)swipeCard shouldSwipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction;

// 取消滑动
- (void)swipeCard:(KCSwipeCard *)swipeCard didCancelSwipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction;

// 取消滑动完成
- (void)swipeCard:(KCSwipeCard *)swipeCard didEndCancelSwipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction;

// 将要滑动
- (void)swipeCard:(KCSwipeCard *)swipeCard willBeginSwipeItemAtIndex:(NSInteger)index;

// 是否允许开始滑动
- (BOOL)swipeCard:(KCSwipeCard *)swipeCard shouldBeginSwipeItemAtIndex:(NSInteger)index;


@end

@interface KCSwipeCard : UIView

@property (nonatomic,assign, readonly) NSInteger numberOfHistoryItems;
@property (nonatomic,assign, readonly) NSInteger numberOfActiveItems;
@property (nonatomic,assign, readonly) NSInteger numberOfItems;

// 顶部cell索引
@property (nonatomic,assign, readonly) NSInteger topItemIndex;
@property (nonatomic,strong, readonly) KCSwipeCardCell *topCell;

// 正在显示的cell
@property (nonatomic,strong, readonly) NSMutableArray <KCSwipeCardCell *>*visibleCells;

@property (nonatomic, weak) id <KCSwipeCardDataSource> dataSource;
@property (nonatomic, weak) id <KCSwipeCardDelegate> delegate;

// 允许滑动的方向，默认水平方向
@property (nonatomic,assign) KCSwipeCardSwipeDirection swipeDirection;
// 动画时长
@property (nonatomic,assign) NSTimeInterval animationDuration;

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (__kindof KCSwipeCardCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (NSInteger)indexForCell:(KCSwipeCardCell *)cell;
- (void)swipeTopItemToDirection:(KCSwipeCardSwipeDirection)direction;

- (void)reloadData;

@property (nonatomic,assign, readonly) CGPoint swipeLocation;
@property (nonatomic,assign, readonly) CGPoint swipeTranslation;
@property (nonatomic, assign) CGPoint offsetForItem;

@end
