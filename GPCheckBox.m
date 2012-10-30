//
//  GPCheckBox.m
//
//  Created by Giancarlo Pacheco on 2012-10-28.
//  Copyright (c) 2012 Giancarlo Pacheco. All rights reserved.
//

#import "GPCheckBox.h"
#import <CoreGraphics/CoreGraphics.h>

static void linearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}

@implementation GPCheckBox

- (id)init {
    self = [super initWithFrame:CGRectMake(0.f, 0.f, 25.f, 25.f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.selected = !self.isSelected;
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGRect frame = CGRectInset(rect, 2.0, 2.0);
	//CGMutablePathRef path = createRoundedRectForRect(CGRectInset(rect, 2.0, 2.0), 4.f, RoundCornersAll);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 2.0, 2.0) cornerRadius:4.f];
    
    // Drop Shadow and Top Inner Glow
	CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.f, 1.f);
	CGContextAddPath(context, path.CGPath);
	
	CGContextSetLineWidth(context, 1.5f);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6].CGColor);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);
    
	// Gradient
	CGContextSaveGState(context);
    CGContextAddPath(context, path.CGPath);
	//CGContextAddRect(context, frame);
	CGContextClip(context);
    if (self.isSelected) {
        linearGradient(context, frame, [UIColor colorWithRed:199.0/255.0 green:210.0/255.0 blue:224.0/255.0 alpha:1.0].CGColor, [UIColor colorWithRed:151.0/255.0 green:171.0/255.0 blue:194.0/255.0 alpha:1.0].CGColor);
    }
    else {
        linearGradient(context, frame, [UIColor colorWithRed:249.0/255.0 green:248.0/255.0 blue:247.0/255.0 alpha:1.0].CGColor, [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0].CGColor);
    }
	CGContextRestoreGState(context);
	
	// Stroke
	CGContextSaveGState(context);
	CGContextAddPath(context, path.CGPath);
	CGContextSetLineWidth(context, 1.0);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.750].CGColor);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);
    
    if (self.isSelected) {
        [[self checkmarkImage] drawAtPoint:CGPointMake(0.f, 0.f)];
    }
}

- (UIImage *)checkmarkImage {
	CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef checkPath = CGPathCreateMutable();
    CGPathMoveToPoint(checkPath, NULL, rect.size.width * 0.325f, rect.size.height * 0.38f);
    CGPathAddLineToPoint(checkPath, NULL, rect.size.width * 0.54f, rect.size.height * 0.69f);
    CGPathAddLineToPoint(checkPath, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, checkPath);
    CGContextSetLineWidth(context, self.frame.size.width/8.f);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:55.0/255.0 green:59.0/255.0 blue:65.0/255.0 alpha:1.000].CGColor);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.f, self.frame.size.width/8.f);
    CGContextAddPath(context, checkPath);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1.0 alpha:0.6].CGColor);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGPathRelease(checkPath);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end