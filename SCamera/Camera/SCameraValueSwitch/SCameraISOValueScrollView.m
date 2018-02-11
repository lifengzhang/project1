//
//  SCameraISOValueScrollView.m
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraISOValueScrollView.h"

#define ValuesWidth             84

@interface SCameraISOValueScrollView() <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation SCameraISOValueScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.iSOValuesArray = @[@(25),@(32),@(40),@(64),@(80),@(100),@(125),@(160),@(200),@(250),@(320),@(400),@(500),@(640),@(800)];
        self.scrollEnabled = NO;
        self.contentSize = CGSizeMake(self.iSOValuesArray.count*ValuesWidth, 35);
        self.contentInset = UIEdgeInsetsMake(0, (Width_Screen/2 - 84 - 42), 0, 0);
        self.contentOffset = CGPointMake(-(Width_Screen/2 - 84 - 42), 0);
        self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.24];
        self.showsHorizontalScrollIndicator = NO;
//        self.delegate = self;
        
        UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:rightRecognizer];
        
        UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:leftRecognizer];


        [self initValuesLabel];
    }
    
    return self;
    
}

- (void)initValuesLabel {
    
    for (int i = 0; i < self.iSOValuesArray.count; i++) {
     
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ValuesWidth*i, 0, 84, 35)];
        label.text = [self.iSOValuesArray[i] stringValue];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:[UIColor whiteColor]];
        [self addSubview:label];
        
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
    CGFloat offset = -(Width_Screen/2 - 84 - 42);
    //1.判断滑动方向
    if (scrollView.contentOffset.x > scrollView.bounds.size.width) {//向左滑动
        
        self.currentPage = (self.currentPage + 1) % self.iSOValuesArray.count;
        [self setContentOffset:CGPointMake(offset + self.currentPage*ValuesWidth, 0) animated:YES];
        
    }else if(scrollView.contentOffset.x < scrollView.bounds.size.width){ //向右滑动
        self.currentPage = (self.currentPage - 1 + self.iSOValuesArray.count) % self.iSOValuesArray.count;
        [self setContentOffset:CGPointMake(offset - self.currentPage*ValuesWidth, 0) animated:YES];
    }

}

//float lastContentOffset;
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    self.currentPage++;
//    lastContentOffset = scrollView.contentOffset.x;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offset = -(Width_Screen/2 - 84 - 42);
//    if (self.currentPage >= 0) {
//        if (lastContentOffset < scrollView.contentOffset.x) {
//            //        NSLog(@"向左滚动");
//            self.currentPage++;
//            [self setContentOffset:CGPointMake(offset + self.currentPage*ValuesWidth, 0) animated:YES];
//        }else{
//            self.currentPage--;
//            [self setContentOffset:CGPointMake(offset - self.currentPage*ValuesWidth, 0) animated:YES];
//            //        NSLog(@"向右滚动");
//        }
//    }
//
//}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    CGFloat offset = -(Width_Screen/2 - 84 - 42);
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
//        NSLog(@"swipe left");
        self.currentPage++;
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
//        NSLog(@"swipe right");
        self.currentPage--;
    }
    if (self.currentPage >= 0) {
        [self setContentOffset:CGPointMake(offset + self.currentPage*ValuesWidth, 0) animated:YES];
    }
    
    self.iSOValue = [self.iSOValuesArray[self.currentPage] integerValue];
    
}

@end
