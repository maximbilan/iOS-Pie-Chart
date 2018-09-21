//
//  Chart.m
//  ios_pie_chart
//
//  Created by Maxim on 10/22/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import "Chart.h"
#import "ChartData.h"
#import "ChartView.h"
#import "LegendView.h"
#import "UIColor+Chart.h"

static const float          ChartDefaultScale           = 1.0;

static const NSInteger		ChartMaxItemCount           = 5;

static const NSTimeInterval ChartFadeInTime             = 0.2;
static const NSTimeInterval ChartFadeOutTime            = 0.6;

static const CGFloat        ChartViewPositionRectX      = 0.0;
static const CGFloat        ChartViewPositionRectY      = 0.0;
static const CGFloat        ChartViewPositionRectW      = 280.0;
static const CGFloat        ChartViewPositionRectH      = 200.0;

static const CGFloat        LegendViewPositionRectX     = 200.0;
static const CGFloat        LegendViewPositionRectY     = 55.0;
static const CGFloat        LegendViewPositionRectW     = 80.0;
static const CGFloat        LegendViewPositionRectH     = 200.0;

@interface Chart ()

@property (strong, nonatomic, readwrite) NSMutableArray *keys;
@property (strong, nonatomic, readwrite) ChartView *chartView;
@property (strong, nonatomic, readwrite) LegendView *legendView;

- (void)addRecordToTableData:(NSMutableArray *)table withName:(NSString *)name withValue:(float)value withTotal:(float)total;
- (void)scrollChart;

@end

@implementation Chart

@synthesize scale = _scale;
@synthesize currentKeyIndex = _currentKeyIndex;
@synthesize isScrollEnabled = _isScrollEnabled;
@synthesize isLegendTitleEnabled = _isLegendTitleEnabled;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keys = [[NSMutableArray alloc] init];
        self.currentKeyIndex = 0;
        self.scale = ChartDefaultScale;
        self.isScrollEnabled = YES;
        self.isLegendTitleEnabled = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.keys = [[NSMutableArray alloc] init];
    self.currentKeyIndex = 0;
    _scale = ChartDefaultScale;
    _isScrollEnabled = YES;
    _isLegendTitleEnabled = YES;
}

- (NSUInteger)currentKeyIndex
{
    return _currentKeyIndex;
}

- (void)setCurrentKeyIndex:(NSUInteger)currentKeyIndex
{
    if (currentKeyIndex < [self.keys count]) {
        _currentKeyIndex = currentKeyIndex;
        [self scrollChart];
    }
    else {
        _currentKeyIndex = 0;
    }
}

- (void)addRecordToTableData:(NSMutableArray *)table withName:(NSString *)name withValue:(float)value withTotal:(float)total
{
    ChartItemDerived* derivedRecord = [[ChartItemDerived alloc] init];
	derivedRecord.name = name;
	derivedRecord.value = value;
	derivedRecord.percent = (derivedRecord.value * 100.0) / total;
    
    [table addObject:derivedRecord];
}

- (void)setData:(NSArray *)array withKey:(NSString *)key withTotal:(float)total
{
    if (!self.chartView) {
		self.chartView = [[ChartView alloc] initWithFrame:CGRectMake(ChartViewPositionRectX * self.scale, ChartViewPositionRectY * self.scale, ChartViewPositionRectW * self.scale, ChartViewPositionRectH * self.scale)];
        [self addSubview:self.chartView];
    }
    
    if (!self.legendView) {
        self.legendView = [[LegendView alloc] initWithFrame:CGRectMake(LegendViewPositionRectX * self.scale, LegendViewPositionRectY * self.scale * 0.5, LegendViewPositionRectW * self.scale, LegendViewPositionRectH * self.scale)];
        [self addSubview:self.legendView];
    }
    
	NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *sortDescriptorValue = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:NO];
	NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = @[sortDescriptorValue, sortDescriptorName];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
	int index = 0;
	float otherValue = 0.0;
	BOOL moreThanMaxRecordsCount = NO;
	for (ChartItem *record in sortedArray) {
		if (index >= ChartMaxItemCount - 1) {
			moreThanMaxRecordsCount = YES;
			otherValue += record.value;
		}
		else {
            [self addRecordToTableData:data withName:record.name withValue:record.value withTotal:total];
		}
		
		++index;
	}
	
	if (moreThanMaxRecordsCount) {
        [self addRecordToTableData:data withName:@"Other" withValue:otherValue withTotal:total];
	}
    
    if (![self.keys containsObject:key]) {
        [self.keys addObject:key];
    }
    
    [self.chartView setData:data withType:key];
    [self.chartView setScale:self.scale];
    [self.legendView setData:data withKey:key];
    [self.legendView setIsTitleEnabled:self.isLegendTitleEnabled];
    
    NSString *keyStr = self.keys[self.currentKeyIndex];
    [self.chartView changeKey:keyStr];
    [self.legendView changeKey:keyStr];
    
	[self setNeedsDisplay];
}

- (BOOL)hasDataForKeyIndex:(NSInteger)keyIndex
{
    if (keyIndex >= 0 && keyIndex < [self.keys count]) {
        return [self.chartView hasDataForKey:self.keys[keyIndex]];
    }
    return NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isScrollEnabled) {
        if (self.currentKeyIndex == ([self.keys count] - 1)) {
            self.currentKeyIndex = 0;
        }
        else {
            ++self.currentKeyIndex;
        }
    
        if (![self.chartView hasDataForKey:self.keys[self.currentKeyIndex]]) {
            for (NSUInteger index = 0; index < [self.keys count]; ++index) {
                if ([self.chartView hasDataForKey:self.keys[index]]) {
                    self.currentKeyIndex = index;
                    break;
                }
            }
        }
        
        [self scrollChart];
    }
}

- (void)scrollChart
{
	__weak Chart *weakSelf = self;
	
    [UIView animateWithDuration:ChartFadeInTime
                          delay:0
                        options:0
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         NSString *key = weakSelf.keys[weakSelf.currentKeyIndex];
                         
                         [weakSelf.chartView changeKey:key];
                         [weakSelf.legendView changeKey:key];
                         [weakSelf.chartView setNeedsDisplay];
                         [weakSelf.legendView setNeedsDisplay];
                         [weakSelf setNeedsDisplay];
                         
                         [UIView animateWithDuration:ChartFadeOutTime
                                               delay:0
                                             options:0
                                          animations:^{
                                              weakSelf.alpha = 1.0;
                                          }
                                          completion:nil];
                     }];
}

@end
