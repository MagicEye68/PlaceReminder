//
//  ViewControllerIndirizzo.m
//  PlaceReminder
//
//  Created by Marco Corazzini on 19/08/23.
//

#import "ViewControllerIndirizzo.h"
#import <CoreLocation/CoreLocation.h>
#import "MagicPlacemark.h"
#import "ListaPlacemark.h"
#import <Contacts/Contacts.h>
@interface ViewControllerIndirizzo ()
@property (weak, nonatomic) IBOutlet UITextField *nome;
@property (weak, nonatomic) IBOutlet UITextField *nazione;
@property (weak, nonatomic) IBOutlet UITextField *citta;
@property (weak, nonatomic) IBOutlet UITextField *via;
@property (weak, nonatomic) IBOutlet UITextField *numeroCivico;
@property (weak, nonatomic) IBOutlet UITextField *cap;
@property (weak, nonatomic) IBOutlet UITextField *descrizione;
@property (weak, nonatomic) IBOutlet UIButton *add;

@end

@implementation ViewControllerIndirizzo

- (IBAction)add:(id)sender { //pulsante "Add"
    NSDateFormatter *dataItaliana = [[NSDateFormatter alloc] init];
    [dataItaliana setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"]];
    [dataItaliana setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Rome"]];
    [dataItaliana setDateFormat:@"dd/MM/yyyy HH:mm:ss"]; 
    NSString *dataFormattata = [dataItaliana stringFromDate:[NSDate date]];
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init]; //inizializzo geocoder
    CNMutablePostalAddress * address = [[CNMutablePostalAddress alloc] init];//inizializzo indirizzo
    //setto i campi per effettuare il geocode
    address.country = self.nazione.text;
    address.city = self.citta.text;
    address.street = [NSString stringWithFormat:@"%@, %@", self.via.text,self.numeroCivico.text];
    address.postalCode = self.cap.text;
    if([self.nome.text isEqualToString:@""])return;//nome obbligatorio
    //eseguo geocoder
    [geocoder geocodePostalAddress:address completionHandler:^(NSArray<CLPlacemark*>*placemarks, NSError *error){
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
    if ([self.nazione isFirstResponder]) [self.nazione resignFirstResponder];
    if ([self.citta isFirstResponder]) [self.citta resignFirstResponder];
    if ([self.via isFirstResponder]) [self.via resignFirstResponder];
    if ([self.numeroCivico isFirstResponder]) [self.numeroCivico resignFirstResponder];
    if ([self.cap isFirstResponder]) [self.cap resignFirstResponder];
    if ([self.descrizione isFirstResponder]) [self.descrizione resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)pulisciCampi{
        self.nome.text=@"";
        self.nazione.text=@"";
        self.citta.text=@"";
        self.via.text=@"";
        self.numeroCivico.text=@"";
        self.cap.text=@"";
        self.descrizione.text=@"";
}
@end
