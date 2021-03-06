//
//  GSAnimateView.m
//  CoreAnimationDemo
//
//  Created by iosdevlope on 2017/6/7.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "GSAnimateView.h"
#import "GS_RotationGuestreRecognizer.h"


@interface GSAnimateView ()
@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, strong) UIButton *scaleButton;
@property (nonatomic, strong) UIButton *rotaButton;

@property (nonatomic, assign) BOOL isRotateZoom;
@property (nonatomic, strong) NSMutableDictionary *pointsDic;
@property (nonatomic, assign) CGAffineTransform lastTransform;  //上一次的形变量
//@property (nonatomic, assign) CGAffineTransform initTransform;  //初始的位移变化
@end

@implementation GSAnimateView
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.delButton];
        [self addSubview:self.scaleButton];
        [self addSubview:self.rotaButton];
        
//        self.initTransform = CGAffineTransformMakeTranslation(self.frame.origin.x, self.frame.origin.y);
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGesture];
        
        
        GS_RotationGuestreRecognizer *scaleGesture = [[GS_RotationGuestreRecognizer alloc] initWithTarget:self action:@selector(xsHandle:)];
        scaleGesture.effectView = self;
        scaleGesture.isZoom = YES;
        [self.scaleButton addGestureRecognizer:scaleGesture];
        
        
        GS_RotationGuestreRecognizer *rotateGesture = [[GS_RotationGuestreRecognizer alloc] initWithTarget:self action:@selector(xsHandle:)];
        rotateGesture.effectView = self;
        rotateGesture.isZoom = NO;
        [self.rotaButton addGestureRecognizer:rotateGesture];
        
        [self checkView:self transform:self.transform isFirstTime:YES];
        
        return self;
    }
    return nil;
}

#pragma mark - overide
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    
    CGPoint rotateP = [self convertPoint:point toView:self.rotaButton];
    CGPoint scaleP = [self convertPoint:point toView:self.scaleButton];
    
    if ([self.rotaButton pointInside:rotateP withEvent:event]) {
        _isRotateZoom = YES;
        return self.rotaButton;
    } else {
        _isRotateZoom = false;
    }
    
    if ([self.scaleButton pointInside:scaleP withEvent:event]) {
        _isRotateZoom = YES;
        return self.scaleButton;
    } else {
        _isRotateZoom = false;
    }
    
    CGPoint deleteP = [self convertPoint:point toView:self.delButton];
    if ([self.delButton pointInside:deleteP withEvent:event]) {
        return self.delButton;
    }
    
    return [super hitTest:point withEvent:event];
}

#pragma mark - handle gesture
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        CGPoint touch = [pan translationInView:self];
        self.transform = CGAffineTransformTranslate(self.transform, touch.x, touch.y);
        [pan setTranslation:CGPointZero inView:self];
        [self checkView:self transform:self.transform isFirstTime:NO];
    }
}

-(void)xsHandle:(GS_RotationGuestreRecognizer *)recognizer {
    
    if (recognizer.isZoom) {
        //缩放
        self.transform = CGAffineTransformScale(self.transform, recognizer.scale, recognizer.scale);
    } else {
        //旋转
        self.transform = CGAffineTransformRotate(self.transform, recognizer.rotation);
    }
    [self checkView:self transform:self.transform isFirstTime:NO];
}

#pragma mark - event response
- (void)handleDelAction:(UIButton *)sender {
    
}

#pragma mark - private method
- (void)checkView:(UIView *)view
        transform:(CGAffineTransform)trans
      isFirstTime:(BOOL)isFirstTime {
    
        
    CGPoint topleft = [self newTopLeft];
    CGPoint topright = [self newTopRight];
    CGPoint bottomleft = [self newBottomLeft];
    CGPoint bottomright = [self newBottomRight];
    
//#warning 观察矩形四个角坐标的变化
//    UIView *topleftPoint = nil;
//    if (!(topleftPoint = [self.superview viewWithTag:1111])) {
//        topleftPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
//        topleftPoint.tag = 1111;
//        topleftPoint.backgroundColor = [UIColor redColor];
//        [self.superview addSubview:topleftPoint];
//    }
//    topleftPoint.center = topleft;
//
//    UIView *toprightPoint = nil;
//    if (!(toprightPoint = [self.superview viewWithTag:2222])) {
//        toprightPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
//        toprightPoint.tag = 2222;
//        toprightPoint.backgroundColor = [UIColor redColor];
//        [self.superview addSubview:toprightPoint];
//    }
//    toprightPoint.center = topright;
//
//    UIView *bottomleftPoint = nil;
//    if (!(bottomleftPoint = [self.superview viewWithTag:3333])) {
//        bottomleftPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
//        bottomleftPoint.tag = 3333;
//        bottomleftPoint.backgroundColor = [UIColor redColor];
//        [self.superview addSubview:bottomleftPoint];
//    }
//    bottomleftPoint.center = bottomleft;
//
//    UIView *bottomrightPoint = nil;
//    if (!(bottomrightPoint = [self.superview viewWithTag:4444])) {
//        bottomrightPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
//        bottomrightPoint.tag = 4444;
//        bottomrightPoint.backgroundColor = [UIColor redColor];
//        [self.superview addSubview:bottomrightPoint];
//    }
//    bottomrightPoint.center = bottomright;
    

    if (topleft.x < 10 || topleft.y < 10+64) {
        self.transform = self.lastTransform;
        return ;
    } else if (topright.x > [UIScreen mainScreen].bounds.size.width-10 || topright.y < 10+64) {
        self.transform = self.lastTransform;
        return ;
    } else if (bottomleft.x < 10 || bottomleft.y > [UIScreen mainScreen].bounds.size.height-10) {
        self.transform = self.lastTransform;
        return ;
    } else if (bottomright.x > [UIScreen mainScreen].bounds.size.width - 10 || bottomright.y > [UIScreen mainScreen].bounds.size.height-10) {
        self.transform = self.lastTransform;
        return ;
    }
    
    self.lastTransform = trans;
}


// helper to get pre transform frame
-(CGRect)originalFrame {
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    CGRect originalFrame = self.frame;
    self.transform = currentTransform;
    
    return originalFrame;
}

// helper to get point offset from center
-(CGPoint)centerOffset:(CGPoint)thePoint {
    return CGPointMake(thePoint.x - self.center.x, thePoint.y - self.center.y);
}
// helper to get point back relative to center
-(CGPoint)pointRelativeToCenter:(CGPoint)thePoint {
    return CGPointMake(thePoint.x + self.center.x, thePoint.y + self.center.y);
}
// helper to get point relative to transformed coords
-(CGPoint)newPointInView:(CGPoint)thePoint {
    // get offset from center
    CGPoint offset = [self centerOffset:thePoint];
    // get transformed point
    CGPoint transformedPoint = CGPointApplyAffineTransform(offset, self.transform);
    // make relative to center
    return [self pointRelativeToCenter:transformedPoint];
}

// now get your corners
-(CGPoint)newTopLeft {
    CGRect frame = [self originalFrame];
    return [self newPointInView:frame.origin];
}
-(CGPoint)newTopRight {
    CGRect frame = [self originalFrame];
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    return [self newPointInView:point];
}
-(CGPoint)newBottomLeft {
    CGRect frame = [self originalFrame];
    CGPoint point = frame.origin;
    point.y += frame.size.height;
    return [self newPointInView:point];
}
-(CGPoint)newBottomRight {
    CGRect frame = [self originalFrame];
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    point.y += frame.size.height;
    return [self newPointInView:point];
}


#pragma mark - getter & setter
- (UIButton *)delButton {
    if (!_delButton) {
        _delButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, -20, 40, 40)];
        [_delButton setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [_delButton addTarget:self action:@selector(handleDelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delButton;
}

- (UIButton *)scaleButton {
    if (!_scaleButton) {
        _scaleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-20, -20, 40, 40)];
        [_scaleButton setImage:[UIImage imageNamed:@"scale"] forState:UIControlStateNormal];
    }
    return _scaleButton;
}

- (UIButton *)rotaButton {
    if (!_rotaButton) {
        _rotaButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-20, self.bounds.size.height-20, 40, 40)];
        [_rotaButton setImage:[UIImage imageNamed:@"edit_rotateZoom"] forState:UIControlStateNormal];
    }
    return _rotaButton;
}
@end
