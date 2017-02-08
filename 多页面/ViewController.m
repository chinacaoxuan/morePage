//
//  ViewController.m
//  多页面
//
//  Created by 曹旋 on 17/2/8.
//  Copyright © 2017年 CX. All rights reserved.
//

#import "ViewController.h"
#import "OneController.h"
#import "TwoController.h"
@interface ViewController ()<UIScrollViewDelegate>

@property(strong, nonatomic) UIScrollView *scrollView;


@property(strong, nonatomic) UIScrollView *horiscrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    [self setupAllChildVcs];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.horiscrollView];
    [self addChildVcViewIntoScrollView:0];
    [self setupHoriScrollView];
}


- (void)setupHoriScrollView
{
    NSInteger i = 1;
    for (NSString *title in @[@"第一页",@"城市之星美女之花"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:0];
        [button setTitleColor:[UIColor whiteColor] forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        if (i == 1) {
            button.frame = CGRectMake(0, 0, [self fonWidth:title], 20);
        }else{
            UIButton *tempLabel = [self.horiscrollView viewWithTag:(i-1)*10];
            button.frame = CGRectMake(CGRectGetMaxX(tempLabel.frame), 0, [self fonWidth:title], 20);
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i*10;
        i ++;
        [self.horiscrollView addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)button
{
    NSInteger index = button.tag/10 - 1;
    [self dealTitleButtonClick:index decelerating:NO];
}

- (CGFloat)fonWidth:(NSString *)title
{
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    return size.width + 5;
}

- (void)setupAllChildVcs
{
    [self addChildViewController:[[OneController alloc] init]];
    [self addChildViewController:[[TwoController alloc] init]];
}

- (void)addChildVcViewIntoScrollView:(NSUInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    
    // 设置子控制器view的frame
    CGFloat scrollViewW = self.scrollView.frame.size.width;
    childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.frame.size.height);
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
}

#pragma mark - <UIScrollViewDelegate>
/**
 *  当用户松开scrollView并且滑动结束时调用这个代理方法（scrollView停止滚动的时候）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;

    [self dealTitleButtonClick:index decelerating:YES];
}

/**
 *  处理标题按钮点击
 */
- (void)dealTitleButtonClick:(NSInteger)index decelerating:(BOOL)decelerating
{
    NSTimeInterval time = decelerating?0.25:0;
    [UIView animateWithDuration:time animations:^{
        CGFloat offsetX = self.scrollView.frame.size.width * index;
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        // 添加子控制器的view
        [self addChildVcViewIntoScrollView:index];
    }];
    
    // 设置index位置对应的tableView.scrollsToTop = YES， 其他都设置为NO
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        // 如果view还没有被创建，就不用去处理
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        scrollView.scrollsToTop = (i == index);
    }
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        //        _scrollView.alwaysBounceVertical = YES;
        _scrollView.scrollsToTop = NO;
        // 添加子控制器的view
        NSUInteger count = self.childViewControllers.count;
        CGFloat scrollViewW = _scrollView.frame.size.width;
        _scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
    }
    return _scrollView;
}

- (UIScrollView *)horiscrollView
{
    if (!_horiscrollView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _horiscrollView = [[UIScrollView alloc] init];
        _horiscrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width,20);
        _horiscrollView.showsHorizontalScrollIndicator = NO;
        _horiscrollView.showsVerticalScrollIndicator = NO;
        //        _horiscrollView.pagingEnabled = YES;
        //        _horiscrollView.bounces = NO;
        _horiscrollView.alwaysBounceHorizontal = YES;
        //        _scrollView.alwaysBounceVertical = YES;
        //        _horiscrollView.scrollsToTop = NO;
        // 添加子控制器的view
        _horiscrollView.backgroundColor = [UIColor lightGrayColor];
    }
    return _horiscrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
