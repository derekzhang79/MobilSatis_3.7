//
//  CSBarGraphHandler.m
//  MobilSatis
//
//  Created by ABH on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSBarGraphHandler.h"

@implementation CSBarGraphHandler
@synthesize hostingView ,graph,graphData,actualData,actualPlotData;


// Initialise the scatter plot in the provided hosting view with the provided data.
// The data array should contain NSValue objects each representing a CGPoint.
-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data
{
    self = [super init];
    
    if ( self != nil ) {
        self.hostingView = hostingView;
//        self.graphData = data;
        self.graphData = [self getCropedValuesFromData:data];
        [self setActualData:data];
        self.graph = nil;
    }
    
    return self;
    //alp ok
}

-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data andxAxisTexts:(NSMutableArray*) texts{
    
    self = [self initWithHostingView:hostingView andData:data];
    xAxisTexts = texts;
    needPlotting = NO;
    return  self;
}
-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data andxAxisTexts:(NSMutableArray*) texts andPlotData:(NSMutableArray*)pData{
    self = [self initWithHostingView:hostingView andData:data andxAxisTexts:texts ];
    if (pData!=nil) {
        plotData = [self getCropedValuesFromData:pData];
        [self setActualPlotData:pData];
        needPlotting = YES;
    }

    return self ;
}
- (NSMutableArray*)getCropedValuesFromData:(NSMutableArray * )data{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *tempString;
    NSValue *tempValue;// = [self.graphData objectAtIndex:index];
   // CGPoint tempPoint;// = [value CGPointValue];
    int cropCounter = [self calculateCropCounterFromFloat:[self findMinYFromDataArray:data]];//ne kadar hane atılcagını en kucuge gore tutar
    
    for (int sayac= 0; sayac < data.count; sayac++) {
        tempValue =[data objectAtIndex:sayac];
        tempString = [NSString stringWithFormat:@"%.f",[tempValue CGPointValue].y ];
        //while (tempString.length>3) {
        if([tempValue CGPointValue].y>0){
            for (int sayac2 = 0; sayac2<cropCounter; sayac2++) {
                    tempString = [ tempString substringToIndex:tempString.length-3];
            }
        }
        [array addObject:[NSValue valueWithCGPoint:CGPointMake(sayac+1, [tempString floatValue])]];
                     
    }
    return array;
}
-(int)calculateCropCounterFromFloat:(float)minVal{
    int returnValue = 0;
    NSString* tempString = [NSString stringWithFormat:@"%.f",minVal ];
    while (tempString.length>3) {
        tempString = [ tempString substringToIndex:tempString.length-3];
        returnValue++;
    }
    return returnValue;
}
// This does the actual work of creating the plot if we don't already have a graph object.
-(void)initialisePlot
{
    // Start with some simple sanity checks before we kick off
    if ( (self.hostingView == nil) || (self.graphData == nil) ) {
        NSLog(@"TUTSimpleScatterPlot: Cannot initialise plot without hosting view or data.");
        return;
    }
    
    if ( self.graph != nil ) {
        NSLog(@"TUTSimpleScatterPlot: Graph object already exists.");
        //return;
    }
    
    // Create a graph object which we will use to host just one scatter plot.
    //viewa cp table xy graph cakıoz
    CGRect frame = [self.hostingView frame];
    self.graph = [[CPTXYGraph alloc] initWithFrame:frame];
    
    // Add some padding to the graph, with more at the bottom for axis labels.
    //padding verdin
    self.graph.plotAreaFrame.paddingTop = 20.0f;
    self.graph.plotAreaFrame.paddingRight = 15.0f;
    self.graph.plotAreaFrame.paddingBottom = 90.0f;
    self.graph.plotAreaFrame.paddingLeft = 75.0f;
    
    // Tie the graph we've created with the hosting view.
    self.hostingView.hostedGraph = self.graph;
    
    // If you want to use one of the default themes - apply that here.
    //[self.graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    
    // Create a line style that we will apply to the axis and data line.
    //çizgi stili yaratıosun ozellikleri falan
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 2.0f;
    
    // Create a text style that we will use for the axis labels.
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 14;
    textStyle.color = [CPTColor whiteColor];
    
    // Create the plot symbol we're going to use.
    //haç şeklinde plot sembolu
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol diamondPlotSymbol];
    plotSymbol.lineStyle = lineStyle;
    plotSymbol.size = CGSizeMake(8.0, 8.0);
    
    // Setup some floats that represent the min/max values on our axis.
    float xAxisMin = 0;
    float xAxisMax = [self findMaxX];
    float yAxisMin = 0;
    float yAxisMax = [self findMaxY];
    
    // We modify the graph's plot space to setup the axis' min / max values.
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xAxisMin) length:CPTDecimalFromFloat(xAxisMax - xAxisMin)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yAxisMin) length:CPTDecimalFromFloat(yAxisMax - yAxisMin)];
    
    // Modify the graph's axis with a label, line style, etc.
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
    //axisSet.xAxis.title = @"Ay";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = 30.0f;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = 3.0f;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(1.0f);
    axisSet.xAxis.minorTicksPerInterval = 0;
    axisSet.xAxis.minorTickLength = 3.0f;
    axisSet.xAxis.majorTickLength = 5.0f;
    axisSet.xAxis.orthogonalCoordinateDecimal = CPTDecimalFromFloat(xAxisMin);
    [axisSet.xAxis setDelegate:self];
    //axisSet.yAxis.title = @"Litre";
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleOffset = 40.0f;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.labelTextStyle = textStyle;
    axisSet.yAxis.labelOffset = 3.0f;
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat((yAxisMax-yAxisMin)/xAxisMax);
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.yAxis.minorTickLength = 3.0f;
    axisSet.yAxis.majorTickLength = 5.0f;
    
    // Add a plot to our graph and axis. We give it an identifier so that we
    // could add multiple plots (data lines) to the same graph if necessary.
    plot2 = [[CPTScatterPlot alloc] init];
    plot = [[CPTBarPlot alloc] init];
    plot.dataSource = self;
    plot.identifier = @"mainplot";
    plot2.dataSource = self;
    plot2.identifier = @"budgetplot";
        plot2.dataLineStyle = lineStyle;
    plot2.plotSymbol = plotSymbol;
    [plot setDelegate:self];
    //[plot2 setDelegate:self];
    [self.graph addPlot:plot];
        [self.graph addPlot:plot2];
    //[graph reloadData];
    
    
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index{
    NSValue *value = [self.graphData objectAtIndex:index];
    CGPoint point = [value CGPointValue];
//plot yoksa barlar arasında bak
    if(!needPlotting){
    float limit = [self findMaxY] /2;
    if (point.y>limit) {
        return [[CPTFill alloc] initWithColor:[UIColor colorWithRed:43.0f/255.0f green:195.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
    }
    else{
        return [[CPTFill alloc] initWithColor:[UIColor colorWithRed:190.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0f]];
    }
    }else{
        NSValue *value = [self.actualData objectAtIndex:index];
        CGPoint point = [value CGPointValue];
        NSValue *value2;
        @try {
            value2 = [actualPlotData objectAtIndex:index];
        }
        @catch (NSException *exception) {
            return [[CPTFill alloc] initWithColor:[UIColor colorWithRed:190.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0f]];
        }
  
        CGPoint point2 = [value2 CGPointValue];
        if (point2.y>=point.y) {
            return [[CPTFill alloc] initWithColor:[UIColor colorWithRed:190.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0f]];
        }else{
            return [[CPTFill alloc] initWithColor:[UIColor colorWithRed:43.0f/255.0f green:195.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
        }
    }
    
}

// Delegate method that returns the number of points on the plot
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ( [plot.identifier isEqual:@"mainplot"] )
    {
        return [self.graphData count];
    }else if (@"budgetplot"){
        return [plotData count];
    }
    
    return 0;
}

- (void) barPlot:(CPTBarPlot *) 	plot
barWasSelectedAtRecordIndex:(NSUInteger) index {
    if (actualData.count < index) {
        return;
    }
    NSValue *value = [self.actualData objectAtIndex:index];
    CGPoint point = [value CGPointValue];
   // NSPoint *p = [self.graphData objectAtIndex:index];
//    NSLog(@"%@",value);
//    NSLog(@"%@",[value pointerValue] );
//    NSLog(@"%@",[value CGPointValue].y);
    UIAlertView *alert;
    if (plotData.count == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"Açıklama"  message:[NSString stringWithFormat:@"%@ ayında yapılan satış litresi: %@",[self getMonthName:(index + 1)],[ABHXMLHelper correctNumberValue:[NSString stringWithFormat:@"%f",point.y]]]  delegate:self cancelButtonTitle:nil otherButtonTitles:@"Tamam", nil];
    
    }else{
        if (actualPlotData.count >= index) {
            NSValue *value2 = [actualPlotData objectAtIndex:index];
            CGPoint point2 = [value2 CGPointValue];
            
            alert = [[UIAlertView alloc] initWithTitle:@"Açıklama"  message:[NSString stringWithFormat:@"%@ ayında yapılan \nsatış litresi: %@ \n bütçesi: %@",[self getMonthName:(index + 1)],[ABHXMLHelper correctNumberValue:[NSString stringWithFormat:@"%f",point.y]],[ABHXMLHelper correctNumberValue:[NSString stringWithFormat:@"%f",point2.y]]]  delegate:self cancelButtonTitle:nil otherButtonTitles:@"Tamam", nil];
        }
    }
    
    [alert show];
    
}

- (NSString *)getMonthName:(int)monthNumber {
  
    return [self->xAxisTexts objectAtIndex:monthNumber];
    
}

-(void)reloadSoldier:(NSMutableArray*)newData isHorizontal:(BOOL)isHorizontal{
    graphData = newData;
    
        [plot setBarsAreHorizontal:isHorizontal];
    
    [graph reloadData];
}


// Delegate method that returns a single X or Y value for a given plot.
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ( [plot.identifier isEqual:@"mainplot"] )
    {
        NSValue *value = [self.graphData objectAtIndex:index];
        CGPoint point = [value CGPointValue];
  
        // FieldEnum determines if we return an X or Y value.
        if ( fieldEnum == CPTScatterPlotFieldX )
        {
            return [NSNumber numberWithFloat:point.x];
        }
        else    // Y-Axis
        {
            return [NSNumber numberWithFloat:point.y];
        }
    }
    if ( [plot.identifier isEqual:@"budgetplot"] )
    {
        NSValue *value = [plotData objectAtIndex:index];
        CGPoint point = [value CGPointValue];
        
        // FieldEnum determines if we return an X or Y value.
        if ( fieldEnum == CPTScatterPlotFieldX )
        {
            return [NSNumber numberWithFloat:point.x];
        }
        else    // Y-Axis
        {
            return [NSNumber numberWithFloat:point.y];
        }
    }
    
    return [NSNumber numberWithFloat:0];
}

//configuration methods
- (void)setPaddingsTop:(float)top andRight:(float)right andBottom:(float)bottom andLeft:(float)left{
    self.graph.plotAreaFrame.paddingTop = top;
    self.graph.plotAreaFrame.paddingRight = right;
    self.graph.plotAreaFrame.paddingBottom = bottom;
    self.graph.plotAreaFrame.paddingLeft = left;
}

- (void)calculateRangeOfGrapgh{
    float xAxisMin = 0;
    float xAxisMax = [self findMaxX];
    float yAxisMin = 0;
    float yAxisMax = [self findMaxY];
}


- (float)findMaxX{
    if (graphData.count == 0) {
        return 0;
    }
    NSValue *value;
    CGPoint point;
    float temp = 0;
    float maxX;
    for (int sayac = 0 ; sayac<graphData.count; sayac++) {
        value = [self.graphData objectAtIndex:sayac];
        point = [value CGPointValue];
        temp = point.x;
        
        if (temp > maxX) {
            maxX	 = temp;
        }
        
    }

    return maxX;
}

- (float)findMaxY{
    if (graphData.count == 0) {
        return 0;
    }
    NSValue *value;
    CGPoint point;
    float temp = 0;
    float maxY;
    for (int sayac = 0 ; sayac<graphData.count  ; sayac++) {
        value = [self.graphData objectAtIndex:sayac];
        point = [value CGPointValue];
        temp = point.y;
        
            if (temp > maxY) {
                maxY = temp;
            }
        
    }
    
    return maxY;
}

- (float)findMinYFromDataArray:(NSMutableArray*)array{
    if (array.count == 0) {
        return 0;
    }
    NSValue *value;
    CGPoint point;
    float temp = 0;
    float minY =99999999;
    if (array.count == 1) {
        value = [array objectAtIndex:0];
        point = [value CGPointValue];
        temp = point.y;
        return temp;
    }
    for (int sayac = 0 ; sayac<array.count-1; sayac++) {
        value = [array objectAtIndex:sayac];
        point = [value CGPointValue];
        temp = point.y;
        
        if (temp < minY) {
            minY = temp;
        }
        
    }
    

    return minY;
}
- (void)test{
    [plot setBarsAreHorizontal:YES];
    
    [graph reloadData];
}

#pragma mark - axis delegate

- (BOOL) axis:(CPTAxis *) 	axis
shouldUpdateAxisLabelsAtLocations:		(NSSet *) 	locations {
    // Define some custom labels for the data elements
    //axis.labelRotation = M_PI/4;
    //x.labelingPolicy = CPAxisLabelingPolicyNone;
    NSMutableArray *customLabels = [[NSMutableArray alloc] init];
    //NSArray *xAxisLabels = [NSArray arrayWithObjects:@"Atilla!!!", @"Label B", @"Label C", @"Label D", @"Label E",@"s",@"sa",nil];
    NSArray *locationsArray = [[axis majorTickLocations] allObjects];
  //  NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
    
    for (int sayac = 0 ;sayac < [locations count] ; sayac++) {
        @try {
            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisTexts objectAtIndex:sayac] textStyle:axis.labelTextStyle];
            
            newLabel.tickLocation = [[NSNumber numberWithInt:sayac] decimalValue];
            //[[locationsArray objectAtIndex:sayac] decimalValue];
            newLabel.offset = axis.labelOffset + axis.majorTickLength;
            newLabel.rotation = M_PI/4;
            [customLabels addObject:newLabel];
        }
        @catch (NSException *exception) {
            
        }
   
        
        //[newLabel release];
    }
    
    axis.axisLabels =  [NSSet setWithArray:customLabels];
    return NO;
    }


- (void)setXAxisTextsWithArray:(NSMutableArray*)anArray{
    xAxisTexts = anArray;
}
- (void)setYAxisTextsWithArray:(NSMutableArray*)anArray{
    yAxisTexts = anArray;
}
- (void)turnThatThingToHorizantalwithData:(NSMutableArray*)data andYAxisTexts:(NSMutableArray*) texts{
    graphData = data;
    xAxisTexts = texts;

[self initialisePlot];
    [graph reloadData];
    
}
- (void)turnThatThingToVerticalwithData:(NSMutableArray*)data andXAxisTexts:(NSMutableArray*) texts{
    xAxisTexts = texts;
    graphData = data;
    [self initialisePlot];
    [graph reloadData];
    
}
@end
