//
//  CSNewCoordinateLocationViewController.m
//  MobilSatis
//
//  Created by ABH on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSNewCoordinateLocationViewController.h"
#import "CSGeovisionHandler.h"

@implementation CSNewCoordinateLocationViewController
@synthesize flag;
@synthesize newCoor;

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
    MKAnnotationView *annotationView = nil;
    annotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AssignPin"];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AssignPin"];
    }
    if ([annotation.title isEqualToString:@"Current Location"] || [annotation.title isEqualToString:@"Ben"]) {
        
        
        
        return  nil;
    }
    
    //    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //    annotationView.rightCalloutAccessoryView = infoButton;
    annotationView.canShowCallout = YES;
    annotationView.draggable = YES;
    [annotationView setImage:[UIImage imageNamed:[self getAnnotationPngNameFromCustomer:customer]]];

    NSLog(@"%@",annotation.title);
    if ([annotation.title isEqualToString:@"Yeni Koordinat"] ) {
        annotationView.draggable = YES;
        [annotationView setMultipleTouchEnabled:YES];
        
    }
    
    return annotationView;
}


- (NSString*) getAnnotationPngNameFromCustomer:(CSCustomer*)activeCustomer{
    if ([activeCustomer.other isEqualToString:@"03"]) {
        return @"greenCustomerIconSmall.png";
    }
    if ([activeCustomer.relationship isEqualToString:@"04"] || [activeCustomer.relationship isEqualToString:@"05"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            return @"sariEv.png";
        }else{
            if (newCoor == YES) {
                return @"turkazEv.png";
            }
            return @"maviEvIcon.png";
        }
    }
    if ([activeCustomer.type isEqualToString:@"acik"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            return@"iconYellowOpen.png";
        }
        else{
            if (newCoor == YES) {
                return @"maviAcik.png";
            }
            return @"beerIcon.png";
        }
    }
    else if ([activeCustomer.type isEqualToString:@"kapali"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            return @"iconYellowClosed.png";
        }
        else{
            if (newCoor == YES) {
                return @"turkuazKapali.png";
            }
            return @"iconKapali.png";
        }
    }
    else if ([activeCustomer.type isEqualToString:@"bira"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            return @"iconYellowBeer.png";
        }
        else{
            return @"iconBira.png";
            if (newCoor == YES) {
                return @"turkuazBira.png";
            }
        }
    }else if ([activeCustomer.type isEqualToString:@"ekomini"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            return @"ekominiKucukSari.png";
        }
        else{
            return @"ekominiKucukMavi";
        }
    }

}

#pragma mark - Map Delegates
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
    
    
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
    
    newCoor = YES;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self->mapView];   
    CLLocationCoordinate2D touchMapCoordinate = 
    [self->mapView convertPoint:touchPoint toCoordinateFromView:self->mapView];
    
    newMapPoint = [[CSDraggableMapPoint alloc] initWithCoordinate:touchMapCoordinate title:@"Yeni Koordinat"];
    [self->mapView addAnnotation:newMapPoint];
    
}


- (void)sendCoordinatesToGeovision{
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
    [alert setTag:1];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch ([alertView tag]) {
        case 1:
            if (buttonIndex == 1) {
                if ([super isAnimationRunning]) {
                    return;
                }
                
                NSString *urlString = [NSString stringWithFormat:@"http://92.45.120.118:8082/EfesWS/EfesWS?"
                                       "un=efes.abh&ps=3f3sAbhC00rTo6vg&object={"
                                       "\"deneme\":{\"IPHONE_X\":\"44\",\"IPHONE_Y\":\"44\",\"MUSTERI_KODU"
                                       "\":\"0001323475\",\"PANORAMA_X\":\"30\",\"PANORAMA_Y\":\"30\",\"USERID\":\"alpkeseriPhone2\"}}"];
                
                urlString =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSError *errorReturned = nil;
                
                NSString *result = [CSGeovisionHandler sendCoordinatesToGeovisionFromUser:user andCustomer:customer andOldLocation:[[customer locationCoordinate] coordinate] andNewLocation:[newMapPoint coordinate] andText:@" "];
                
                if (![result isEqualToString:@"Done."])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Koordinat Güncelleme"
                                                                    message:@"Hata oluştu"
                                                                   delegate:self
                                          
                                                          cancelButtonTitle:@"Tamam"
                                                          otherButtonTitles:nil];
                    [alert setTag:2];
                    [alert show];
                    
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Koordinat Güncelleme"
                                                                    message:@"İşlem tamamlandı"
                                                                   delegate:self
                                          
                                                          cancelButtonTitle:@"Tamam"
                                                          otherButtonTitles:nil];
                    [alert setTag:2];
                    [alert show];

                }
                
            }
            break;
        case 2:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
    
}
                                                           
- (double)getDistanceFromOldPointY:(double)old_lat andOldPointX:(double)old_lon andNewPointY:(double) new_lat andNewPointX:(double) new_lon{
    const int R =     6371;    
    double dLat = (new_lat - old_lat) * (M_PI/180);
    double dLon = (new_lon - old_lon) * (M_PI/180);
    old_lat = old_lat * (M_PI/180);
    new_lat = new_lat * (M_PI/180);
    double a = pow(sin(new_lat - old_lat), 2) + cos(new_lat)*cos(old_lat)*pow(sin(new_lon - old_lon), 2);
                                                               
    a= pow(sin(dLat/2), 2) + cos(old_lat)*cos(new_lat)*pow(sin(dLon/2), 2);
                                                               
    double b = 2 * a * pow(tan(2*(sqrt(a)-sqrt(1 - a))), 2);
    b = 2*atan2(sqrt(a),sqrt((1-a)));
    double c = R * b;
                                                               
                                                               
    return c*1000;
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
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Güncelle" style:UIBarButtonItemStyleBordered target:self action:@selector(sendCoordinatesToGeovision)];
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
