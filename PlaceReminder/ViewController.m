//
//  ViewController.m
//  PlaceReminder
//
//  Created by Marco Corazzini on 04/08/23.
//

#import "ViewController.h"
#import "ListaPlacemark.h"
#import "ViewControllerIndirizzo.h"
#import "ViewControllerCoordinate.h"
#import "ViewControllerDettagli.h"
#import "ViewControllerTable.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
@property(nonatomic, strong) MKMapView* mappa;
@property(nonatomic, strong) CLLocationManager* posizione;
@property(nonatomic, strong) ListaPlacemark* lista;
@property (nonatomic, strong) MagicPlacemark *placemark;


@end

@implementation ViewController

//alert per scegliere il metodo di input placemark
-(IBAction)showNotificationAlert:(id)sender {
    UIAlertController *alertController =[UIAlertController
     alertControllerWithTitle:@"Inserimento Placemark"
     message:@"Scegli un metodo di Inserimento:"
     preferredStyle:UIAlertControllerStyleAlert
    ];

      UIAlertAction* indirizzo = [UIAlertAction actionWithTitle:@"Inserimento Indirizzo"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction* _Nonnull indirizzo) {
                                                            [self performSegueWithIdentifier:@"SegueIndirizzo" sender:self];
                                                      }
      ];
    
      UIAlertAction* coordinate = [UIAlertAction actionWithTitle:@"Inserimento Coordinate"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction* _Nonnull coordinate) {
                                                            [self performSegueWithIdentifier:@"SegueCoordinate" sender:self];
                                                      }
      ];

      UIAlertAction* cancella = [UIAlertAction actionWithTitle:@"Annulla"
                                               style:UIAlertActionStyleCancel
                                               handler:nil
      ];

      [alertController addAction:indirizzo];
      [alertController addAction:coordinate];
      [alertController addAction:cancella];

      [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self posizione];
    self.posizione.delegate = self;
    [self.posizione requestAlwaysAuthorization]; //richiedo le autorizzazioni
    [self.posizione startUpdatingLocation];
    //inserisco la mappa programmatically
    self.mappa = [[MKMapView alloc]initWithFrame:self.view.bounds];
    self.mappa.showsUserLocation = YES;
    [self.view addSubview:self.mappa];
    self.mappa.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[ //costraint mappa
        [self.mappa.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.mappa.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.mappa.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.mappa.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    _lista = [[ListaPlacemark alloc] init];
    self.mappa.delegate = self;
    //ascolto per le notifiche di aggiunta e rimozione placemark
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aggiungi:) name:@"Placemark Aggiunto" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rimuovi:) name:@"Placemark Rimosso" object:nil];
}
-(void)aggiungi:(NSNotification*)notifica{
    //setup dell'annotation sulla mappa nel momento in cui un placemark viene inserito
    NSDictionary* dizionario = notifica.userInfo;
    MagicPlacemark<MKAnnotation>*tmp = dizionario[@"placemark"];
    [self aggiungiAnnotation:tmp];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(tmp.latitudine, tmp.longitudine);
    CLLocationDistance raggio = 50.0;
    CLRegion *regione = [[CLCircularRegion alloc] initWithCenter:coordinate
                                                          radius:raggio
                                                      identifier:[NSString stringWithFormat:@"%@", tmp.nome]];
    [self.posizione startMonitoringForRegion:regione];
}
-(CLLocationManager*) posizione{
    //setting della posizione dell'utente
    if (!_posizione){
        _posizione = [[CLLocationManager alloc] init];
        _posizione.desiredAccuracy = kCLLocationAccuracyBest;
        _posizione.distanceFilter = kCLDistanceFilterNone;
        _posizione.activityType = CLActivityTypeOther;

    }
    return _posizione;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SegueIndirizzo"]){
        ViewControllerIndirizzo* viewController = segue.destinationViewController;
        viewController.lista = self.lista;
    }
    if([segue.identifier isEqualToString:@"SegueCoordinate"]){
        ViewControllerCoordinate* viewController = segue.destinationViewController;
        viewController.lista = self.lista;
    }
    if([segue.identifier isEqualToString:@"apriLista"]){
        ViewControllerTable* viewController = segue.destinationViewController;
        viewController.lista = self.lista;
    }
    if([segue.identifier isEqualToString:@"segueAnnotazione"]){
        ViewControllerDettagli* viewController = segue.destinationViewController;
        viewController.lista = self.lista;
        NSUInteger index = [self.lista getIndexForPlacemark:sender];
        if(index<[self.lista size])viewController.index=index;
    }
}
-(void)aggiungiAnnotation:(id<MKAnnotation>)annotazione{//aggiungo annotation
    [self.mappa addAnnotation:annotazione];
}
-(void)rimuoviAnnotation:(id<MKAnnotation>)annotazione{//rimuovo annotation
    [self.mappa removeAnnotation:annotazione];
}
-(void)rimuovi:(NSNotification*)notifica{
    //preparo l'annotazione per essere rimossa
    NSDictionary* dizionario = notifica.userInfo;
    MagicPlacemark<MKAnnotation>*tmp = dizionario[@"placemark"];
    [self rimuoviAnnotation:tmp];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(tmp.latitudine, tmp.longitudine);
    CLLocationDistance raggio = 50.0;
    CLRegion *regione = [[CLCircularRegion alloc] initWithCenter:coordinate
                                                          radius:raggio
                                                      identifier:[NSString stringWithFormat:@"%@", tmp.nome]];
    [self.posizione stopMonitoringForRegion:regione];
}
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
  //geofencer
    UIAlertController *alertController =[UIAlertController
                                         alertControllerWithTitle:@"PlaceReminder"
                                         message:[NSString stringWithFormat:@"Sei entrato in: %@", region.identifier]
                                         preferredStyle:UIAlertControllerStyleAlert
    ];

    UIAlertAction* notificaregione = [UIAlertAction actionWithTitle:@"Ok"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction* _Nonnull notificaregione) {
    }];
    
      [alertController addAction:notificaregione];
      [self presentViewController:alertController animated:YES completion:nil];
}

-(MKAnnotationView*)mapView: (MKMapView*)mapView viewForAnnotation:(nonnull id<MKAnnotation>)annotation{
    //setup della view quando si clicca sull'annotation
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKAnnotationView *view = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"identificatore"];
    if (!view){
        view = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identificatore"];
        view.canShowCallout = YES;
        UIButton *dettagli = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        view.rightCalloutAccessoryView = dettagli;
    }
    view.annotation = annotation;
    return view;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"segueAnnotazione" sender:view.annotation];
};
@end
