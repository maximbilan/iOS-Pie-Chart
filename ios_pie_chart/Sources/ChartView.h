//
//  ChartView.h
//  ios_pie_chart
//
//  Created by Maxim Bilan on 11/3/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChartViewType)
{
    ChartDefault,
    ChartBagel
};

@interface ChartView : UIView
{
    NSMutableDictionary *data;
    
    NSString *currentKey;
    NSInteger type;
}

@property float scale;

- (void)setData:(NSArray *)array withType:(NSString *)t;
- (void)changeKey:(NSString *)key;
- (BOOL)hasDataForKey:(NSString *)key;

@end
