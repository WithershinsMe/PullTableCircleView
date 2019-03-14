//
//  CircleImageCell.m
//
//
//  Created by GK on 2019/2/13.
//  Copyright © 2019年 GK. All rights reserved.
//

#import "CircleImageCell.h"

@implementation CircleImageCell

+ (NSString *)cellIdentifier {
    return @"CircleImageCell";
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
}
- (void)setCellImageView:(UIImageView *)cellImageView {
    _cellImageView = cellImageView;
    
    _cellImageView.contentMode = UIViewContentModeScaleToFill;
    _cellImageView.clipsToBounds = YES;
}
- (void)configCell:(NSString *)photo {
   
    [self.cellImageView setImage:[UIImage imageNamed:photo]];
}
@end
