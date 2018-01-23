//
//  TPFavoriteVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/23.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPFavoriteVCL.h"
#import "JCPageContoller.h"
#import "TPFavoriteModel.h"
#import "TPBarItem.h"
#import "TPProjectListVCL.h"
#import "TPClientVCL.h"
@interface TPFavoriteVCL ()<JCPageContollerDataSource, JCPageContollerDelegate>
@property (nonatomic, strong) TPFavoriteModel *model;
@property (nonatomic, strong) JCPageContoller *pageController;
@end

@implementation TPFavoriteVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [TPFavoriteModel new];
    CGRect rect = self.view.bounds;
    rect.origin.y = 64;
    rect.size.height = rect.size.height - 64;
    self.pageController.view.frame = rect;
    
    [self addNaviBar];
    [self loadItems];
    
    // Do any additional setup after loading the view.
}


- (void)loadItems{
    if (!self.model.items || self.model.items.count < 1) {
        [self showLoading];
        [self hideNoDataView];
    }
    __weak typeof(self) instance = self;
    [self.model loadItems:nil completion:^(NSDictionary *suc) {
        [instance hideLoading];
        [instance hideNoDataView];
        if (instance.model.items.count < 1) {
            [instance showNoDataView];
        }
        [instance.pageController reloadData];
    } failure:^(NSError *error) {
        [instance hideLoading];
        [instance hideNoDataView];
    }];
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:@"收藏" enableBackButton:YES];
    [self.view addSubview:naviBar];
}

- (JCPageContoller *)pageController{
    if (!_pageController) {
        _pageController = [[JCPageContoller alloc]init];
        _pageController.delegate = self;
        _pageController.dataSource = self;
        _pageController.lineAinimationType = JCSlideBarLineAnimationFixedWidth;
        [self addChildViewController:_pageController];
        [self.view addSubview:_pageController.view];
    }
    return _pageController;
}

- (NSInteger)numberOfControllersInPageController{
    return self.model.items.count;
}

- (NSString *)reuseIdentifierForControllerAtIndex:(NSInteger)index;{
    TPBarItem *item = self.model.items[index];
    return item.identifier;
}

- (UIViewController *)pageContoller:(JCPageContoller *)pageContoller controllerAtIndex:(NSInteger)index{
    TPBarItem *item = self.model.items[index];
    UIViewController *controller = [pageContoller dequeueReusableControllerWithReuseIdentifier:item.identifier atIndex:index];
    if (!controller) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if ([item.identifier isEqualToString:@"project"]) {
            TPProjectListVCL *vcl = [mainStoryboard instantiateViewControllerWithIdentifier:@"TPProjectListVCL"];
            controller = vcl;
        }else if ([item.identifier isEqualToString:@"client"]) {
            TPClientVCL *vcl = [mainStoryboard instantiateViewControllerWithIdentifier:@"TPClientVCL"];
            controller = vcl;
        }
        
        CGRect rect = self.pageController.view.bounds;
        rect.origin.y = 40;//slideBar height
        rect.size.height = rect.size.height - rect.origin.y;
        controller.view.frame = rect;
    }
    [controller performSelector:@selector(reloadData:) withObject:item];
    return controller;
}

- (CGFloat)pageContoller:(JCPageContoller *)pageContoller widthForCellAtIndex:(NSInteger )index{
    TPBarItem *item = self.model.items[index];
    return item.width;
}

- (NSString *)pageContoller:(JCPageContoller *)pageContoller titleForCellAtIndex:(NSInteger)index{
    TPBarItem *item = self.model.items[index];
    return item.text;
}


@end
