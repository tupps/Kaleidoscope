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

    CAReplicatorLayer *hexDownReplicator;
    CAReplicatorLayer *hexRightReplicator1;
    CAReplicatorLayer *hexRightReplicator2;
}

@end

@implementation tppViewController

static const CGFloat triangleWidth = 50.0;
static const CGFloat triangleHeight = triangleWidth * 0.866025;

static const CGFloat numberOfHexagonsAcross = 5.0;
static const CGFloat numberOfHexagonsDown = 7.0;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createImage];
    [self createTriangleImageMask];
    [self createOneThirdOfHexagon];
    [self completeHexagon];

    //Just display the single Kaleidscope hexagon
    [self.view.layer addSublayer:hexReplication2];

    //Call these if you want the screen covered in the Kaleidscope effect
//    [self replicateHexagonsDown];
//    [self replicateDownHexagonsRight];
//    [self replicateRightHexagonsRight];
//    [self.view.layer addSublayer:hexRightReplicator2]; full screen covered.


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

    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation2.duration = 10;
    animation2.additive = YES;
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    animation2.fromValue = [NSNumber numberWithDouble:0.0];
    animation2.toValue = [NSNumber numberWithDouble:M_PI];
    [imageContainer addAnimation:animation2 forKey:@"basicMovement"];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    hexReplication2.position = CGPointMake(triangleWidth, triangleHeight);

//    //uncomment this for full screen effect
//    hexRightReplicator2.frame = self.view.bounds;
}

#pragma mark - Image Setup

- (void)createImage {
    imageContainer = [CALayer layer];
    imageContainer.contents = (id)[UIImage imageNamed:@"album_cover.jpg"].CGImage;
    imageContainer.bounds = CGRectMake(0.0, 0.0, 800.0, 800.0);  //Cheated, copied from image properties
}

- (void)createTriangleImageMask {
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *imageMaskBezierPath = [UIBezierPath bezierPath];
    [imageMaskBezierPath moveToPoint:CGPointMake(0.0, triangleHeight)]; //Bottom Left
    [imageMaskBezierPath addLineToPoint:CGPointMake(triangleWidth / 2.0, 0.0)]; //Top Center
    [imageMaskBezierPath addLineToPoint:CGPointMake(triangleWidth, triangleHeight)]; //Bottom Right
    [imageMaskBezierPath closePath];

    [maskLayer setPath:imageMaskBezierPath.CGPath];
    [maskLayer setFillColor:[[UIColor whiteColor] CGColor]];


    imageMask = [CALayer layer];
    imageMask.bounds = CGRectMake(0.0, 0.0, triangleWidth, triangleHeight);
    [imageMask addSublayer:imageContainer];
    imageMask.mask = maskLayer;
}

- (void)createOneThirdOfHexagon {
    hexReplication1 = [CAReplicatorLayer layer];
    hexReplication1.bounds = CGRectMake(0.0, 0.0, triangleWidth * 2.0, triangleHeight * 2.0);
    hexReplication1.instanceCount = 2;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, M_PI, 0.0, 1.0, 0.0);
    transform = CATransform3DRotate(transform, 60 * M_PI / 180, 0.0, 0.0, 1.0);
    hexReplication1.instanceTransform = transform;
    [hexReplication1 addSublayer:imageMask];
    imageMask.position = CGPointMake(triangleWidth, triangleHeight * 1.5);
}

- (void)completeHexagon {
    hexReplication2 = [CAReplicatorLayer layer];
    hexReplication2.bounds = CGRectMake(0.0, 0.0, triangleWidth * 2.0, triangleHeight * 2.0);
    hexReplication2.instanceCount = 3;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, 120 * M_PI / 180, 0.0, 0.0, 1.0);
    hexReplication2.instanceTransform = transform;
    [hexReplication2 addSublayer:hexReplication1];
    hexReplication1.position = CGPointMake(triangleWidth, triangleHeight);
}

- (void)replicateHexagonsDown {
    hexDownReplicator = [CAReplicatorLayer layer];
    hexDownReplicator.bounds = CGRectMake(0.0, 0.0, triangleWidth * 2.0, triangleHeight * 2.0 * numberOfHexagonsDown);
    hexDownReplicator.instanceCount = numberOfHexagonsDown;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0.0, triangleHeight * 2.0, 0.0);
    hexDownReplicator.instanceTransform = transform;
    [hexDownReplicator addSublayer:hexReplication2];
    hexDownReplicator.position = CGPointMake(triangleWidth, triangleHeight);
}

- (void) replicateDownHexagonsRight {
    hexRightReplicator1 = [CAReplicatorLayer layer];
    NSInteger numberOfRows = ceil(numberOfHexagonsAcross / 2.0);
    hexRightReplicator1.bounds = CGRectMake(0.0, 0.0, triangleWidth * 3.0 * numberOfRows, triangleHeight * 2.0 * numberOfHexagonsDown);
    hexRightReplicator1.instanceCount = numberOfRows;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, triangleWidth * 3.0, 0.0, 0.0);
    hexRightReplicator1.instanceTransform = transform;
    [hexRightReplicator1 addSublayer:hexDownReplicator];
    hexDownReplicator.position = CGPointMake(triangleWidth, triangleHeight * 2.0 * numberOfHexagonsDown / 2.0);
}

- (void) replicateRightHexagonsRight {
    hexRightReplicator2 = [CAReplicatorLayer layer];
    NSInteger numberOfRows = floor(numberOfHexagonsAcross / 2.0);
    hexRightReplicator2.bounds = CGRectMake(0.0, 0.0, triangleWidth * 3.0 * numberOfRows, triangleHeight * 2.0 * numberOfHexagonsDown);
    hexRightReplicator2.instanceCount = numberOfRows;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, triangleWidth * 1.5, triangleHeight, 0.0);
    hexRightReplicator2.instanceTransform = transform;
    [hexRightReplicator2 addSublayer:hexRightReplicator1];
    hexRightReplicator1.position = CGPointMake(triangleWidth * 3.0 * numberOfRows / 2.0, triangleHeight * 2.0 * numberOfHexagonsDown / 2.0);
}


@end
