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

@property (nonatomic) NSUInteger currentKeyIndex;
@property (nonatomic) float scale;
@property (nonatomic) BOOL isScrollEnabled;
@property (nonatomic) BOOL isLegendTitleEnabled;

- (void)setData:(NSArray *)array withKey:(NSString *)key withTotal:(float)total;
- (BOOL)hasDataForKeyIndex:(NSInteger)keyIndex;

@end
