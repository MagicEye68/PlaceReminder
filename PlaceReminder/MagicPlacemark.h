//
//  MagicPlacemark.h
//  PlaceReminder
//
//  Created by Marco Corazzini on 22/08/23.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MagicPlacemark : NSObject

@property (nonatomic, strong) NSString *nome;
@property (nonatomic, strong) NSString *nazione;
@property (nonatomic, strong) NSString *citta;
@property (nonatomic, strong) NSString *via;
@property (nonatomic, strong) NSString *numeroCivico;
@property (nonatomic, strong) NSString *cap;
@property (nonatomic, strong) NSString *descrizione;
@property (nonatomic, strong)  NSString  *data;
@property (nonatomic, assign) float latitudine;
@property (nonatomic, assign) float longitudine;

- (instancetype)initWithNome:(NSString *)nome
                     nazione:(NSString *)nazione
                       citta:(NSString *)citta
                         via:(NSString *)via
                numeroCivico:(NSString *)numeroCivico
                         cap:(NSString *)cap
                 descrizione:(NSString *)descrizione
                        data:(NSString *)data
                  latitudine:(float)latitudine
                 longitudine:(float)longitudine;

-(instancetype) initWithNome: (NSString *)nome
                 Descrizione:(NSString *)descrizione
                        Data:(NSString *)data
                   Placemark:(CLPlacemark *)placemark;

-(BOOL)isEqual:(MagicPlacemark*)p;

@end

NS_ASSUME_NONNULL_END
