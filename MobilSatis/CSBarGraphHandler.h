//
//  CSBarGraphHandler.h
//  MobilSatis
//
//  Created by ABH on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
@interface CSBarGraphHandler : NSObject<CPTBarPlotDelegate>{
    CPTGraphHostingView *hostingView;
    CPTXYGraph *graph;
    NSMutableArray *graphData;
    CPTScatterPlot *plot2;
    CPTBarPlot *plot ;
}
@property (nonatomic, retain) CPTGraphHostingView *hostingView;
@property (nonatomic, retain) CPTXYGraph *graph;
@property (nonatomic, retain) NSMutableArray *graphData;

// Method to create this object and attach it to it's hosting view.
-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data;

// Specific code that creates the scatter plot.
- (void)initialisePlot;
- (void)reloadSoldier:(NSMutableArray*)newData isHorizontal:(BOOL)isHorizontal;

//configuration part -alp
- (void)setPaddingsTop:(float)top andRight:(float)right andBottom:(float)bottom andLeft:(float)left;
- (void)calculateRangeOfGrapgh;
@end
