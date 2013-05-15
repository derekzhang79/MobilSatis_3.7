//
//  CSAddCustomerCoordinateViewController.h
//  MobilSatis
//
//  Created by ABH on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSCustomer.h"
#import "CSDraggableMapPoint.h"
#import <MapKit/MapKit.h>
@interface CSAddCustomerCoordinateViewController : CSBaseViewController<MKMapViewDelegate>{
    CSCustomer *customer;
    CSDraggableMapPoint *newMapPoint;
    IBOutlet MKMapView *mapView;
    IBOutlet UITextField *kunnrTextField;
    IBOutlet UITextView *adressTextView;
    IBOutlet UILabel *kunnrLabel;
    IBOutlet UILabel *adressLabel;
    int flag;
    
}

@property int flag;

- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)selectedCustomer;
- (void)zoomToMapPoint:(CSMapPoint*)point;
- (void)sendCoordinatesToGeovisionc;
-(IBAction)ignoreKeyboard;
- (BOOL)checkFields;


@end
