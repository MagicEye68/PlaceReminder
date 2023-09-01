//
//  ViewControllerDettagli.m
//  PlaceReminder
//
//  Created by Marco Corazzini on 24/08/23.
//

#import "ViewControllerDettagli.h"
#import <UserNotifications/UserNotifications.h>
#import "ListaPlacemark.h"
#import "MagicPlacemark.h"


@interface ViewControllerDettagli ()
@property (weak, nonatomic) IBOutlet UIButton *elimina;

@property (weak, nonatomic) IBOutlet UILabel *nome;
@property (weak, nonatomic) IBOutlet UILabel *nazione;
@property (weak, nonatomic) IBOutlet UILabel *citta;
@property (weak, nonatomic) IBOutlet UILabel *via;
@property (weak, nonatomic) IBOutlet UILabel *numeroCivico;
@property (weak, nonatomic) IBOutlet UILabel *cap;
@property (weak, nonatomic) IBOutlet UILabel *descrizione;
@property (weak, nonatomic) IBOutlet UILabel *latitudine;
@property (weak, nonatomic) IBOutlet UILabel *longitudine;

@property (nonatomic, strong) MagicPlacemark *placemark;


@end

@implementation ViewControllerDettagli

- (IBAction)elimina:(id)sender {//pulsante "Elimina"
    UIAlertController *alertController =[UIAlertController
     alertControllerWithTitle:@"PlaceReminder"
     message:@"Placemark eliminato"
     preferredStyle:UIAlertControllerStyleAlert
    ];

  UIAlertAction* rimozione = [UIAlertAction actionWithTitle:@"Ok"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction* _Nonnull rimozione) {
      [self.lista removePlacemark:self.index];//rimuovo il placemark nell'indice corrente
      [self.navigationController popViewControllerAnimated:YES];//pop alla lista dei placemark
      
  }];

      [alertController addAction:rimozione];
      [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self popolaTabella];
}

-(void)popolaTabella{
    self.placemark = [self.lista getPlacemarkAtIndex:self.index];
    self.nome.text = self.placemark.nome;
    self.nazione.text = self.placemark.nazione;
    self.citta.text = self.placemark.citta;
    self.via.text = self.placemark.via;
    self.numeroCivico.text = self.placemark.numeroCivico;
    self.cap.text = self.placemark.cap;
    self.descrizione.text = self.placemark.descrizione;
    self.latitudine.text = [NSString stringWithFormat:@"%f", self.placemark.latitudine];
    self.longitudine.text = [NSString stringWithFormat:@"%f", self.placemark.longitudine];
}

@end
