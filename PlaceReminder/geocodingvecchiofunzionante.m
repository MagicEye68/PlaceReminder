//
//  geocodingvecchiofunzionante.m
//  PlaceReminder
//
//  Created by Marco Corazzini on 22/08/23.
//

#import "geocodingvecchiofunzionante.h"

@implementation geocodingvecchiofunzionante

-(void)performForwardGeocoding {
    
  CLGeocoder *geocoder = [[CLGeocoder alloc] init];
  NSString *address = [NSString stringWithFormat:@"Via %@, %@, %@ %@, %@", self.via.text, self.numeroCivico.text, self.cap.text, self.citta.text, self.nazione.text];
  [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark*>* _Nullable placemarks, NSError * _Nullable error) {
      
      if (error) {
          NSLog(@"Forward geocoding error: %@", error.localizedDescription);
      
          return;
      }
      if (placemarks.count > 0) {
          CLPlacemark *placemark = [placemarks firstObject];
          CLLocation *location = placemark.location;
          NSLog(@"Coordinates: %f, %f", location.coordinate.latitude, location.coordinate.longitude);
          latitudine=location.coordinate.latitude;
          longitudine=location.coordinate.latitude;
      }
      else {
          NSLog(@"No placemarks found");
      }
        }];
}


@end
