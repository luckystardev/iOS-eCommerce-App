//
//  FMBThemeManager.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBThemeManager.h"
#import "UIImage+BlurredFrame.h"
#import "UIImage+ResizeAdditions.h"
#import "FMBBackgroundSetting.h"

@implementation FMBThemeManager

// ----------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBThemeManager) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Theme Init Functions
+ (void)initAppTheme
{
    [self printLogWith:@"initAppTheme"];
    
    //    [self initNavigationBarTheme];
    //[self initToolbarTheme];
}

+ (void)initNavigationBarTheme
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [UINavigationBar appearance].shadowImage = [UIImage new];
    [UINavigationBar appearance].translucent = YES;
    
    [UIFont fontWithName:@"HelveticaNeueu-Bold" size:18];
    
    NSDictionary *titleTextAttributes = @{
                                          NSForegroundColorAttributeName: RGBHEX(0xffffff, 1.f),
                                          NSFontAttributeName: COMMON_FONT_FOR_PAGE_TITLE};
    
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
}

+ (void)initToolbarTheme
{
    [[UIToolbar appearance] setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    
    [UIToolbar appearance].translucent = YES;
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Image Blur Functions
+ (UIImage *)snapshotImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return res;
}

+ (UIImage *)snapshotImageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return res;
}

+ (UIImage *)snapshotImageFromVC:(UIViewController *)vc
{
    UIImage *res;
    
    //    if ([vc isKindOfClass:[UITableViewController class]])
    //    {
    //        UIImage *image1 = [self snapshotImageFromView:vc.navigationController.view];
    //        UIImage *image2 = [self snapshotImageFromView:[(UITableViewController *)vc tableView].superview];
    //
    //        UIGraphicsBeginImageContextWithOptions(vc.navigationController.view.bounds.size, NO, res.scale);
    //
    //        [image1 drawAtPoint:CGPointMake(0, 0)];
    //        [image2 drawAtPoint:CGPointMake(0, 0)];
    //
    //        res = UIGraphicsGetImageFromCurrentImageContext();
    //
    //        UIGraphicsEndImageContext();
    //    }
    //    else
    //    {
    //        res = [self snapshotImageFromView:vc.view];
    //    }
    
    res = [self snapshotImageFromView:vc.navigationController.view];
    
    return res;
}

+ (UIImage *)blurImageCopiedFromVC:(UIViewController *)vc
{
    // Get snapshot image of view
    UIImage *originalImage = [self snapshotImageFromVC:vc];
    
    CGRect     toFrame = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    UIColor *tintColor = RGBHEX(0x282880, .2f);
    UIImage       *res = [originalImage applyBlurWithRadius:5 iterationsCount:3
                                                  tintColor:tintColor saturationDeltaFactor:1.8
                                                  maskImage:nil atFrame:toFrame];
    return res;
}

+ (UIImage *)blurImageForMainPagesFromImage:(UIImage *)originalImage atFrame:(CGRect)frame
{
    CGRect     toFrame = CGRectIsEmpty(frame) ? CGRectMake(0, 0, originalImage.size.width, originalImage.size.height) : frame;
    UIColor *tintColor = RGBHEX(0x000000, .3f); //0x282880
    UIImage       *res = [originalImage applyBlurWithRadius:3 iterationsCount:2
                                                  tintColor:tintColor saturationDeltaFactor:1.8
                                                  maskImage:nil atFrame:toFrame];
    return res;
}

// Main Page Image Function
+ (UIImage *)blurImageForMainPageByImage:(UIImage *)image
{
    return [self blurImageForMainPagesFromImage:image atFrame:CGRectZero];
}

+ (UIImage *)blurImageForMainPageNavigationBarByImage:(UIImage *)image
{
    UIImage *res = [self blurImageForMainPageByImage:image];
    res = [res croppedImage:CGRectMake(0, 0, res.size.width * 2, 128)];
    
    return res;
}

+ (UIImage *)blurImageForMainPageToolbarByImage:(UIImage *)image
{
    UIImage *res = [self blurImageForMainPageByImage:image];
    
    CGSize screenSize = [FMBUtil screenRect].size;
    
    res = [res croppedImage:CGRectMake(0, screenSize.height * 2 - 88.f, res.size.width * 2, 88.f)];
    
    return res;
}

+ (UIImage *)blurImageForMainPageNavigationBarWithPromptByImage:(UIImage *)image
{
    UIImage *res = [self blurImageForMainPageByImage:image];
    
    res = [res croppedImage:CGRectMake(0, 0, res.size.width * 2, 94 * 2)];
    
    return res;
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - NavigationBar, Toolbar Functions
+ (void)makeTransparentNavigationBar:(UINavigationBar *)navigationBar
{
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    navigationBar.shadowImage = [UIImage new];
    navigationBar.translucent = YES;
    
    NSDictionary *titleTextAttributes = @{
                                          NSForegroundColorAttributeName: RGBHEX(0xffffff, 1.f),
                                          NSFontAttributeName: COMMON_FONT_FOR_PAGE_TITLE};
    
    [navigationBar setTitleTextAttributes:titleTextAttributes];
}

+ (void)makeTransparentToolBar:(UIToolbar *)toolbar
{
    [toolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    
    toolbar.translucent = YES;
}

+ (void)makeTransparentSearchBar:(UISearchBar *)searchBar
{
    [searchBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    searchBar.translucent = YES;
}


// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Functions

// Functions of Adjusting Position, Size, etc
+ (void)setViewFrameWith:(UIView *)v X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)w Height:(CGFloat)h
{
    CGRect rect = v.frame;
    
    if (x != CGFLOAT_MAX)
        rect.origin.x = x;
    if (y != CGFLOAT_MAX)
        rect.origin.y = y;
    if (w != CGFLOAT_MAX)
        rect.size.width = w;
    if (h != CGFLOAT_MAX)
        rect.size.height = h;
    
    v.frame = rect;
}

+ (void)adjustViewHeight:(UIView *)view mainFrame:(CGRect)mainFrame
{
    if (CGRectIsEmpty(mainFrame))
    {
        mainFrame = [FMBUtil screenRect];
    }
    
    CGRect rect = view.frame;
    rect.size.height = mainFrame.size.height - rect.origin.y;
    [view setFrame:rect];
}

// Functions of Decorating Controls With Radius, Shadow, Border, etc
#pragma mark -
+ (void)setCornerRadiusToView:(UIView *)view Radius:(CGFloat)radius
{
    [view.layer setCornerRadius:radius];
}

+ (void)setBorderToView:(UIView *)view Width:(CGFloat)borderWidth Color:(UIColor *)borderColor Radius:(CGFloat)radius
{
    [view.layer setBorderColor:borderColor.CGColor];
    [view.layer setBorderWidth:borderWidth];
    
    if (radius != CGFLOAT_MAX)
    {
        [view.layer setCornerRadius:radius];
    }
}

+ (void)setBorderToView:(UIView *)view Width:(CGFloat)borderWidth Color:(UIColor *)borderColor Radius:(CGFloat)radius showShadow:(BOOL)bShowShadow
{
    [view.layer setBorderColor:borderColor.CGColor];
    [view.layer setBorderWidth:borderWidth];
    
    if (radius != CGFLOAT_MAX)
    {
        [view.layer setCornerRadius:radius];
    }
    
    if (bShowShadow)
    {
        [self setShadowToView:view cornerRadius:(radius == CGFLOAT_MAX ? 0 : radius )];
    }
}

+ (void)setShadowToView:(UIView *)view cornerRadius:(CGFloat)cornerRadius
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    view.layer.shadowOpacity = 0.5f;
    view.layer.cornerRadius = cornerRadius;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:cornerRadius];
    view.layer.shadowPath = shadowPath.CGPath;
}

+ (void)setBorderToView:(UIView *)view width:(CGFloat)width Color:(UIColor *)color
{
    [view.layer setBorderWidth:width];
    [view.layer setBorderColor:color.CGColor];
}

+ (void)decorateButton:(UIButton *)button
{
    [self setBorderToView:button Width:1.f Color:RGBHEX(0xffffff, 1.f) Radius:3.f];
    
    [button setTitleColor:RGBHEX(0x000000, 1.f) forState:UIControlStateNormal];
}

+ (void)decorateButton3:(UIButton *)button
{
    button.backgroundColor = RGBHEX(0xdf0000, 1.f);
    
    [self setBorderToView:button Width:COMMON_WIDTH_FOR_BORDER Color:COMMON_COLOR_FOR_BORDER Radius:COMMON_RADIUS];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

+ (void)decorateTextFieldContainer:(UIView *)view
{
    view.backgroundColor = [UIColor whiteColor];
    [self setBorderToView:view Width:COMMON_WIDTH_FOR_BORDER Color:COMMON_COLOR_FOR_BORDER Radius:CGFLOAT_MAX];
}

+ (void)decorateInputAccessoryViewBarButton:(UIBarButtonItem *)button textColor:(UIColor *)textColor
{
    
    textColor = textColor == nil ? COMMON_COLOR_FOR_BUTTON_TITLE : textColor;
    
    NSDictionary *titleTextAttributes = @{
                                          NSForegroundColorAttributeName: textColor,
                                          };
    
    [button setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
}

+ (void)decorateInputAccessoryViewBarButton:(UIBarButtonItem *)button withSelector:(SEL)selector
{
    UIColor *disabledColor = [UIColor lightGrayColor];
    if (selector == nil)
    {
        [self decorateInputAccessoryViewBarButton:button textColor:disabledColor];
        button.enabled = NO;
    }
    else
        [self decorateInputAccessoryViewBarButton:button textColor:nil];
}

+ (void)setPlaceholder:(NSString*)string toTextField:(UITextField *)textField color:(UIColor *)color
{
    textField.attributedPlaceholder = [[NSAttributedString alloc]
                                       initWithString:string
                                       attributes:@{NSForegroundColorAttributeName: color}];
}

+ (void)makeCircleWithView:(UIView *)view
{
    view.layer.masksToBounds = YES;
    [view.layer setCornerRadius:view.frame.size.width/2.f];
}

+ (void)makeCircleWithView:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    [self makeCircleWithView:view];
    
    if (borderColor)
    {
        CGFloat w = borderWidth == CGFLOAT_MAX ? 1 : borderWidth;
        [self setBorderToView:view width:w Color:borderColor];
    }
}

+ (void)removeHeaderSpaceInTableView:(UITableView *)tableView
{
    CGRect frame       = tableView.tableHeaderView.frame;
    frame.size.height  = 1;
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    
    [tableView setTableHeaderView:headerView];
}

// TableViewCell ContentView Background
+ (void)decorateEvenOddStyleForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath cellColor:(UIColor *)cellColor
{
    if (indexPath.row % 2 == 0)
    {
        cell.contentView.backgroundColor = cellColor;
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Background Functions
+ (PFImageView *)createBackgroundImageViewForVC:(UIViewController *)vc withBottomBar:(UIToolbar *)toolbar
{
    [self makeTransparentNavigationBar:vc.navigationController.navigationBar];
    
    if (toolbar)
    {
        [self makeTransparentToolBar:toolbar];
    }
    
    PFImageView *imageviewBackground;
    imageviewBackground = [[PFImageView alloc] initWithFrame:[FMBUtil screenRect]];
    [vc.view addSubview:imageviewBackground];
    [vc.view sendSubviewToBack:imageviewBackground];
    
    return imageviewBackground;
}

+ (PFImageView *)createBackgroundImageViewForTableVC:(UITableViewController *)vc withBottomBar:(UIToolbar *)toolbar
{
    [self makeTransparentNavigationBar:vc.navigationController.navigationBar];
    
    if (toolbar)
    {
        [self makeTransparentToolBar:toolbar];
    }
    
    PFImageView *imageviewBackground;
    imageviewBackground = [[PFImageView alloc] initWithFrame:[FMBUtil screenRect]];
    
    if (vc.navigationController)
    {
        [vc.navigationController.view insertSubview:imageviewBackground belowSubview:vc.view];
        [vc.navigationController.view sendSubviewToBack:imageviewBackground];
    }
    else
    {
        vc.tableView.backgroundView = imageviewBackground;
    }
    vc.tableView.backgroundColor = [UIColor clearColor];
    
    return imageviewBackground;
}

+ (PFImageView *)createBackgroundImageViewForMessageVC:(JSQMessagesViewController *)vc
{
    [self makeTransparentNavigationBar:vc.navigationController.navigationBar];
    
    PFImageView *imageviewBackground;
    imageviewBackground = [[PFImageView alloc] initWithFrame:[FMBUtil screenRect]];
    
    if (vc.navigationController)
    {
        [vc.navigationController.view insertSubview:imageviewBackground belowSubview:vc.view];
        [vc.navigationController.view sendSubviewToBack:imageviewBackground];
    }
    
    vc.collectionView.backgroundColor = [UIColor clearColor];
    vc.view.backgroundColor           = [UIColor clearColor];
    vc.collectionView.clipsToBounds   = YES;
    
    return imageviewBackground;
}

+ (void)setBackgroundImageForName:(NSString *)backgroundName toImageView:(UIImageView *)imageview
{
    UIImage *blurredImage = [[FMBBackgroundSetting sharedInstance] blurImageForBackgroundName:backgroundName];
    imageview.image = blurredImage;
}

+ (void)setBackgroundImageForName:(NSString *)backgroundName toNavigationBar:(UINavigationBar *)navBar withPrompt:(BOOL)bPrompt
{
    UIImage *image = [[FMBBackgroundSetting sharedInstance] blurImageForBackgroundName:backgroundName];
    
    if (bPrompt)
    {
        image = [image croppedImage:CGRectMake(0, 0, image.size.width * 2, 94 * 2)];
    }
    else
    {
        image = [image croppedImage:CGRectMake(0, 0, image.size.width * 2, 128)];
    }
    
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

+ (void)relayoutTableviewForApp:(UITableView *)tableview
{
    CGRect screenRect = [FMBUtil screenRect];
    CGFloat offsetTop = 65;
    
    tableview.frame     = CGRectMake(0, offsetTop, CGRectGetWidth(screenRect), CGRectGetHeight(screenRect) - offsetTop);
    
    UIEdgeInsets insets = tableview.contentInset;
    insets.top = 0;
    tableview.contentInset = insets;
}

@end
