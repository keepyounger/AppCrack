//
//  UINavigationController+xyHook.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/8.
//
//

#import "UINavigationController+xyHook.h"

void injected_function(void);

@implementation UINavigationController (xyHook)

+ (void)load
{
    [UINavigationController jr_swizzleMethod:@selector(pushViewController:animated:) withMethod:@selector(xy_pushViewController:animated:) error:nil];
}

- (void)xy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self xy_pushViewController:viewController animated:animated];
}

@end

@implementation UIViewController (xyHook)

+ (void)load
{
    [UIViewController jr_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(xy_viewDidAppear:) error:nil];
    [UIViewController jr_swizzleMethod:@selector(viewWillDisappear:) withMethod:@selector(xy_viewWillDisappear:) error:nil];
    [UIViewController jr_swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(xy_viewWillAppear:) error:nil];
}

- (void)xy_viewDidAppear:(BOOL)animated
{
    [self xy_viewDidAppear:animated];
}

- (void)xy_viewWillDisappear:(BOOL)animated
{
    [self xy_viewWillDisappear:animated];
}

- (void)xy_viewWillAppear:(BOOL)animated
{
    [self xy_viewWillAppear:animated];
}

@end
