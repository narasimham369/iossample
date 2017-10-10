//
//  WalkThroughVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 14/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Constants.h"
#import "WalkThroughVC.h"
#import "WalkThroughView.h"

@interface WalkThroughVC ()<UIScrollViewDelegate>
@property (nonatomic,assign) int previuosIndex;
@property (nonatomic, assign) int noOfTutorialPages;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *walkThroughScroll;
@end

@implementation WalkThroughVC

- (void)initView {
    [super initView];
    self.previuosIndex = 1001;
    self.noOfTutorialPages = 3;
    [self.pageControl addTarget:self action:@selector(pageControllerAction:) forControlEvents:UIControlEventTouchUpInside];
    self.walkThroughScroll.delegate = self;
     [self.bottomButton setTitle:@"Skip" forState:UIControlStateNormal];
}


- (void)populateData {
    for(WalkThroughView *view in self.walkThroughScroll.subviews) {
        [view removeFromSuperview];
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.walkThroughScroll.contentSize = CGSizeMake(self.noOfTutorialPages*screenRect.size.width, screenRect.size.height-100);
    for (int i = 0; i < self.noOfTutorialPages; i++) {
        WalkThroughView * walkThrough = [[[NSBundle mainBundle] loadNibNamed:@"WalkThroughView" owner:self options:nil] objectAtIndex:0];
        walkThrough.frame = CGRectMake(screenRect.size.width*i, 0, screenRect.size.width,self.walkThroughScroll.frame.size.height);
        [self.walkThroughScroll addSubview:walkThrough];
        switch (i) {
            case 0:
                walkThrough.tutorialImage.image=[UIImage imageNamed:@"demo1"];
                break;
            case 1:
                walkThrough.tutorialImage.image=[UIImage imageNamed:@"demo2"];
                break;
            case 2:
                walkThrough.tutorialImage.image=[UIImage imageNamed:@"demo3"];
                break;
                       default:
                break;
        }
        
    }
}

#pragma mark - View Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self populateData];
    [self.view bringSubviewToFront:self.pageControl];
}


#pragma mark - UIButton Action

- (void)pageControllerAction:(UIPageControl *)pageControl {
    CGRect frame = self.walkThroughScroll.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [self.walkThroughScroll scrollRectToVisible:frame animated:YES];
}

- (IBAction)skipButtonAction:(id)sender {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isWalkthroughVisited];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:DirectoryShowHome object:nil];
}

#pragma mark - UIScrol View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.walkThroughScroll.frame.size.width;
    float fractionalPage = self.walkThroughScroll.contentOffset.x / pageWidth;
    NSInteger Oripage = lround(fractionalPage);
    self.pageControl.currentPage = Oripage;
    self.previuosIndex = (int)Oripage;
    if(Oripage == (self.noOfTutorialPages - 1))
        [self.bottomButton setTitle:@"Done" forState:UIControlStateNormal];
    else{
        [self.bottomButton setTitle:@"Skip" forState:UIControlStateNormal];
        }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
