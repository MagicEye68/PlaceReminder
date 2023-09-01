//
//  ListaPlacemark.h
//  PlaceReminder
//
//  Created by Marco Corazzini on 22/08/23.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MagicPlacemark.h"


NS_ASSUME_NONNULL_BEGIN

@interface ListaPlacemark : NSObject <MKAnnotation>

-(instancetype)init ;
-(void)addPlacemark:(MagicPlacemark*) p ;
-(void)removePlacemark:(NSUInteger) index ;
-(NSInteger)size;
-(NSMutableArray <MagicPlacemark*>*)getLista;
-(MagicPlacemark*)getPlacemarkAtIndex:(NSUInteger)index;
-(NSUInteger)getIndexForPlacemark:(MagicPlacemark*)p;

@end

NS_ASSUME_NONNULL_END
