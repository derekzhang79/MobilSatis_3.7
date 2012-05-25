//
//  CSNewCoordinateLocationViewController.m
//  MobilSatis
//
//  Created by ABH on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSNewCoordinateLocationViewController.h"

@implementation CSNewCoordinateLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)selectedCustomer{
    self  = [super initWithUser:myUser];
    customer = selectedCustomer;
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = nil;
    annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AssignPin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AssignPin"];
    }
    
    //    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //    annotationView.rightCalloutAccessoryView = infoButton;
    annotationView.canShowCallout = YES;
    annotationView.draggable = YES;
    
    NSLog(@"%@",annotation.title);
    if ([annotation.title isEqualToString:@"Yeni Koordinat"] ) {
        annotationView.draggable = YES;
        [annotationView setMultipleTouchEnabled:YES];
        
    }
    
    return annotationView;
}
#pragma mark - Map Delegates
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
    NSLog(@"hopspadlaöda");
    
    
    //..Whatever you want to happen when the dragging starts or stops
}

- (void)zoomToMapPoint:(CSMapPoint*)point{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point.coordinate, 250,250);
    [mapView setRegion:region];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan || newMapPoint != nil)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self->mapView];   
    CLLocationCoordinate2D touchMapCoordinate = 
    [self->mapView convertPoint:touchPoint toCoordinateFromView:self->mapView];
    
    newMapPoint = [[CSDraggableMapPoint alloc] initWithCoordinate:touchMapCoordinate title:@"Yeni Koordinat"];
    [self->mapView addAnnotation:newMapPoint];
    
}


- (void)sendCoordinatesToSap{
    if (newMapPoint == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Yeni Koordinat belirtiniz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Koordinat Güncelleme" 
                                                    message:[NSString stringWithFormat:@"%@ müştersinin yeni koordinatarını Satış Destek onayına yolluyorsunuz. Emin misiniz?",customer.name1]
                                                   delegate:self 
                          
                                          cancelButtonTitle:@"İptal" 
                                          otherButtonTitles:@"Onayla", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([super isAnimationRunning]) {
            return;
        }
        ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
        [sapHandler setDelegate:self];
        [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_KOORDINAT_DEGISTIR"];
                    [sapHandler addImportWithKey:@"I_KUNNR" andValue:[customer kunnr]];
        [sapHandler addImportWithKey:@"I_EKOOR_X" andValue:[NSString stringWithFormat:@"%f",customer.locationCoordinate.coordinate.latitude]];
        [sapHandler addImportWithKey:@"I_EKOOR_Y" andValue:[NSString stringWithFormat:@"%f",customer.locationCoordinate.coordinate.longitude]];
        [sapHandler addImportWithKey:@"I_YKOOR_X" andValue:[NSString stringWithFormat:@"%f",newMapPoint.coordinate.latitude]];
        [sapHandler addImportWithKey:@"I_YKOOR_Y" andValue:[NSString stringWithFormat:@"%f",newMapPoint.coordinate.longitude]];
        [sapHandler addImportWithKey:@"I_UNAME" andValue:user.username];
        
                    [sapHandler prepCall];
        //            
        //            [super playAnimationOnView:self.view];
        
        
        
    }
    //        
}
-(void)getResponseWithString:(NSString *)myResponse{
    NSLog(@"%@",myResponse);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //putCoordinate
   // [mapView addAnnotation:user.location];
    [mapView addAnnotation:customer.locationCoordinate];
    [self zoomToMapPoint:customer.locationCoordinate];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] 
                                                                initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [mapView addGestureRecognizer:longPressGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [[self  navigationItem] setTitle:@"Yeni Koordinat"];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Güncelle" style:UIBarButtonItemStyleBordered target:self action:@selector(sendCoordinatesToSap)];
    [[self navigationItem] setRightBarButtonItem:nextButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end