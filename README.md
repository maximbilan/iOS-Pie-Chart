iOS Pie Chart
=============

Pie chart component.<br>
![alt tag](https://raw.github.com/maximbilan/ios_pie_chart/master/img/img1.png)

## Installation
<br>
Add to your project source files: <br>
<pre>
Chart.h
Chart.m
ChartData.h
ChartData.m
ChartView.h
ChartView.m
LegendCellView.h
LegendCellView.m
LegendView.h
LegendView.m
NSString+Chart.h
NSString+Chart.m
UIColor+Chart.h
UIColor+Chart.m
</pre>

## How to use

You can add view in the Interface builder and set class to Chart or create in the code: <br>
<pre>
Chart* chart = [[Chart alloc] initWithFrame:CGRectMake(0, 256, 256, 256)];
[self.view addSubview:chart];
</pre>
For adding chart data, you can use the following code: <br>
<pre>
NSMutableArray *array = [[NSMutableArray alloc] init];
    
float total;
for (NSInteger groupIndex = 0; groupIndex &#60; 5; ++groupIndex) {
  [array removeAllObjects];
  total = 0.0;
  for (NSInteger itemIndex = 0; itemIndex &#60; 10; ++itemIndex) {
    ChartItem *item = [[ChartItem alloc] init];
    item.name = [NSString stringWithFormat:@"Item %d", itemIndex];
    item.value = RAND_FROM_TO(1, 500);
    total += item.value;
    [array addObject:item];
  }
  [self.chart setData:array withKey:[NSString stringWithFormat:@"Group %d", groupIndex+1] withTotal:total];
}
</pre>
For scrolling datasets just tap on chart.
<br>
If you have one set of data, and you won't scroll them, use the following property:
<pre>
@property BOOL isScrollEnabled;
</pre>
