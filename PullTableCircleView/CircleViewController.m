//  AppDelegate.h
//  PullTableCircleView

//  Created by GK on 2019/2/13.
//  Copyright © 2019年 GK. All rights reserved.
//

#import "CircleViewController.h"
#import "CircleImageCell.h"

@interface CircleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) NSInteger totalPages;
@property (nonatomic) BOOL isScrolling;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL shouldToRightPlace;
@end

@implementation CircleViewController

//- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSUInteger)index {
//    self = [super init];
//    if (self) {
//        self.photos = [NSMutableArray arrayWithArray:photos];
//        self.currentIndex = index;
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldToRightPlace = YES;
    
    [self generateContent];
    [self generatePhotosData];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.shouldToRightPlace) {
        [self startTimer];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.photos.count > 1) {
        [self endTimer];
    }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.shouldToRightPlace) {
        self.shouldToRightPlace = NO;
        if (self.photos.count >= 2) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]  atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            self.pageControl.currentPage = 0;
            [self startTimer];
        }
    }
}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    if (self.shouldToRightPlace) {
//        self.shouldToRightPlace = NO;
//        if (self.photos.count >= 2) {
////            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]  atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//            self.pageControl.currentPage = 0;
//            [self startTimer];
//        }
//    }
//}
- (void)pageControSetIndex:(NSInteger) index {
    NSInteger current = index - 1;
    if (current < 0) {
        current = 0;
    }
    self.pageControl.currentPage = current;
}
- (NSInteger)pageControlGetIndex {
    NSInteger current = self.pageControl.currentPage;
    current = current + 1;
    if (current > 4) {
        current = 4;
    }
    return current;
}
- (NSString *)photoForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 0 && indexPath.row < self.photos.count) {
        return self.photos[indexPath.row];
    }
    return nil;
}
- (void)reversePhotoArray:(NSArray *)photoArray startIndex:(NSUInteger) start endIndex:(NSUInteger) end {
    if (start >= end) {
        return;
    }
    [self.photos exchangeObjectAtIndex:start withObjectAtIndex:end];
    [self reversePhotoArray:photoArray startIndex: start + 1 endIndex:end - 1];
}
- (void)generatePhotosData {
    if (self.photos.count >= 2) {
        NSString *photosURL = self.photos.lastObject;
        [self.photos insertObject:photosURL atIndex:0];
        
        NSString *image = self.photos[1];
        [self.photos addObject:image];
    }
}
- (void)generateContent {
  [self.collectionView registerNib:[UINib nibWithNibName:[CircleImageCell cellIdentifier] bundle:nil] forCellWithReuseIdentifier:[CircleImageCell cellIdentifier]];
    
    if(self.photos.count > 1) {
        self.pageControl.pageIndicatorTintColor = UIColor.grayColor;
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.numberOfPages = self.photos.count;
        self.totalPages = self.photos.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.photos.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CircleImageCell cellIdentifier] forIndexPath:indexPath];
    NSString *photo = [self photoForIndexPath:indexPath];
    cell.clipsToBounds = YES;
//    cell.imageIdentifier = photo.imageUrl;
    [cell configCell:photo];
    return  cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 194);
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *photo = [self photoForIndexPath:indexPath];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView){
        if (self.photos.count <= 1) {
            return;
        }
        CGFloat fullyScrolledContentOffset = self.collectionView.frame.size.width * (self.photos.count - 1);
        CGFloat width = self.collectionView.frame.size.width / 2.0;
        if (scrollView.contentOffset.x >= (fullyScrolledContentOffset - width)) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
        } else if (scrollView.contentOffset.x <= 0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.photos.count - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
        }
        self.isScrolling = NO;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        if (self.photos.count <= 1) {
            return;
        }
        NSUInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
        
        if (self.pageControl) {
            NSInteger pages = self.totalPages + 1;
            if (pages != 0) {
                NSNumber *number = [NSNumber numberWithFloat:ceilf(index%pages)];
                [self pageControSetIndex:number.integerValue];
            }
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(scrollView == self.collectionView) {
        self.isScrolling = YES;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(scrollView == self.collectionView){
        if (!decelerate) {
            self.isScrolling = NO;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if(scrollView == self.collectionView) {
        self.isScrolling = NO;
    }
}

- (void)startTimer {
    if (self.timer == nil) {
        self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(scrollCollectionViewAuto) userInfo:@{} repeats:YES];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer: self.timer forMode: NSRunLoopCommonModes];
    }
}
- (void)endTimer {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
-(void)scrollCollectionViewAuto {
    
    NSInteger index = [self pageControlGetIndex];
    NSInteger total = self.totalPages;

    BOOL reverse = NO;
    if (index == (total)) {
        index = 1;
        reverse = NO;
    }else {
        index = index + 1;
        reverse = YES;
    }
    if (index <= total) {
        self.currentIndex = index;

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
       [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:reverse];

        if (reverse) {
            [self performSelector:@selector(delayPageControl) withObject:nil afterDelay:0.3];
        }else {
            [self pageControSetIndex:index];
        }
    }
}
- (void)delayPageControl {
    [self pageControSetIndex:self.currentIndex];

}
- (void)setIsScrolling:(BOOL)isScrolling {
    
    if (_isScrolling != isScrolling) {
        _isScrolling = isScrolling;
    }
    if (_isScrolling) {
        [self endTimer];
    } else {
        [self startTimer];
    }
}
@end
