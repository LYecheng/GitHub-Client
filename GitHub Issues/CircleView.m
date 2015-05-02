//
//  CircleView.m
//  GitHub Issues
//
//  Created by Yecheng Li on 02/02/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

// Reference: discussed with classmate Chen Xu and Yifan Xiao

#import "CircleView.h"

@implementation CircleView

#define PI 3.14159265359

// Calculate radians based on degree
static inline float radians(double degrees) {
    return degrees * PI / 180;
}

- (void)drawRect:(CGRect)rect
{
    // Set bounds and x, y corrdinates
    CGRect parentViewBounds = self.bounds;
    CGFloat x = CGRectGetWidth(parentViewBounds) / 2;
    CGFloat y = CGRectGetHeight(parentViewBounds) * 0.4;
    
    // Get graph context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Set line width
    CGContextSetLineWidth(ctx, 0.5);
    
    // Draw a red hollow circle - open issue
    float openDegree = self.open / (float)(self.open + self.closed) * 360;
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:0.969 green:0.506 blue:0.624 alpha:1] CGColor]));
    CGContextMoveToPoint(ctx, x, y);
    CGContextAddArc(ctx, x, y, 100, radians(0), radians(openDegree), 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    // Draw a green hollow circle - closed issue
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:0.004 green:0.875 blue:0.647 alpha:1] CGColor]));
    CGContextMoveToPoint(ctx, x, y);
    CGContextAddArc(ctx, x, y, 100, radians(openDegree) , radians(360), 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

@end
