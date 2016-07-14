//
//  ViewController.m
//  YTADDemo
//
//  Created by chinatsp on 16/3/2.
//  Copyright © 2016年 chinatsp. All rights reserved.
//

#import "ViewController.h"
#import "TZWBannerView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<TZWBannerViewDataSource,TZWannerViewDelegate>
@property (nonatomic, strong) TZWBannerView *banner;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 控制器的automaticallyAdjustsScrollViewInsets属性为YES(default)时, 若控制器的view及其子控件有唯一的一个UIScrollView(或其子类), 那么这个UIScrollView(或其子类)会被调整内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 配置banner
    [self setupBanner];
}
- (void)setupBanner
{
    // 初始化
    self.banner = [[TZWBannerView alloc] init];
    self.banner.dataSource = self;
    self.banner.delegate = self;
    self.banner.autoScroll = YES;
    [self.view addSubview:self.banner];
    // 设置frame
    self.banner.frame = CGRectMake(0,
                                   64,
                                   kScreenWidth,
                                   300);
    self.banner.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.banner.pageControl.pageIndicatorTintColor = [UIColor blackColor];
}
#pragma mark - ZYBannerViewDataSource

// 返回Banner需要显示Item(View)的个数
- (NSInteger)numberOfItemsInBanner:(TZWBannerView *)banner
{
    return self.dataArray.count;
}

// 返回Banner在不同的index所要显示的View (可以是完全自定义的view, 且无需设置frame)
- (UIView *)banner:(TZWBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    // 取出数据
    NSString *imageName = self.dataArray[index];
    
    // 创建将要显示控件
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return imageView;
}


#pragma mark - ZYBannerViewDelegate

// 在这里实现点击事件的处理
- (void)banner:(TZWBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld个项目", index);
}
#pragma mark Getter

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for(int i =1 ; i<= 6 ;i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"%d",i];
            [_dataArray addObject:imageName];
        }
    }
    return _dataArray;
}

@end
