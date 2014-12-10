//
//  LegendView.h
//  ios_pie_chart
//
//  Created by Maxim Bilan on 11/3/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegendView : UIView

- (void)setData:(NSArray *)array withKey:(NSString *)key;
- (void)changeKey:(NSString *)key;

@property (nonatomic) BOOL isTitleEnabled;

@end
