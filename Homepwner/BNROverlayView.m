//
//  BNROverlayView.m
//  Homepwner
//
//  Created by WaterWood on 14-5-17.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNROverlayView.h"

@implementation BNROverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.layer.opaque = NO;
    }
    return self;
}

/**
 *  Add a big red X to the camera view
 */
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    [path moveToPoint: CGPointMake(w/2-100, h/2)];
    [path addLineToPoint:CGPointMake(w/2+100, h/2)];
    [path moveToPoint:CGPointMake(w/2, h/2-100)];
    [path addLineToPoint:CGPointMake(w/2, h/2+100)];
    [[UIColor redColor] setStroke];
    path.lineWidth = 10;
    [path stroke];
}

@end
