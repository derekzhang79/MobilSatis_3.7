//
//  CSLoctionHandlerViewController.h
//  CrmServis
//
//  Created by ABH on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CSCustomer.h"
#import "CSCustomerDetailViewController.h"
#import "CSAddCustomerCoordinateViewController.h"

//#import "CNMapPoint.h"
@interface CSLoctionHandlerViewController : CSBaseViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>{
    IBOutlet MKMapView *mapView;
    CLLocationManager *locationManager;
    IBOutlet UITableView *table;
    CSMapPoint *addCustomerPoint;
    NSMutableArray *myAnnotations;
    //surec degiskenleri
    NSMutableArray *customers;
    CSAddCustomerCoordinateViewController *addCustomerCoordinateViewController;
    int counter;
    IBOutlet UISwitch *showMyCustomer;
}

@property (nonatomic, strong) CSAddCustomerCoordinateViewController *addCustomerCoordinateViewController;
@property (nonatomic, strong) UISwitch *showMyCustomer;
@property int counter;

- (void)getCustomersFromSapWithLocation:(CSMapPoint*)location;
- (void)initCustomersFromResponse:(NSString*) myResponse;
- (void)findCustomers;


@end
