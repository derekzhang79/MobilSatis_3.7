//
//  CSAddCustomerCoordinateViewController.m
//  MobilSatis
//
//  Created by ABH on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSAddCustomerCoordinateViewController.h"
#import "CSGeovisionHandler.h"

@implementation CSAddCustomerCoordinateViewController
@synthesize flag;

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
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AssignPin"];
    }
    if ([annotation.title isEqualToString:@"Current Location"] || [annotation.title isEqualToString:@"Ben"]) {
        
        
        
        return  nil;
    }
    annotationView.canShowCallout = YES;
    annotationView.draggable = YES;
    [annotationView setImage:[UIImage imageNamed:@"maviAcik.png"]];


    if ([annotation.title isEqualToString:@"Yeni Koordinat"] ) {
        annotationView.draggable = YES;
        [annotationView setMultipleTouchEnabled:YES];
        
    }
    
    return annotationView;
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





- (void)sendCoordinatesToGeovision{

    if ([self checkFields]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Müşteri Ekleme" 
                                                        message:@"Yeni müşteri koordinatarını Satış Destek onayına yolluyorsunuz. Emin misiniz?"
                                                       delegate:self 
                              
                                              cancelButtonTitle:@"İptal" 
                                              otherButtonTitles:@"Onayla", nil];
        [alert setTag:1];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" 
                                                        message:@"Müşteri numarası veya adres bilgisi giriniz."
                                                       delegate:self 
                              
                                              cancelButtonTitle:@"İptal" 
                                              otherButtonTitles:nil];
        [alert show];
    }
    
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
                
                CSCustomer *tempCustomer = [[CSCustomer alloc] init];
                [tempCustomer setKunnr:[kunnrTextField text]];
                
                NSString *response = [CSGeovisionHandler sendCoordinatesToGeovisionFromUser:user andCustomer:tempCustomer andOldLocation:CLLocationCoordinate2DMake(0, 0) andNewLocation:[newMapPoint coordinate] andText:[adressTextView text]];
                
                if (![response isEqualToString:@"Done."])
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


-(IBAction)ignoreKeyboard{
    
    [self->adressTextView resignFirstResponder];
    [self->kunnrTextField resignFirstResponder];
    //   [self resignFirstResponder   ];
}

- (BOOL)checkFields{
    if ([kunnrTextField.text length] == 0 && [adressTextView.text length] == 0) {
        return NO;      
    }
    return YES;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //putCoordinate
    // [mapView addAnnotation:user.location];
    mapView.delegate = self;
    [self->mapView addAnnotation:customer.locationCoordinate];
    [self zoomToMapPoint:customer.locationCoordinate];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] 
                                                                initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [mapView addGestureRecognizer:longPressGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [[self  navigationItem] setTitle:@"Yeni Koordinat"];
    [kunnrLabel setTextColor:[CSApplicationProperties getUsualTextColor]];
    [adressLabel setTextColor:[CSApplicationProperties getUsualTextColor]];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Ekle" style:UIBarButtonItemStyleBordered target:self action:@selector(sendCoordinatesToGeovision)];
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