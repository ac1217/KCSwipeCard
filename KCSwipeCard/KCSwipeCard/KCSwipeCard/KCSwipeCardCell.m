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
        
    }
    return self;
}


@end
