//
//  ListaPlacemark.m
//  PlaceReminder
//
//  Created by Marco Corazzini on 22/08/23.
//

#import "ListaPlacemark.h"
#import "MagicPlacemark.h"
@interface ListaPlacemark()
@property (nonatomic,strong) NSMutableArray<MagicPlacemark*> *arrayPlacemarks;
@end

@implementation ListaPlacemark
//ListaPlacemark e' un NSMutableArray di MagicPlacemark.
-(instancetype)init {
    _arrayPlacemarks = [[NSMutableArray<MagicPlacemark*> alloc] init];
    return self;
}
-(void)addPlacemark:(MagicPlacemark*) p {
    [self.arrayPlacemarks insertObject:p atIndex:0];
    NSDictionary* dizionario = @{//viene utilizzato per far ricevere la notifica al MainViewController
        @"placemark": p
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Placemark Aggiunto" object:nil userInfo:dizionario];
}

-(void)removePlacemark:(NSUInteger) index {
    NSDictionary* dizionario = @{
        @"placemark":[self.arrayPlacemarks objectAtIndex:index]
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Placemark Rimosso" object:nil userInfo:dizionario];
    [self.arrayPlacemarks removeObjectAtIndex:index];
}
-(NSInteger)size{
    return self.arrayPlacemarks.count;
}
-(NSMutableArray <MagicPlacemark*>*)getLista{
    return self.arrayPlacemarks;
}
-(MagicPlacemark*)getPlacemarkAtIndex:(NSUInteger)index{
    return [self.arrayPlacemarks objectAtIndex:index];
}
-(NSUInteger)getIndexForPlacemark:(MagicPlacemark*)p{
    NSUInteger i = 0;
    for (MagicPlacemark* elem in self.arrayPlacemarks) {
        if([p isEqual:elem]) break;
        i=i+1;
    }
    return i;
}
@synthesize coordinate;

@end
