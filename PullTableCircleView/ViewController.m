//
//  ViewController.m
//  PullTableCircleView
//
//  Created by GK on 2019/3/14.
//  Copyright © 2019年 com.gk. All rights reserved.
//

#import "ViewController.h"
#import "CircleViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopConstraint;
@property (nonatomic) CGFloat headerHeight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.headerHeight = 150;
    self.tableVIew.backgroundColor = [UIColor clearColor];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"当前行%@",@(indexPath.row)];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, self.headerHeight);
    header.userInteractionEnabled = NO;
    header.backgroundColor = [UIColor clearColor];
    return header;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset < 0) {
        self.headerTopConstraint.constant = 0;
    } else {
        self.headerTopConstraint.constant = 0 - scrollOffset;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *childVC = segue.destinationViewController;
    if ([childVC isKindOfClass:[CircleViewController class]]) {
        CircleViewController *circleVC = (CircleViewController *)childVC;
        circleVC.photos =  [NSMutableArray arrayWithArray:@[@"A_Photographer",@"A_Song_of_Ice_and_Fire",@"Another_Rockaway_Sunset",@"Antelope_Butte"]];
    }
}
@end
