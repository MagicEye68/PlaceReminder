//
//  MagicPlacemark.m
//  PlaceReminder
//
//  Created by Marco Corazzini on 22/08/23.
//

#import "MagicPlacemark.h"
#import <CoreLocation/CoreLocation.h>

@implementation MagicPlacemark
//un MagicPlacemark e' un placemark.

- (instancetype)initWithNome:(NSString *)nome
                     nazione:(NSString *)nazione
                       citta:(NSString *)citta
                         via:(NSString *)via
                numeroCivico:(NSString *)numeroCivico
                         cap:(NSString *)cap
                 descrizione:(NSString *)descrizione
                        data:(NSString *)data
                  latitudine:(float)latitudine
                 longitudine:(float)longitudine{
    self = [super init];
    if (self) {//costruttore
        _nome = [nome copy];
        _nazione = [nazione copy];
        _citta = [citta copy];
        _via = [via copy];
        _numeroCivico = [numeroCivico copy];
        _cap = [cap copy];
        _descrizione = [descrizione copy];
        _data = [data copy];
        _latitudine = latitudine;
        _longitudine = longitudine;
    }
    return self;
}
-(instancetype) initWithNome: (NSString *)nome
                 Descrizione: (NSString *)descrizione
                        Data: (NSString *)data
                   Placemark: (CLPlacemark *)placemark{
    
    self = [super init];
    if (self) {//costruttore
        _nome = [nome copy];
        _nazione = [placemark.country copy];
        _citta = [placemark.locality copy];
        _via = [placemark.thoroughfare copy];
        _numeroCivico = [placemark.subThoroughfare copy];
        _cap = [placemark.postalCode copy];
        _descrizione = [descrizione copy];
        _data = [data copy];
        _latitudine = placemark.location.coordinate.latitude;
        _longitudine = placemark.location.coordinate.longitude;
    }
    return self;
}
-(CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.latitudine, self.longitudine);
}
-(NSString*)title{//metodo per il nome dell'annotation
    return self.nome;
}
-(NSString*)subtitle{//metodo per la descrizione dell'annotation
    return self.descrizione;
}
-(BOOL)isEqual:(MagicPlacemark*)p{
    return self.latitudine==p.latitudine && self.longitudine==p.longitudine;
}
@end
