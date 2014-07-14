//
//  tppViewController.m
//  Kaleidoscope
//
//  Created by Luke Tupper on 14/07/2014.
//  Copyright (c) 2014 Luke Tupper. All rights reserved.
//

#import "tppViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface tppViewController () {
    CALayer *imageContainer;
    CALayer *imageMask;

    CAReplicatorLayer *hexReplication1;
    CAReplicatorLayer *hexReplication2;
}



@end

@implementation tppViewController

static const CGFloat triangleWidth = 50.0;
static const CGFloat triangleHeight = triangleWidth * 0.866025;

static const CGFloat numberOfHexagonsAcross = 5.0;
static const CGFloat numberOfHexagonsDown = 7.0;

- (void)viewDidLoad {
    [super viewDidLoad];

    imageContainer = [CALayer layer];
    imageContainer.contents = (id)[UIImage imageNamed:@"album_cover.jpg"].CGImage;
    imageContainer.bounds = CGRectMake(0.0, 0.0, 350.0, 350.0); //Cheated, copied from image properties

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *imageMarkBezierPath = [UIBezierPath bezierPath];
    [imageMarkBezierPath moveToPoint:CGPointMake(0.0, triangleHeight)]; //Bottom Left
    [imageMarkBezierPath addLineToPoint:CGPointMake(triangleWidth / 2.0, 0.0)]; //Top Center
    [imageMarkBezierPath addLineToPoint:CGPointMake(triangleWidth, triangleHeight)]; //Bottom Right
    [imageMarkBezierPath closePath];

    [maskLayer setPath:imageMarkBezierPath.CGPath];
    [maskLayer setFillColor:[[UIColor whiteColor] CGColor]];


    imageMask = [CALayer layer];
    imageMask.bounds = CGRectMake(0.0, 0.0, triangleWidth, triangleHeight);
    [imageMask addSublayer:imageContainer];
    imageMask.mask = maskLayer;

    hexReplication1 = [CAReplicatorLayer layer];
    hexReplication1.bounds = CGRectMake(0.0, 0.0, triangleWidth * 2.0, triangleHeight * 2.0);
    hexReplication1.instanceCount = 2;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, M_PI, 0.0, 1.0, 0.0);
    transform = CATransform3DRotate(transform, 60 * M_PI / 180, 0.0, 0.0, 1.0);
    hexReplication1.instanceTransform = transform;
    [hexReplication1 addSublayer:imageMask];
    imageMask.position = CGPointMake(triangleWidth, triangleHeight * 1.5);

    hexReplication2 = [CAReplicatorLayer layer];
    hexReplication2.bounds = CGRectMake(0.0, 0.0, triangleWidth * 2.0, triangleHeight * 2.0);
    hexReplication2.instanceCount = 3;
    transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, 120 * M_PI / 180, 0.0, 0.0, 1.0);
    hexReplication2.instanceTransform = transform;
    [hexReplication2 addSublayer:hexReplication1];
    hexReplication1.position = CGPointMake(triangleWidth, triangleHeight);

    hexReplication2.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:hexReplication2];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 10;
    animation.additive = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 160.0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(160.0, 0.0)];
    [imageContainer addAnimation:animation forKey:@"basicMovement"];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    hexReplication2.position = CGPointMake(100.0, 100.0);
}


@end
