//
//  TZWBannerView.m
//  YTADDemo
//
//  Created by chinatsp on 16/3/2.
//  Copyright © 2016年 chinatsp. All rights reserved.
//

#import "TZWBannerView.h"
#import "YTAdvsCell.h"
#import "TZWLineLatout.h"
#define TOTAL_ITEMS (self.itemCount *2000)
#define PAGECONTROL_HEIGHT 32.0
@interface TZWBannerView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TZWLineLatout *flowLayout;
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger nextItem;
@end

@implementation TZWBannerView
@synthesize scrollInterval = _scrollInterval;
@synthesize autoScroll = _autoScroll;
@synthesize loop = _loop;
@synthesize pageControl = _pageControl;

static NSString *bannerFlag = @"bannerFlag";

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupInitialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupInitialize];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self latyoutSubviewsFrame];
}

- (void)setupInitialize
{
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}
- (void)latyoutSubviewsFrame
{
    self.collectionView.frame = self.bounds;
    if(CGRectEqualToRect(self.pageControl.frame, CGRectZero))
    {
        CGFloat width = self.frame.size.width;
        CGFloat height = PAGECONTROL_HEIGHT;
        CGFloat x = 0;
        CGFloat y = self.frame.size.height - height;
        self.pageControl.frame = CGRectMake(x, y, width, height);
    }
}
- (void)initializeScorllPosition
{
    if(self.itemCount ==0 ||self.itemCount < 2)
    {
        return;
    }
    if (self.loop) {
        //跳到item总数的中间
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(TOTAL_ITEMS / 2) inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            self.pageControl.currentPage = 0;
        });
    }
    else
    {
        // 第0个item
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            self.pageControl.currentPage = 0;
        });
    }
}


- (void)reloadData
{
    if (!self.dataSource || self.itemCount == 0) {
        return;
    }
    
    // 设置pageControl总页数
    self.pageControl.numberOfPages = self.itemCount;
    
    // 刷新数据
    [self.collectionView reloadData];
    
    // 开启定时器
    [self startTimer];
}
#pragma mark - NSTimer

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer
{
    if (!self.autoScroll) return;
    
    [self stopTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(autoScrollNextToNext) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)autoScrollNextToNext
{
    
    if (self.itemCount == 0 ||
        self.itemCount == 1 ||
        !self.autoScroll)
    {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    NSUInteger currentItem = currentIndexPath.item;
    if(self.nextItem < currentItem)
    {
        _nextItem = currentItem;
    }
    
    if(_nextItem >= TOTAL_ITEMS) {
        return;
    }
        // 无限往下翻页
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_nextItem inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
        _nextItem++;

}
#pragma mark------UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
    return TOTAL_ITEMS;
  

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YTAdvsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerFlag forIndexPath:indexPath];
    if([self.dataSource respondsToSelector:@selector(banner:viewForItemAtIndex:)])
    {
        UIView *item = [self.dataSource banner:self viewForItemAtIndex:indexPath.item % self.itemCount];
        item.frame = cell.bounds;
        [cell addSubview:item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(banner:didSelectItemAtIndex:)]) {
        [self.delegate banner:self didSelectItemAtIndex:(indexPath.item % self.itemCount)];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIndexPath = [[collectionView indexPathsForVisibleItems] firstObject];
    NSLog(@"++++++++%ld+++++++++++",indexPath.row);
  
        if(currentIndexPath.row < indexPath.row)
        {
            if(indexPath.row %self.itemCount==0)
            {
                self.pageControl.currentPage = self.itemCount -1;
            }
            else
            {
                self.pageControl.currentPage = (indexPath.row % self.itemCount) -1;
            }
        }
        else
        {
            if((indexPath.row +2) %self.itemCount==0)
            {
                 self.pageControl.currentPage = self.itemCount -1;
            }
            else
            {
                self.pageControl.currentPage = ((indexPath.row+2) % self.itemCount) -1;
            }
        
        }
   
 
}


#pragma mark - UIScrollViewDelegate
#pragma mark timer相关

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 用户滑动的时候停止定时器
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 用户停止滑动的时候开启定时器
    [self startTimer];
}

#pragma mark - setters & getters
#pragma mark 属性

/**
 *  数据源
 */
- (void)setDataSource:(id<TZWBannerViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    // 刷新数据
    [self reloadData];
    
    // 配置默认起始位置
    [self initializeScorllPosition];
}

- (NSInteger)itemCount
{
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInBanner:)]) {
        return [self.dataSource numberOfItemsInBanner:self];
    }
    return 0;
}

/**
 *  是否需要循环滚动
 */

//- (void)setLoop:(BOOL)loop
//{
//    _loop = loop;
//    [self reloadData];
//    [self initializeScorllPosition];
//
//}
- (BOOL)loop
{
    if (self.itemCount <2) {
        // 只有一个item也不应该有循环滚动
        return NO;
    }
    return YES;
}
/**
*  是否自动滑动
*/
- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

- (BOOL)autoScroll
{
    if (self.itemCount < 2) {
        // itemCount小于2时, 禁用自动滚动
        return NO;
    }
    return _autoScroll;
}

/**
 *  自动滑动间隔时间
 */
- (void)setScrollInterval:(NSTimeInterval)scrollInterval
{
    _scrollInterval = scrollInterval;
    
    [self startTimer];
}

- (NSTimeInterval)scrollInterval
{
    if (!_scrollInterval) {
        _scrollInterval = 2.5; // default
    }
    return _scrollInterval;
}

/**
 *  pageControl
 */
- (void)setPageControl:(UIPageControl *)pageControl
{
    // 移除旧oageControl
    [_pageControl removeFromSuperview];
    
    // 赋值
    _pageControl = pageControl;
    
    // 添加新pageControl
    _pageControl.userInteractionEnabled = NO;
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    _pageControl.backgroundColor = [UIColor redColor];
    [self addSubview:_pageControl];
    
    [self reloadData];
}
#pragma mark 控件

/**
 *  collectionView
 */
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        // 注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"YTAdvsCell" bundle:nil] forCellWithReuseIdentifier:bannerFlag];
    }
    return _collectionView;
}

- (TZWLineLatout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[TZWLineLatout alloc] init];
    }
    return _flowLayout;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.autoresizingMask = UIViewAutoresizingNone;
    }
    return _pageControl;
}

@end
