//
//  CircleImageCell.h
//
//
//  Created by GK on 2019/2/13.
//  Copyright © 2019年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CircleImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

+ (NSString *)cellIdentifier;

@property (nonatomic,strong) NSString *imageIdentifier;
- (void)configCell:(NSString *)photo;
@end

NS_ASSUME_NONNULL_END
