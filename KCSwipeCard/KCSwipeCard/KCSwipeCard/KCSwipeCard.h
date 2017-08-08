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

@property (nonatomic,assign, getter=isSwiping) BOOL swiping;

- (__kindof KCSwipeCardCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)reloadData;

@end
