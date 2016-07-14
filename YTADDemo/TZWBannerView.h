//
//  TZWBannerView.h
//  YTADDemo
//
//  Created by chinatsp on 16/3/2.
//  Copyright © 2016年 chinatsp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  TZWBannerViewDataSource,TZWannerViewDelegate;
@interface TZWBannerView : UIView
/**
 *  设置是否需要循环滚动,默认为YES
 */
@property (nonatomic, assign,readonly) BOOL loop;
/**
 *  是否需要自动滑动,默认为NO
 */
@property (nonatomic, assign) BOOL autoScroll;
/**
 *  自动滑动时间间隔(s),默认2.5
 */
@property (nonatomic, assign) NSTimeInterval scrollInterval;
/**
 *  pageControl,系统控件,可以自由配置
 */
@property (nonatomic, strong ,readonly) UIPageControl *pageControl;

@property (nonatomic, weak) id<TZWBannerViewDataSource> dataSource;
@property (nonatomic, weak) id<TZWannerViewDelegate> delegate;

/**meths*/
- (void)reloadData;
- (void)startTimer;
- (void)stopTimer;
@end

@protocol TZWBannerViewDataSource <NSObject>

@required
/**
 *  @return item数量
 */
- (NSInteger)numberOfItemsInBanner:(TZWBannerView *)banner;
/**
 *  @return 自定义的item样式
 */
- (UIView *)banner:(TZWBannerView *)banner viewForItemAtIndex:(NSInteger)index;

@end
@protocol TZWannerViewDelegate <NSObject>

@optional
/**
 *  点击事件代理
 *
 *  @param banner TZWBannerView
 *  @param index  点击的第几个item
 */
- (void)banner:(TZWBannerView *)banner didSelectItemAtIndex:(NSInteger)index;
@end
