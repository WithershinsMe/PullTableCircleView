//
//  AppDelegate.h
//  PullTableCircleView

//  Created by GK on 2019/2/13.
//  Copyright © 2019年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleViewController : UIViewController
//+ (instancetype)new NS_UNAVAILABLE;
//- (instancetype)init ;
//- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSUInteger)index;

@property (nonatomic,strong) NSMutableArray *photos;

@end

NS_ASSUME_NONNULL_END
