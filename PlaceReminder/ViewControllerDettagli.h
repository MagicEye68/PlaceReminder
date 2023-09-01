//
//  ViewControllerDettagli.h
//  PlaceReminder
//
//  Created by Marco Corazzini on 24/08/23.
//

#import <UIKit/UIKit.h>
#import "ListaPlacemark.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewControllerDettagli : UIViewController
@property (nonatomic, strong) ListaPlacemark* lista;
@property (readwrite, nonatomic) NSUInteger index;
@end

NS_ASSUME_NONNULL_END
