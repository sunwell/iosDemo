//
//  CoreAnimationViewController.m
//  CoreAnimationDemo
//
//  Created by iosdevlope on 2017/5/25.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "CoreAnimationViewController.h"
#import "GS_RotationGuestreRecognizer.h"

@interface CoreAnimationViewController ()
@property (nonatomic, strong) UIView *smallView;
@property (nonatomic, strong) UIButton *animateButton;
@property (nonatomic, strong) NSMutableDictionary *pointsDic;
//@property (nonatomic, assign) CGRect fatherFrame;

@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, strong) UIButton *scaleButton;
@property (nonatomic, strong) UIButton *rotaButton;
@end

@implementation CoreAnimationViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.smallView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 200, 44)];
    self.smallView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.smallView];
    
    [self.smallView addSubview:self.delButton];
    [self.smallView addSubview:self.scaleButton];
    [self.smallView addSubview:self.rotaButton];
    
    
    [self checkView:self.smallView transform:self.smallView.transform isFirstTime:YES];
    
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.smallView addGestureRecognizer:pan];
    

    GS_RotationGuestreRecognizer *scaleGesture = [[GS_RotationGuestreRecognizer alloc] initWithTarget:self action:@selector(xsHandle:)];
    scaleGesture.effectView = self.smallView;
    scaleGesture.isZoom = YES;
    [self.scaleButton addGestureRecognizer:scaleGesture];

    
    GS_RotationGuestreRecognizer *rotateGesture = [[GS_RotationGuestreRecognizer alloc] initWithTarget:self action:@selector(xsHandle:)];
    rotateGesture.effectView = self.smallView;
    rotateGesture.isZoom = NO;
    [self.rotaButton addGestureRecognizer:rotateGesture];
    
    self.animateButton = [[UIButton alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height-100, 44, 44)];
    self.animateButton.backgroundColor = [UIColor redColor];
    [self.animateButton addTarget:self action:@selector(handleAnimate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.animateButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle GestureRecognizer

/**
 移动处理函数

 @param pan 移动手势
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        CGPoint touch = [pan translationInView:self.view];
        
        self.smallView.transform = CGAffineTransformTranslate(self.smallView.transform, touch.x, touch.y);
        [pan setTranslation:CGPointZero inView:self.smallView];
    }
}


/**
 缩放处理函数

 @param pinch 缩放手势
 */
- (void)handlePinchGesture:(GS_RotationGuestreRecognizer *)pinch {
    
    self.smallView.transform = CGAffineTransformRotate(pinch.effectView.transform, pinch.rotation);
    
//    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
//        self.smallView.transform = CGAffineTransformScale(self.smallView.transform, pinch.scale, pinch.scale);
//        pinch.scale = 1;
//    }
}


/**
 旋转处理函数

 @param rotate 旋转手势
 */
- (void)handleRotateGesture:(GS_RotationGuestreRecognizer *)rotate {
    if (rotate.state == UIGestureRecognizerStateBegan || rotate.state == UIGestureRecognizerStateChanged) {
        self.smallView.transform = CGAffineTransformRotate(self.smallView.transform, rotate.rotation);
        [rotate setRotation:0];
    }
}


-(void)xsHandle:(GS_RotationGuestreRecognizer *)recognizer {
    
    
//    if (_isRotateZoom) {
        recognizer.effectView.transform = CGAffineTransformRotate(recognizer.effectView.transform, recognizer.rotation);
        recognizer.rotation = 0;
        //设置缩放为yes后可以缩放这个视图
        if (recognizer.isZoom) {
            recognizer.effectView.transform = CGAffineTransformScale(recognizer.effectView.transform, recognizer.scale, recognizer.scale);
        }
        
//    }
}


#pragma mark - event response
- (void)handleDelAction:(UIButton *)sender {
    
}

- (void)handleAnimate:(UIButton *)sender {
    [UIView animateWithDuration:1 animations:^{
        self.smallView.transform = CGAffineTransformTranslate(self.smallView.transform, 100, 100);
    }];
}


#pragma mark - private method
- (void)checkView:(UIView *)view
        transform:(CGAffineTransform)trans
      isFirstTime:(BOOL)isFirstTime {
    
    if (!self.pointsDic) {
        self.pointsDic = [NSMutableDictionary dictionary];
    }
    
    
    CGPoint topleft = CGPointZero;
    CGPoint topright = CGPointZero;
    CGPoint bottomleft = CGPointZero;
    CGPoint bottomright = CGPointZero;
    if (isFirstTime) {
        
        topleft = view.frame.origin;
        topright = CGPointMake(view.frame.origin.x+view.frame.size.width, view.frame.origin.y);
        bottomleft = CGPointMake(view.frame.origin.x, view.frame.origin.y+view.frame.size.height);
        bottomright = CGPointMake(view.frame.origin.x+view.frame.size.width, view.frame.origin.y+view.frame.size.height);
        
        [self.pointsDic setValue:NSStringFromCGPoint(topleft) forKey:@"topleft"];
        [self.pointsDic setValue:NSStringFromCGPoint(topright) forKey:@"topright"];
        [self.pointsDic setValue:NSStringFromCGPoint(bottomleft) forKey:@"bottomleft"];
        [self.pointsDic setValue:NSStringFromCGPoint(bottomright) forKey:@"bottomright"];
    } else {
        
        topleft = view.frame.origin;
        topright = CGPointApplyAffineTransform(CGPointFromString([self.pointsDic valueForKey:@"topright"]), trans);
        bottomleft = CGPointApplyAffineTransform(CGPointFromString([self.pointsDic valueForKey:@"bottomleft"]), trans);
        bottomright = CGPointApplyAffineTransform(CGPointFromString([self.pointsDic valueForKey:@"bottomright"]), trans);
        
        [self.pointsDic setValue:NSStringFromCGPoint(topleft) forKey:@"topleft"];
        [self.pointsDic setValue:NSStringFromCGPoint(topright) forKey:@"topright"];
        [self.pointsDic setValue:NSStringFromCGPoint(bottomleft) forKey:@"bottomleft"];
        [self.pointsDic setValue:NSStringFromCGPoint(bottomright) forKey:@"bottomright"];
    }
    
    
    if (topleft.x < 10) {
        topleft.x = 11;
        self.smallView.frame = CGRectMake(topleft.x, topleft.y, view.bounds.size.width, view.bounds.size.height);
        return ;
    }
    
    if (topleft.y < 10+64) {
        topleft.y = 11+64;
        self.smallView.frame = CGRectMake(topleft.x, topleft.y, view.bounds.size.width, view.bounds.size.height);
        return ;
    }
    
    if (topright.x > [view superview].bounds.size.width-10) {
        topright.x = [view superview].bounds.size.width-10;
        self.smallView.frame = CGRectMake(topright.x, topright.y, view.bounds.size.width, view.bounds.size.height);
        return ;
    }
    
    if (topright.y < 10) {
        topright.y = 10;
        self.smallView.frame = CGRectMake(topright.x, topright.y, view.bounds.size.width, view.bounds.size.height);
        return ;
    }
    
    if (bottomleft.x < 10) {
        bottomleft.x = 10;
        self.smallView.frame = CGRectMake(bottomleft.x, bottomleft.y, view.bounds.size.width, view.bounds.size.height);
        return ;
    }
    
    if (bottomleft.y > [view superview].bounds.size.height-10) {
        self.smallView.frame = CGRectMake(bottomleft.x, bottomleft.y, view.bounds.size.width, view.bounds.size.height);
        bottomleft.y = [view superview].bounds.size.height-10;
        return ;
    }
    
    if (bottomright.x > [view superview].bounds.size.width-10) {
        self.smallView.frame = CGRectMake(bottomright.x, bottomright.y, view.bounds.size.width, view.bounds.size.height);
        bottomright.x = [view superview].bounds.size.width-10;
        return ;
    }
    
    if (bottomright.y > [view superview].bounds.size.height-10) {
        self.smallView.frame = CGRectMake(bottomright.x, bottomright.y, view.bounds.size.width, view.bounds.size.height);
        bottomright.y = [view superview].bounds.size.height-10;
        return ;
    }
}



#pragma mark - getter & setter
- (UIButton *)delButton {
    if (!_delButton) {
        _delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
        [_delButton setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [_delButton addTarget:self action:@selector(handleDelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delButton;
}

- (UIButton *)scaleButton {
    if (!_scaleButton) {
        _scaleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.smallView.bounds.size.width, 0, 21, 21)];
        [_scaleButton setImage:[UIImage imageNamed:@"scale"] forState:UIControlStateNormal];
    }
    return _scaleButton;
}

- (UIButton *)rotaButton {
    if (!_rotaButton) {
        _rotaButton = [[UIButton alloc] initWithFrame:CGRectMake(self.smallView.bounds.size.width, self.smallView.bounds.size.height, 21, 21)];
        [_rotaButton setImage:[UIImage imageNamed:@"edit_rotateZoom"] forState:UIControlStateNormal];
    }
    return _rotaButton;
}
@end
