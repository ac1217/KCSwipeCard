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
// default is equal to cardView's bounds
- (CGSize)swipeCard:(KCSwipeCard *)swipeCard sizeForItemAtIndex:(NSInteger)index;

@end

@protocol KCSwipeCardDelegate <NSObject>

// 滑过一张
- (void)swipeCard:(KCSwipeCard *)swipeCard didSwipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction;

// 是否允许结束滑动
- (BOOL)swipeCard:(KCSwipeCard *)swipeCard shouldSwipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction;

// 取消滑动
- (void)swipeCard:(KCSwipeCard *)swipeCard didCancelSwipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction;

// 松开手
- (void)swipeCard:(KCSwipeCard *)swipeCard didEndSwipeItemAtIndex:(NSInteger)index inDirection:(KCSwipeCardSwipeDirection)direction;

// 将要滑动
- (void)swipeCard:(KCSwipeCard *)swipeCard willBeginSwipeItemAtIndex:(NSInteger)index;


// 是否允许开始滑动
- (BOOL)swipeCard:(KCSwipeCard *)swipeCard shouldBeginSwipeItemAtIndex:(NSInteger)index;

// 动画执行完毕
- (void)swipeCard:(KCSwipeCard *)swipeCard didEndSwipeDeceleratingCell:(KCSwipeCardCell *)cell inDirection:(KCSwipeCardSwipeDirection)direction;

@end

@interface KCSwipeCard : UIView

@property (nonatomic,assign, readonly) NSInteger numberOfActiveItems;
@property (nonatomic,assign, readonly) NSInteger numberOfItems;
@property (nonatomic,assign, readonly) NSInteger currentIndex;
@property (nonatomic,strong, readonly) KCSwipeCardCell *topCell;

@property (nonatomic, weak) id <KCSwipeCardDataSource> dataSource;
@property (nonatomic, weak) id <KCSwipeCardDelegate> delegate;

@property (nonatomic,assign) KCSwipeCardSwipeDirection swipeDirection;
@property (nonatomic,assign) NSTimeInterval animationDuration;

- (__kindof KCSwipeCardCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)reloadData;

//- (KCSwipeCardCell *)cellForItemAtIndex:(NSInteger)index;


@property (nonatomic,assign, readonly) CGPoint swipeLocation;
@property (nonatomic,assign, readonly) CGPoint swipeTranslation;

@end
