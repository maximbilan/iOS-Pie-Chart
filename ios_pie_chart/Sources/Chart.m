//
//  Chart.m
//  wymg
//
//  Created by Maxim on 10/22/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import "Chart.h"
#import "ChartData.h"
#import "ChartView.h"
#import "LegendView.h"
#import "UIColor+Chart.h"

static const float          ChartDefaultScale           = 1.0f;

static const int            ChartMaxItemCount           = 5;
static const int            ChartSummaryColorIndex      = 4;

static const NSTimeInterval ChartFadeInTime             = 0.2f;
static const NSTimeInterval ChartFadeOutTime            = 0.6f;

static const CGFloat        ChartViewPositionRectX      = 0.0f;
static const CGFloat        ChartViewPositionRectY      = 0.0f;
static const CGFloat        ChartViewPositionRectW      = 280.0f;
static const CGFloat        ChartViewPositionRectH      = 200.0f;

static const CGFloat        LegendViewPositionRectX     = 200.0f;
static const CGFloat        LegendViewPositionRectY     = 55.0f;
static const CGFloat        LegendViewPositionRectW     = 80.0f;
static const CGFloat        LegendViewPositionRectH     = 200.0f;

@interface Chart ()

- (void)addRecordToTableData:(NSMutableArray *)table withName:(NSString *)name withValue:(float)value withTotal:(float)total;
- (void)scrollChart;

@end

@implementation Chart

@synthesize scale = _scale;
@synthesize currentKeyIndex = _currentKeyIndex;
@synthesize isScrollEnabled = _isScrollEnabled;
@synthesize isLegendTitleEnabled = _isLegendTitleEnabled;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
	{
        keys = [[NSMutableArray alloc] init];
        self.currentKeyIndex = 0;
        _scale = ChartDefaultScale;
        _isScrollEnabled = YES;
        _isLegendTitleEnabled = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    keys = [[NSMutableArray alloc] init];
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
    if( currentKeyIndex < [keys count] )
    {
        _currentKeyIndex = currentKeyIndex;
        [self scrollChart];
    }
    else
    {
        _currentKeyIndex = 0;
    }
}

- (void)addRecordToTableData:(NSMutableArray *)table withName:(NSString *)name withValue:(float)value withTotal:(float)total
{
    ChartItemDerived* derivedRecord = [[ChartItemDerived alloc] init];
	derivedRecord.name = name;
	derivedRecord.value = value;
	derivedRecord.percent = ( derivedRecord.value * 100.0f ) / total;
    
    [table addObject:derivedRecord];
}

- (void)setData:(NSArray *)array withKey:(NSString *)key withTotal:(float)total
{
    if( !chartView )
    {
        chartView = [[ChartView alloc] initWithFrame:CGRectMake( ChartViewPositionRectX, ChartViewPositionRectY * _scale, ChartViewPositionRectW, ChartViewPositionRectH * _scale )];
        [self addSubview:chartView];
    }
    
    if( !legendView )
    {
        legendView = [[LegendView alloc] initWithFrame:CGRectMake( LegendViewPositionRectX, LegendViewPositionRectY * _scale * 0.5f, LegendViewPositionRectW, LegendViewPositionRectH * _scale)];
        [self addSubview:legendView];
    }
    
	NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *sortDescriptorValue = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:NO];
	NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptorValue, sortDescriptorName, nil];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
	int index = 0;
	float otherValue = 0.0f;
	BOOL moreThanMaxRecordsCount = NO;
	for( ChartItem *record in sortedArray )
	{
		if( index >= ChartMaxItemCount - 1 )
		{
			moreThanMaxRecordsCount = YES;
			otherValue += record.value;
		}
		else
		{
            [self addRecordToTableData:data withName:record.name withValue:record.value withTotal:total];
		}
		
		++index;
	}
	
	if( moreThanMaxRecordsCount )
	{
        [self addRecordToTableData:data withName:@"Other" withValue:otherValue withTotal:total];
	}
    
    if( ![keys containsObject:key] )
    {
        [keys addObject:key];
    }
    
    [chartView setData:data withType:key];
    [chartView setScale:_scale];
    [legendView setData:data withKey:key];
    [legendView setIsTitleEnabled:_isLegendTitleEnabled];
    
    NSString *keyStr = [keys objectAtIndex:self.currentKeyIndex];
    [chartView changeKey:keyStr];
    [legendView changeKey:keyStr];
    
	[self setNeedsDisplay];
}

- (BOOL)hasDataForKeyIndex:(NSInteger)keyIndex
{
    if (keyIndex >= 0 && keyIndex < [keys count]) {
        return [chartView hasDataForKey:[keys objectAtIndex:keyIndex]];
    }
    return NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( _isScrollEnabled )
    {
        if( _currentKeyIndex == ( [keys count] - 1 ) )
        {
            _currentKeyIndex = 0;
        }
        else
        {
            ++_currentKeyIndex;
        }
    
        if( ![chartView hasDataForKey:[keys objectAtIndex:_currentKeyIndex]] )
        {
            for( NSUInteger index = 0; index < [keys count]; ++index )
            {
                if( [chartView hasDataForKey:[keys objectAtIndex:index]] )
                {
                    _currentKeyIndex = index;
                    break;
                }
            }
        }
        
        [self scrollChart];
    }
}

- (void)scrollChart
{
    [UIView animateWithDuration:ChartFadeInTime
                          delay:0
                        options:0
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^( BOOL finished ) {
                         NSString *key = [keys objectAtIndex:_currentKeyIndex];
                         
                         [chartView changeKey:key];
                         [legendView changeKey:key];
                         [chartView setNeedsDisplay];
                         [legendView setNeedsDisplay];
                         [self setNeedsDisplay];
                         
                         [UIView animateWithDuration:ChartFadeOutTime
                                               delay:0
                                             options:0
                                          animations:^{
                                              self.alpha = 1.0f;
                                          }
                                          completion:nil];
                     }];
}

@end
