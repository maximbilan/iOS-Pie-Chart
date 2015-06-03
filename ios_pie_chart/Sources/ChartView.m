//
//  ChartView.m
//  ios_pie_chart
//
//  Created by Maxim Bilan on 11/3/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import "ChartView.h"
#import "ChartData.h"
#import "NSString+Chart.h"

static const float      ChartViewDefaultScale       = 1.0;

static const NSInteger	ChartViewSummaryColorIndex  = 4;

static const CGFloat    ChartViewPositionX          = 80.0;
static const CGFloat    ChartViewPositionY          = 80.0;
static const CGFloat    ChartViewRadius             = 70.0;
static const CGFloat    ChartViewKernelRadius       = 25.0;

static const CGFloat    ChartViewLineWidth          = 1.0;

@interface ChartView ()
{
    NSMutableDictionary *data;
    
    NSString *currentKey;
    NSInteger type;
}

@end

@implementation ChartView

@synthesize scale = _scale;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        data = [[NSMutableDictionary alloc] init];
        currentKey = @"";
        self.scale = ChartViewDefaultScale;
        type = ChartBagel;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
    
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextFillRect(context, rect);
    
    if ([currentKey length] > 0) {
        NSArray* d = data[currentKey];
        if ([d count] > 0) {
            float prevPercent = 0.0;
            CGFloat startAngle = 0.0;
            CGFloat endAngle = 0.0;
            NSUInteger index = 0;
    
            NSArray *colors = [ChartData colors];
    
            for (ChartItemDerived* item in d) {
                const float percent = [item percent];
                const BOOL isOther = [[item name] isEqualToString:@"Other"];
                UIColor *color = (!isOther) ? colors[index] : colors[ChartViewSummaryColorIndex];
     
                startAngle = (((prevPercent) / 100.0) * 2 * (float)M_PI) - ((float)M_PI * 0.5);
                endAngle = (((percent) / 100.0) * 2 * (float)M_PI) + startAngle;
     
                CGContextSetFillColorWithColor(context, color.CGColor);
                CGContextMoveToPoint(context, ChartViewPositionX * self.scale, ChartViewPositionY * self.scale);
         
                CGContextAddArc(context, ChartViewPositionX * self.scale, ChartViewPositionY * self.scale, ChartViewRadius * self.scale, startAngle, endAngle, 0);
                CGContextSetLineWidth(context, ChartViewLineWidth);
                CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
                CGContextDrawPath(context, kCGPathFillStroke);
                
                prevPercent += percent;
                ++index;
            }
            
            if (type == ChartBagel) {
                CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                CGContextMoveToPoint(context, ChartViewPositionX * self.scale, ChartViewPositionY * self.scale);
            
                CGContextAddArc(context, ChartViewPositionX * self.scale, ChartViewPositionY * self.scale, ChartViewKernelRadius * self.scale, 0, M_PI * 2, 0);
                CGContextSetLineWidth(context, ChartViewLineWidth);
                CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
        }
    }
}

- (void)setData:(NSArray *)array withType:(NSString *)t
{
    [data removeObjectForKey:t];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (ChartItemDerived *item in array) {
        [temp addObject:item];
    }
    
    data[t] = temp;
    currentKey = t;
    
    [self setNeedsDisplay];
}

- (void)changeKey:(NSString *)key
{
    currentKey = key;
    [self setNeedsDisplay];
}

- (BOOL)hasDataForKey:(NSString *)key;
{
    BOOL hasData = NO;
    if ([currentKey length] > 0) {
        NSArray* d = data[key];
        if ([d count] > 0) {
            hasData = YES;
        }
    }
    
    return hasData;
}

@end
