//
//  CSNewCoordinateLocationViewController.h
//  MobilSatis
//
//  Created by ABH on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSCustomer.h"
#import "CSDraggableMapPoint.h"
#import <MapKit/MapKit.h>

@interface CSNewCoordinateLocationViewController : CSBaseViewController<MKMapViewDelegate>{
    CSCustomer *customer;
    CSDraggableMapPoint *newMapPoint;
    IBOutlet MKMapView *mapView;
    int flag;
    BOOL newCoor;
}
@property int flag;
@property BOOL newCoor;

- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)selectedCustomer;
- (void)zoomToMapPoint:(CSMapPoint*)point;
- (void)sendCoordinatesToGeovision;
@end
