//
//  ViewControllerCoordinate.m
//  PlaceReminder
//
//  Created by Marco Corazzini on 19/08/23.
//

#import "ViewControllerCoordinate.h"
#import <CoreLocation/CoreLocation.h>
#import "MagicPlacemark.h"
#import "ListaPlacemark.h"
@interface ViewControllerCoordinate ()
@property (weak, nonatomic) IBOutlet UITextField *nome;
@property (weak, nonatomic) IBOutlet UITextField *latitudine;
@property (weak, nonatomic) IBOutlet UITextField *longitudine;
@property (weak, nonatomic) IBOutlet UITextField *descrizione;
@property (weak, nonatomic) IBOutlet UIButton *add;

@end

@implementation ViewControllerCoordinate
- (IBAction)add:(id)sender {//pulsante "Add"
 
    NSDateFormatter *dataItaliana = [[NSDateFormatter alloc] init];
    [dataItaliana setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"]];
    [dataItaliana setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Rome"]];
    [dataItaliana setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dataFormattata = [dataItaliana stringFromDate:[NSDate date]];
    //inizializzo geocoder e location e setto i campi
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    CLLocation* location = [[CLLocation alloc] initWithLatitude:[self.latitudine.text doubleValue] longitude:[self.longitudine.text doubleValue]];
    if([self.nome.text isEqualToString:@""])return;//nome obbligatorio
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark*>*placemarks, NSError *error){
        if (!error){
            for (CLPlacemark* tmpPlacemark in placemarks) {
                //inserisco in Placemark nome,descrizione e data inserite dall'utente,
                //le altre informazioni sono prese dal geocoder
                MagicPlacemark* p = [[MagicPlacemark alloc] initWithNome:self.nome.text Descrizione:self.descrizione.text Data:dataFormattata Placemark:tmpPlacemark];
                NSUInteger index = [self.lista getIndexForPlacemark:p];
                if(index<[self.lista size]){//se index e' minore di size, e' gia presente nei miei placemark
                    UIAlertController *alertController =[UIAlertController
                     alertControllerWithTitle:@"PlaceReminder"
                     message:@"Esiste già un placemark in questa posizione"
                     preferredStyle:UIAlertControllerStyleAlert
                    ];

                    UIAlertAction* placemarkGiaEsistente = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction* _Nonnull placemarkGiaEsistente) {
                    }];
                    
                    [alertController addAction:placemarkGiaEsistente];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    return;
                }//else aggiungo il placemark
                UIAlertController *alertController =[UIAlertController
                 alertControllerWithTitle:@"PlaceReminder"
                 message:@"Placemark aggiunto"
                 preferredStyle:UIAlertControllerStyleAlert
                ];

                UIAlertAction* aggiunta = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction* _Nonnull aggiunta) {
                    [self.lista addPlacemark:p];
                    [self pulisciCampi];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                [alertController addAction:aggiunta];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }];
}
- (IBAction)togliTastiera:(id)sender {
    if ([self.nome isFirstResponder]) [self.nome resignFirstResponder];
    if ([self.latitudine isFirstResponder]) [self.latitudine resignFirstResponder];
    if ([self.longitudine isFirstResponder]) [self.longitudine resignFirstResponder];
    if ([self.descrizione isFirstResponder]) [self.descrizione resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)pulisciCampi{
        self.nome.text=@"";
        self.latitudine.text=@"";
        self.longitudine.text=@"";
        self.descrizione.text=@"";
}

@end
