//
//  CSLoctionHandlerViewController.m
//  CrmServis
//
//  Created by ABH on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSLoctionHandlerViewController.h"

@implementation CSLoctionHandlerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(CSUser *)myUser{
    self = [super initWithUser:myUser];
    customers = [[NSMutableArray alloc] init];
    
    //    //for movement delegation
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / 10.0];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
    //    //location detecting
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:10000];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];

    //    //configuring map
    [mapView setUserInteractionEnabled:YES];
    [mapView setShowsUserLocation:YES];
    
    return self;
}
#pragma mark - Logic
- (void)findCustomers{
    [self getCustomersFromSapWithLocation:user.location];
}
- (void)getCustomersFromSapWithLocation:(CSMapPoint*)location{
    if ([super isAnimationRunning]) {
        return;
    }
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_CUSTOMERS_BY_COOR"];
    [sapHandler addImportWithKey:@"XCOR" andValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude ]];
    [sapHandler addImportWithKey:@"YCOR" andValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude]];
    NSString *tableName = [NSString stringWithFormat:@"T_CUSTOMERS"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"KUNNR"];
    [columns addObject:@"NAME1"];
    [columns addObject:@"VTWEG"];
    [columns addObject:@"XCOR"];
    [columns addObject:@"YCOR"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];
    [super playAnimationOnView:self.view];
}
-(void)getResponseWithString:(NSString *)myResponse{
    [super stopAnimationOnView];
//    //    NSLog(@"Envelope that recieved: %@",myResponse);
    NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"ZMOB_CUSTOMER" fromEnvelope:myResponse];
    if ([responses count] > 0) {
            NSString *customerTable = [NSString stringWithFormat:@"%@",[responses objectAtIndex:0]];
        [self initCustomersFromResponse:customerTable];
        for(CSCustomer *tempCustomer in customers){
            [self->mapView addAnnotation:tempCustomer.locationCoordinate];
        }
        [table reloadData];
        [mapView reloadInputViews];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Müşteri Bulunamadı" message:@"Etrafınızda kayıtlı müşteri yoktur." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
    }

}

- (void)initCustomersFromResponse:(NSString*)myResponse{
    customers = [[NSMutableArray alloc] init];
    
    NSMutableArray *customerNumbers = [[NSMutableArray alloc] init];
    NSMutableArray *customerNames = [[NSMutableArray alloc] init];
    NSMutableArray *relationship = [[NSMutableArray alloc] init];
    NSMutableArray *xcor = [[NSMutableArray alloc] init];
    NSMutableArray *ycor = [[NSMutableArray alloc] init];
    CSMapPoint *tempPoint;
    CSCustomer *tempCustomer;
    customerNumbers = [ABHXMLHelper getValuesWithTag:@"KUNNR" fromEnvelope:myResponse];
    customerNames = [ABHXMLHelper getValuesWithTag:@"NAME1" fromEnvelope:myResponse];
    relationship = [ABHXMLHelper getValuesWithTag:@"VTWEG" fromEnvelope:myResponse];
    xcor = [ABHXMLHelper getValuesWithTag:@"XCOR" fromEnvelope:myResponse];
    ycor = [ABHXMLHelper getValuesWithTag:@"YCOR" fromEnvelope:myResponse];
    for (int sayac = 0; sayac<[customerNumbers count]; sayac++) {
        tempCustomer = [[CSCustomer alloc] init];

        [tempCustomer setKunnr:[customerNumbers objectAtIndex:sayac ]];
        [tempCustomer setName1:[customerNames objectAtIndex:sayac ]];
        [tempCustomer setRelationship:[relationship objectAtIndex:sayac ]];
        tempPoint = [[CSMapPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([[ycor objectAtIndex:sayac] doubleValue], [[xcor objectAtIndex:sayac] doubleValue]) title:[tempCustomer name1]];
        [tempCustomer setLocationCoordinate:tempPoint];
        [customers addObject:tempCustomer];
                     
    }
    
    
}
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan )
        return;

    
    CGPoint touchPoint = [gestureRecognizer locationInView:self->mapView];   
    CLLocationCoordinate2D touchMapCoordinate = 
    [self->mapView convertPoint:touchPoint toCoordinateFromView:self->mapView];
    addCustomerPoint = [[CSMapPoint alloc] initWithCoordinate:touchMapCoordinate title:@"Yeni Müşteri"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yeni Giriş" message:@"Yeni bir müşteri mi eklemek istiyrsunuz?" delegate:self cancelButtonTitle:@"Hayır" otherButtonTitles:@"Evet", nil];
    [alert show];
//    [self->mapView addAnnotation:newMapPoint];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        CSCustomer *tempCustomer = [[CSCustomer alloc] init];
        [tempCustomer setLocationCoordinate:addCustomerPoint];
        CSAddCustomerCoordinateViewController *addCustomerCoordinateViewController = [[CSAddCustomerCoordinateViewController alloc] initWithUser:user andCustomer:tempCustomer];
        [[self navigationController] pushViewController:addCustomerCoordinateViewController animated:YES];
        
        
    }
    
}


#pragma mark - Location Delegation Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"newlocation %@", newLocation);
    CSMapPoint *tempPoint = [[CSMapPoint alloc] initWithCoordinate:newLocation.coordinate title:@"Ben"];
    //for test purpose
   tempPoint =  [tempPoint initWithCoordinate:CLLocationCoordinate2DMake([@"40.987919" doubleValue], [@"28.886584" doubleValue]) title:@"Ben"] ;
    
    
    [user setLocation:tempPoint];
    //[user setLocation:newLocation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[user location] coordinate], 1000, 1000);
    [self getCustomersFromSapWithLocation:user.location];
    [mapView setRegion:region animated:YES];
    

    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location error");
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    static bool justOnce = true;
//    if (justOnce) {
        
//        justOnce = false;
//    }
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //burayi sabit stringle yapcaz
    MKPinAnnotationView *annotationView = nil;
    annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"musteri"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"musteri"];
    }
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = infoButton;
    annotationView.canShowCallout = YES;
    [annotationView setImage:[UIImage imageNamed:@"beer.png"]];
    NSLog(@"%@",annotation.title);
    if ([annotation.title isEqualToString:@"Current Location"] || [annotation.title isEqualToString:@"Ben"]) {
       // ((MKPointAnnotation *)annotation).title = @"My Current Location"; 
        //.title = @"Ben";
        
        
        return  nil;
    }
    
    return annotationView;   
}


- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
    NSLog(@"mapViewWillStartLocatingUser:(MKMapView *)mapView");
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"customer detail event");
    BOOL check = NO;
    CSCustomer *selectedCustomer;
        for (int sayac=0; sayac<[customers count]; sayac++) {	
            if ([[NSString stringWithFormat:@"%f",[view.annotation coordinate].latitude] isEqualToString:[NSString stringWithFormat:@"%f", [[[customers objectAtIndex:sayac ] locationCoordinate] coordinate].latitude ]] && [[NSString stringWithFormat:@"%f",[view.annotation coordinate].longitude] isEqualToString:[NSString stringWithFormat:@"%f", [[[customers objectAtIndex:sayac ] locationCoordinate] coordinate].longitude ]]) {
                check = YES;
              selectedCustomer = [customers objectAtIndex:sayac];
               
        }
      }
       //    
       if (!check) {
           return;
        }

    CSCustomerDetailViewController *customerDetailViewController = [[CSCustomerDetailViewController alloc] initWithUser:[self user] andCustomer:selectedCustomer];
    [[self navigationController] pushViewController:customerDetailViewController animated:YES]; 
    
  
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - Table delegation methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [customers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    CSCustomer *tempCustomer = [customers objectAtIndex:indexPath.row];
    [[cell textLabel] setText: tempCustomer.name1 ];
    [[cell detailTextLabel] setText:tempCustomer.kunnr];
    cell.imageView.image = [UIImage imageNamed:@"beer.png"];    
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%u", indexPath.row);
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[[customers objectAtIndex:indexPath.row] locationCoordinate] coordinate], 100, 100);
    
    [mapView setRegion:region animated:YES];
    

    
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    CSCustomer *selectedCustomer = [customers objectAtIndex:indexPath.row];
    CSCustomerDetailViewController *customerDetailViewController = [[CSCustomerDetailViewController alloc] initWithUser:[self user] andCustomer:selectedCustomer];
    [[self navigationController] pushViewController:customerDetailViewController animated:YES]; 
    
}
#pragma mark - accelaration
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    
    //    NSLog(@"normal:%f ",  acceleration.y);
    
//    if(acceleration.y >0.1 && ( acceleration.x >0.2 || acceleration.x <-0.2)){
//        if([table frame].size.height < 150.0f){           
//            NSLog(@"ACILIYOR:%f ",  acceleration.y);
////  tam tersi          
////            [table setFrame:[[self view] bounds]];
////            [mapView setHidden:YES];
//            [mapView setFrame:[[self view] bounds]];
//            [mapView setHidden:NO];
//        }else{
//            
//            NSLog(@"KAPANIYOR:  %f ", acceleration.y);
////tam tersi
////            [table setFrame:CGRectMake(0,238, 320, 129)];
// //           [mapView setHidden:NO];
//            [mapView setFrame:CGRectMake(0, 0, 320, 238)];
//            [table setHidden:NO];
//            for (UITableViewCell *cell in [table visibleCells ]){
//                [[cell  detailTextLabel]setHighlighted:YES];
//            }
//            
//        }
//    }
    
}
#pragma mark - Checkings
- (void)checkLocationServiceEnable{
    //burda sadece servise bakıyor ancak aplikasyonun iznine bakamıyor
    if (![locationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Konum servisiniz kapalıdır, bu modül kullanılamaz. Ayarlardan servisi etkinleştiriniz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        [locationManager startUpdatingLocation];
    table.backgroundColor = [UIColor clearColor];
    table.opaque = NO;
    table.backgroundView = nil;
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] 
                                                                initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [mapView addGestureRecognizer:longPressGestureRecognizer];
   // [[[self tabBarController] navigationItem] setTitle:@"Müşterilerim"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [[[self tabBarController] navigationItem] setTitle:@"Müşterilerim"];
    [self checkLocationServiceEnable];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Müşterileri Bul" style:UIBarButtonItemStyleBordered target:self action:@selector(findCustomers)];
    [[[self tabBarController ]navigationItem] setRightBarButtonItem:nextButton];
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
