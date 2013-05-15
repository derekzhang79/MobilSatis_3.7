//
//  CSLoctionHandlerViewController.m
//  CrmServis
//
//  Created by ABH on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSLoctionHandlerViewController.h"

@implementation CSLoctionHandlerViewController
@synthesize addCustomerCoordinateViewController;
@synthesize counter;
@synthesize showMyCustomer;

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
    //[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / 10.0];
	//[[UIAccelerometer sharedAccelerometer] setDelegate:self];
    //    //location detecting
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:25];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //    //configuring map
    [mapView setUserInteractionEnabled:YES];
    [mapView setShowsUserLocation:YES];
    
    return self;
}

#pragma mark - Logic
- (BOOL)checkCustomerForPlan:(CSCustomer*)aCustomer{
    if (![aCustomer.hasPlan isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
- (void)findCustomers{
    counter = 0;
    [mapView removeAnnotations:mapView.annotations ];
    [myAnnotations removeAllObjects];
    [self getCustomersFromSapWithLocation:user.location];
    [table reloadData];
    [mapView reloadInputViews];
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
    [sapHandler addImportWithKey:@"I_UNAME" andValue:[user username]];
    
    if ([showMyCustomer isOn]) {
        [sapHandler addImportWithKey:@"I_MY_CUST" andValue:@"X"];
    }
    
    NSString *tableName = [NSString stringWithFormat:@"T_CUSTOMERS"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"KUNNR"];
    [columns addObject:@"NAME1"];
    [columns addObject:@"VTWEG"];
    [columns addObject:@"XCOR"];
    [columns addObject:@"YCOR"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [super playAnimationOnView:self.view];

    [sapHandler prepCall];
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me{
    [super stopAnimationOnView];
    //    //    NSLog(@"Envelope that recieved: %@",myResponse);
    
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        
        NSArray *locationArray = [CoreDataHandler fetchExistingEntityData:@"CDOLocationCustomer" sortingParameter:@"name1" objectContext:[CoreDataHandler getManagedObject]];
        customers = [[NSMutableArray alloc] init];

        for (CDOLocationCustomer *temp in locationArray) {
            CSCustomer *tempCustomer = [[CSCustomer alloc] init];
            
            [tempCustomer setKunnr:[temp kunnr]];
            [tempCustomer setName1:[temp name1]];
            [tempCustomer setRelationship:[temp relationship]];
            [tempCustomer setOther:[temp other]];
            [tempCustomer setHasPlan:[temp hasPlan]];
            [tempCustomer setType:[temp type]];
            
            CSMapPoint *tempPoint = [[CSMapPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([[[[temp location] coordinate] latitude] doubleValue], [[[[temp location] coordinate] longitude] doubleValue]) title:[[temp location] title]];
            [tempPoint setPngName:[[temp location] pngName]];
            [tempPoint setTablePngName:[[temp location] tablePngName]];
            
            [tempCustomer setLocationCoordinate:tempPoint];
            
            [customers addObject:tempCustomer];
        }
        for(CSCustomer *tempCustomer in customers){
            
            [self->mapView addAnnotation:tempCustomer.locationCoordinate];
        }
        [table reloadData];
        [mapView reloadInputViews];
    }
    else
    {
        NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"ZMOB_CUSTOMER" fromEnvelope:myResponse];
        if ([responses count] > 0) {
            NSString *customerTable = [NSString stringWithFormat:@"%@",[responses objectAtIndex:0]];
            
            [self checkExistingCoreDataToDelete];
            [self initCustomersFromResponse:customerTable];
            
            for(CSCustomer *tempCustomer in customers){
            
                [self->mapView addAnnotation:tempCustomer.locationCoordinate];
            }
            [table reloadData];
            [mapView reloadInputViews];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Müşteri Bulunamadı" message:@"Etrafınızda kayıtlı müşteri yoktur." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        }
    }
    
}

- (void)initCustomersFromResponse:(NSString*)myResponse {
    customers = [[NSMutableArray alloc] init];
    NSMutableArray *customerNumbers = [[NSMutableArray alloc] init];
    NSMutableArray *customerNames = [[NSMutableArray alloc] init];
    NSMutableArray *relationship = [[NSMutableArray alloc] init];
    NSMutableArray *xcor = [[NSMutableArray alloc] init];
    NSMutableArray *ycor = [[NSMutableArray alloc] init];
    NSMutableArray *plans = [[NSMutableArray alloc] init];
    NSMutableArray *kdgrp = [[NSMutableArray alloc] init];
    NSMutableArray *katr5 = [[NSMutableArray alloc] init];
    NSMutableArray *dontUse_S = [[NSMutableArray alloc] init];
    
    CSMapPoint *tempPoint;
    CSCustomer *tempCustomer;
    customerNumbers = [ABHXMLHelper getValuesWithTag:@"KUNNR" fromEnvelope:myResponse];
    customerNames = [ABHXMLHelper getValuesWithTag:@"NAME1" fromEnvelope:myResponse];
    relationship = [ABHXMLHelper getValuesWithTag:@"VTWEG" fromEnvelope:myResponse];
    xcor = [ABHXMLHelper getValuesWithTag:@"XCOR" fromEnvelope:myResponse];
    ycor = [ABHXMLHelper getValuesWithTag:@"YCOR" fromEnvelope:myResponse];
    plans = [ABHXMLHelper getValuesWithTag:@"PLAN" fromEnvelope:myResponse];
    kdgrp = [ABHXMLHelper getValuesWithTag:@"KDGRP" fromEnvelope:myResponse];
    katr5 = [ABHXMLHelper getValuesWithTag:@"KATR5" fromEnvelope:myResponse];
    dontUse_S = [ABHXMLHelper getValuesWithTag:@"DONT_USE_S" fromEnvelope:myResponse];
    
    for (int sayac = 0; sayac<[customerNumbers count]; sayac++) {
        tempCustomer = [[CSCustomer alloc] init];
        
        [tempCustomer setKunnr:[customerNumbers objectAtIndex:sayac ]];
        [tempCustomer setName1:[customerNames objectAtIndex:sayac ]];
        [tempCustomer setRelationship:[relationship objectAtIndex:sayac ]];
        [tempCustomer setOther:[dontUse_S objectAtIndex:sayac]];
        
        [tempCustomer setHasPlan:[plans objectAtIndex:sayac]];
        
        NSString *tempKdgrp = [kdgrp objectAtIndex:sayac];
        
        if ([tempKdgrp isEqualToString:@"94"] || [tempKdgrp isEqualToString:@"95"]) {
            [tempCustomer setType:@"acik"];           
        }
        else if([tempKdgrp isEqualToString:@"97"]){
            [tempCustomer setType:@"ekomini"];
        }else{
            [tempCustomer setType:@"kapali"];
        }
        
        NSString *tempKatr5 = [katr5 objectAtIndex:sayac];
        
        if ([tempKatr5 isEqualToString:@"05"]) {
            [tempCustomer setType:@"bira"];
            }
        tempPoint = [[CSMapPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([[ycor objectAtIndex:sayac] doubleValue], [[xcor objectAtIndex:sayac] doubleValue]) title:[tempCustomer name1]];
        [tempCustomer setLocationCoordinate:tempPoint];
        [tempPoint setPngName:[self getAnnotationPngNameFromCustomer:tempCustomer]];
//        [tempCustomer setLocationCoordinate:tempPoint];
        
        [self saveLocationCustomerToCoreData:tempCustomer];
        
        [customers addObject:tempCustomer];
        
    }
    [self saveCurrentLocationToCoreData];
}


- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan )
        return;
    
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self->mapView];   
    CLLocationCoordinate2D touchMapCoordinate = 
    [self->mapView convertPoint:touchPoint toCoordinateFromView:self->mapView];
    addCustomerPoint = [[CSMapPoint alloc] initWithCoordinate:touchMapCoordinate title:@"Yeni Müşteri"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yeni Giriş" message:@"Yeni bir müşteri mi eklemek istiyorsunuz?" delegate:self cancelButtonTitle:@"Hayır" otherButtonTitles:@"Evet", nil];
    [alert show];
    //    [self->mapView addAnnotation:newMapPoint];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        CSCustomer *tempCustomer = [[CSCustomer alloc] init];
        [tempCustomer setLocationCoordinate:addCustomerPoint];
        
        addCustomerCoordinateViewController = [[CSAddCustomerCoordinateViewController alloc] initWithUser:user andCustomer:tempCustomer];
        
        [[self navigationController] pushViewController:addCustomerCoordinateViewController animated:YES];
    }
}

#pragma mark - Location Delegation Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"newlocation %@", newLocation);
    CSMapPoint *tempPoint = [[CSMapPoint alloc] initWithCoordinate:newLocation.coordinate title:@"Ben"];
    //for test purpose
   // tempPoint =  [tempPoint initWithCoordinate:CLLocationCoordinate2DMake([@"40.888803" doubleValue], [@"29.188903" doubleValue]) title:@"Ben"] ;
    
    
    [user setLocation:tempPoint];
    //[user setLocation:newLocation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[user location] coordinate], 250, 250);
    if (!([customers count] > 0)) {
        [self getCustomersFromSapWithLocation:user.location];
    }
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

- (NSString*) getAnnotationPngNameFromCustomer:(CSCustomer*)activeCustomer{
    if ([activeCustomer.other isEqualToString:@"03"]) {
        activeCustomer.locationCoordinate.tablePngName =@"greenCustomerIconBig.png";
        return @"greenCustomerIconSmall.png";
    }
   
    if ([activeCustomer.relationship isEqualToString:@"04"] || [activeCustomer.relationship isEqualToString:@"05"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            activeCustomer.locationCoordinate.tablePngName =@"sappiconlar-01.png";
            return @"sariEv.png";
        }else{
            activeCustomer.locationCoordinate.tablePngName =@"appiconlar-01.png";
            return @"maviEvIcon.png";
        }
    }
    if ([activeCustomer.type isEqualToString:@"acik"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            activeCustomer.locationCoordinate.tablePngName = @"sappiconlar-02.png";
            return@"iconYellowOpen.png";
        }
        else{
            activeCustomer.locationCoordinate.tablePngName = @"appiconlar-02.png";
            return@"beerIcon.png";
        }
    }
    else if ([activeCustomer.type isEqualToString:@"kapali"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            activeCustomer.locationCoordinate.tablePngName = @"sapp iconlar-11.png";
            return @"iconYellowClosed.png";
        }
        else{
            activeCustomer.locationCoordinate.tablePngName = @"app iconlar-11.png";
            return @"iconKapali.png";
        }
    }
    else if ([activeCustomer.type isEqualToString:@"bira"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            activeCustomer.locationCoordinate.tablePngName = @"sappiconlar-03.png";
            return @"iconYellowBeer.png";
        }
        else{
            activeCustomer.locationCoordinate.tablePngName = @"appiconlar-03.png";
            return @"iconBira.png";
        }
    }
    else if ([activeCustomer.type isEqualToString:@"ekomini"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            activeCustomer.locationCoordinate.tablePngName = @"ekominiBuyukSari.png";
            return @"ekominiKucukSari.png";
        }
        else{
            activeCustomer.locationCoordinate.tablePngName = @"ekominiBuyukMavi.png";
            return @"ekominiKucukMavi.png";
        }
    }
    else{
        activeCustomer.locationCoordinate.tablePngName = @"appiconlar-02.png";
        return@"beerIcon.png";
    }
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //burayi sabit stringle yapcaz
    MKAnnotationView *annotationView = nil;
    CSMapPoint *tempPoint;
    if ([annotation isKindOfClass:[CSMapPoint class]]) {
         tempPoint = annotation;
    
   
    annotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:tempPoint.pngName];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:tempPoint.pngName];
    }
    }
    else {
        return  nil;
    }
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = infoButton;
    annotationView.canShowCallout = YES;
    
 

    [annotationView setImage:[UIImage imageNamed:tempPoint.pngName]];
 
    
    if ([annotation.title isEqualToString:@"Current Location"] || [annotation.title isEqualToString:@"Ben"]) {

        
        
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
    
    CSCustomerDetailViewController *customerDetailViewController;

    if ([[selectedCustomer relationship] isEqualToString:@"04"] || [[selectedCustomer relationship] isEqualToString:@"05"] || [[selectedCustomer relationship] isEqualToString:@"11"])
        customerDetailViewController = [[CSCustomerDetailViewController alloc] initWithUser:[self user] andCustomer:selectedCustomer isDealer:YES];
    else
        customerDetailViewController = [[CSCustomerDetailViewController alloc] initWithUser:[self user] andCustomer:selectedCustomer isDealer:NO];
    
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
    
//    if ([self checkCustomerForPlan:tempCustomer]) {
//        NSLog(@"horray a plan!");
//    }
    [[cell textLabel] setText: tempCustomer.name1 ];
    [[cell detailTextLabel] setText:tempCustomer.kunnr];
    cell.imageView.image = [UIImage imageNamed:tempCustomer.locationCoordinate.tablePngName];    
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    if (![tempCustomer.hasPlan isEqualToString:@""]) {
        @try {
            UIView *tempView = [[UIView alloc] initWithFrame:cell.frame];
            
          //  [tempView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundView:tempView];
        }
        @catch (NSException *exception) {
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%u", indexPath.row);
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[[customers objectAtIndex:indexPath.row] locationCoordinate] coordinate], 100, 100);
    
    [mapView setRegion:region animated:YES];
   
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    CSCustomer *selectedCustomer = [customers objectAtIndex:indexPath.row];
    
    CSCustomerDetailViewController *customerDetailViewController;
    
    if ([[selectedCustomer relationship] isEqualToString:@"04"] || [[selectedCustomer relationship] isEqualToString:@"05"])
        customerDetailViewController = [[CSCustomerDetailViewController alloc] initWithUser:[self user] andCustomer:selectedCustomer isDealer:YES];
    else
        customerDetailViewController = [[CSCustomerDetailViewController alloc] initWithUser:[self user] andCustomer:selectedCustomer isDealer:NO];

    [[self navigationController] pushViewController:customerDetailViewController animated:YES]; 
    
}
/*
 #pragma mark - accelaration
 - (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
 {
 
 NSLog(@"normal:%f ",  acceleration.y);
 
 if(acceleration.y >0.1 && ( acceleration.x >0.2 || acceleration.x <-0.2)){
 if([table frame].size.height < 150.0f){           
 NSLog(@"ACILIYOR:%f ",  acceleration.y);
 //  tam tersi          
 [table setFrame:[[self view] bounds]];
 [mapView setHidden:YES];
 [mapView setFrame:[[self view] bounds]];
 [mapView setHidden:NO];
 }else{
 
 NSLog(@"KAPANIYOR:  %f ", acceleration.y);
 //tam tersi
 [table setFrame:CGRectMake(0,238, 320, 129)];
 [mapView setHidden:NO];
 [mapView setFrame:CGRectMake(0, 0, 320, 238)];
 [table setHidden:NO];
 for (UITableViewCell *cell in [table visibleCells ]){
 [[cell  detailTextLabel]setHighlighted:YES];
 }
 
 }
 }
 
 }
 */

#pragma mark - Core Data methods

- (void)saveLocationCustomerToCoreData:(CSCustomer *)tempCustomer {
    
    CDOLocationCustomer *locCust = (CDOLocationCustomer *)[CoreDataHandler insertEntityData:@"CDOLocationCustomer"];
    
    [locCust setKunnr:[tempCustomer kunnr]];
    [locCust setName1:[tempCustomer name1]];
    [locCust setRelationship:[tempCustomer relationship]];
    [locCust setOther:[tempCustomer other]];
    [locCust setHasPlan:[tempCustomer hasPlan]];
    [locCust setType:[tempCustomer type]];
    
    CDOLocation *tempLoc = (CDOLocation *)[CoreDataHandler insertEntityData:@"CDOLocation"];
    
    [tempLoc setTitle:[[tempCustomer locationCoordinate] title]];
    [tempLoc setTablePngName:[[tempCustomer locationCoordinate] tablePngName]];
    [tempLoc setPngName:[[tempCustomer locationCoordinate] pngName]];
    
    CDOCoordinate *coor = (CDOCoordinate *)[CoreDataHandler insertEntityData:@"CDOCoordinate"];
    
    NSNumber *lat = [[NSNumber alloc] initWithDouble:[[tempCustomer locationCoordinate] coordinate].latitude];
    NSNumber *lon = [[NSNumber alloc] initWithDouble:[[tempCustomer locationCoordinate] coordinate].longitude];
    [coor setLatitude:lat];
    [coor setLongitude:lon];
    
    [tempLoc setCoordinate:coor];
    
    [locCust setLocation:tempLoc];
    
    [CoreDataHandler saveEntityData];

}

- (void)saveCurrentLocationToCoreData {
    
    NSArray *arr = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
    CDOUser *userLog;
    
    if ([arr count] > 0) {
        userLog = [arr objectAtIndex:0];
    }
    
    CDOCoordinate *coor = (CDOCoordinate *)[CoreDataHandler insertEntityData:@"CDOCoordinate"];
    
    NSNumber *lat = [[NSNumber alloc] initWithDouble:[[user location] coordinate].latitude];
    NSNumber *lon = [[NSNumber alloc] initWithDouble:[[user location] coordinate].longitude];
    [coor setLatitude:lat];
    [coor setLongitude:lon];
    
    [userLog setLocation:coor];
    
    [CoreDataHandler saveEntityData];
}

- (void)checkExistingCoreDataToDelete {
    
    NSArray *locationArray = [CoreDataHandler fetchExistingEntityData:@"CDOLocationCustomer" sortingParameter:@"kunnr" objectContext:[CoreDataHandler getManagedObject]];
    
    for (CDOLocationCustomer *temp in locationArray) {
        [[CoreDataHandler getManagedObject] deleteObject:temp];
    }
    
    [CoreDataHandler saveEntityData];
}

#pragma mark - Checkings
/*- (void)checkLocationServiceEnable{
 //burda sadece servise bakıyor ancak aplikasyonun iznine bakamıyor
 if (![locationManager locationServicesEnabled]) {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Konum servisiniz kapalıdır, bu özellik kullanılamaz. Ayarlardan servisi etkinleştiriniz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
 [alert show];
 }
 }*/

- (BOOL)checkAvailableForCancelation{
    
    return NO;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    counter = 0;
    [locationManager startUpdatingLocation];
    table.backgroundColor = [UIColor clearColor];
    table.opaque = NO;
    table.backgroundView = nil;
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] 
                                                                initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [mapView addGestureRecognizer:longPressGestureRecognizer];
    // [[[self tabBarController] navigationItem] setTitle:@"Müşterilerim"];
    [showMyCustomer setOn:NO];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    [showMyCustomer setOn:NO];
}

//- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    if (motion == UIEventSubtypeMotionShake )
//    {
//        if([table frame].size.height < 150.0f){           
//            //  tam tersi          
//            [table setFrame:[[self view] bounds]];
//            [mapView setHidden:YES];
//            [mapView setFrame:[[self view] bounds]];
//            [mapView setHidden:NO];
//        }
//        else
//        {
//            //tam tersi
//            [table setFrame:CGRectMake(0,238, 320, 129)];
//            [mapView setHidden:NO];
//            [mapView setFrame:CGRectMake(0, 0, 320, 238)];
//            [table setHidden:NO];
//            for (UITableViewCell *cell in [table visibleCells ]){
//                [[cell  detailTextLabel]setHighlighted:YES];
//            }
//            
//        }
//        
//    }
//    
//}

//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    
//}



- (void)viewWillAppear:(BOOL)animated{
    //self.navigationController.view.frame = [[UIScreen mainScreen] bounds];
//    CGRect alp = self.navigationController.view.frame; //0 0 320 480
//    // 0 0 768 1024
//    if (self.navigationController.view.frame.size.height == 1044) {
//        self.navigationController.view.frame = CGRectMake(0,0,768,1024);
//        self.tabBarController.view.frame = CGRectMake(0,0,768,960);
//        CGRect barFrame =      self.navigationController.navigationBar.frame;
//        barFrame.origin.y = 20;
//        self.navigationController.navigationBar.frame = barFrame;
//    }else if (self.navigationController.view.frame.origin.y == 20){
//        CGRect deneme = self.navigationController.view.frame;
//        self.navigationController.view.frame = CGRectMake(0,0,320,480);
//        //self.tabBarController.view.frame = CGRectMake(0,0,768,960);
//        CGRect barFrame =      self.navigationController.navigationBar.frame;
//        barFrame.origin.y = 20;
//        self.navigationController.navigationBar.frame = barFrame;
//    }
    
    counter = 0;
    if (addCustomerCoordinateViewController.flag == 1) {
        addCustomerCoordinateViewController.flag = 0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Müşteri lokasyonu için yaptığınız değişiklik başarılıyla tamamlanmıştır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
    }
    if (addCustomerCoordinateViewController.flag == 2) {
        addCustomerCoordinateViewController.flag = 0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Müşteri lokasyonu için yaptığınız değişiklik başarısız olmuştur." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
    }
    
    [[[self tabBarController] navigationItem] setTitle:@"Müşterilerim"];
    //[self checkLocationServiceEnable];
    
    //need working here
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Müşterileri Bul" style:UIBarButtonItemStyleBordered target:self action:@selector(findCustomers)];
    [[[self tabBarController ]navigationItem] setRightBarButtonItem:nextButton];
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
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
