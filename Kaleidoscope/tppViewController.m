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


    CALayer *debugLastLayer;
}



@end

@implementation tppViewController

static const CGFloat triangleWidth = 25.0;
static const CGFloat triangleHeight = triangleWidth * 0.866025;

static const CGFloat numberOfHexagonsAcross = 5.0;
static const CGFloat numberOfHexagonsDown = 7.0;

- (void)viewDidLoad {
    [super viewDidLoad];

    imageContainer = [CALayer layer];
    imageContainer.contents = (id)[UIImage imageNamed:@"album_cover.jpg"].CGImage;
    imageContainer.bounds = CGRectMake(0.0, 0.0, 350.0, 350.0); //Cheated, copied from image properties

    imageMask = [CALayer layer];
    imageMask.bounds = CGRectMake(0.0, 0.0, triangleWidth, triangleHeight);
    [imageMask addSublayer:imageContainer];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *imageMarkBezierPath = [UIBezierPath bezierPath];
    [imageMarkBezierPath moveToPoint:CGPointMake(0.0, triangleHeight)]; //Bottom Left
    [imageMarkBezierPath addLineToPoint:CGPointMake(triangleWidth / 2.0, 0.0)]; //Top Center
    [imageMarkBezierPath addLineToPoint:CGPointMake(triangleWidth, triangleHeight)]; //Bottom Right
    [imageMarkBezierPath closePath];

    [maskLayer setPath:imageMarkBezierPath.CGPath];
    [maskLayer setFillColor:[[UIColor whiteColor] CGColor]];

    imageMask.mask = maskLayer;

    [self.view.layer addSublayer:imageMask];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    imageMask.position = CGPointMake(100.0, 100.0);
}


@end
