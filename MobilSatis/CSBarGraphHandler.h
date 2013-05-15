//
//  CSBarGraphHandler.h
//  MobilSatis
//
//  Created by ABH on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "ABHXMLHelper.h"

@interface CSBarGraphHandler : NSObject<CPTBarPlotDelegate,CPTAxisDelegate>{
    CPTGraphHostingView *hostingView;
    CPTXYGraph *graph;
    NSMutableArray *graphData;
    NSMutableArray *plotData;
    NSMutableArray *actualPlotData;
    CPTScatterPlot *plot2;
    CPTBarPlot *plot ;
    
    NSMutableArray *xAxisTexts;
    NSMutableArray *yAxisTexts;
    NSMutableArray  *actualData;
    bool needPlotting;
}
@property (nonatomic, retain) CPTGraphHostingView *hostingView;
@property (nonatomic, retain) CPTXYGraph *graph;
@property (nonatomic, retain) NSMutableArray *graphData;
@property (nonatomic, retain) NSMutableArray *actualData;
@property (nonatomic, retain) NSMutableArray *actualPlotData;

// Method to create this object and attach it to it's hosting view.
-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data;
-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data andxAxisTexts:(NSMutableArray*) texts;
-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data andxAxisTexts:(NSMutableArray*) texts andPlotData:(NSMutableArray*)pData;

// Specific code that creates the scatter plot.
- (void)initialisePlot;
- (void)reloadSoldier:(NSMutableArray*)newData isHorizontal:(BOOL)isHorizontal;

//configuration part -alp
- (void)setPaddingsTop:(float)top andRight:(float)right andBottom:(float)bottom andLeft:(float)left;
- (void)calculateRangeOfGrapgh;
- (float)findMaxX;
- (float)findMaxY;
- (void)test;
- (void)setXAxisTextsWithArray:(NSMutableArray*)anArray;
- (void)setYAxisTextsWithArray:(NSMutableArray*)anArray;
- (void)turnThatThingToHorizantalwithData:(NSMutableArray*)data andYAxisTexts:(NSMutableArray*) texts;
- (void)turnThatThingToVerticalwithData:(NSMutableArray*)data andXAxisTexts:(NSMutableArray*) texts;
- (NSString *)getMonthName:(int)monthNumber;
@end
