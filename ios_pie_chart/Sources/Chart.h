//
//  Chart.h
//  ios_pie_chart
//
//  Created by Maxim on 10/22/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChartView;
@class LegendView;

@interface Chart : UIView
{
    NSMutableArray  *keys;
    
    ChartView       *chartView;
    LegendView      *legendView;
}

@property (nonatomic) NSUInteger currentKeyIndex;
@property float scale;
@property BOOL isScrollEnabled;
@property BOOL isLegendTitleEnabled;

- (void)setData:(NSArray *)array withKey:(NSString *)key withTotal:(float)total;
- (BOOL)hasDataForKeyIndex:(NSInteger)keyIndex;

@end
