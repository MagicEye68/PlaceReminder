//
//  ViewControllerTable.h
//  PlaceReminder
//
//  Created by Marco Corazzini on 23/08/23.
//

#import <UIKit/UIKit.h>
#import "ListaPlacemark.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewControllerTable : UIViewController
@property (nonatomic, strong) ListaPlacemark* lista;
@end

NS_ASSUME_NONNULL_END
