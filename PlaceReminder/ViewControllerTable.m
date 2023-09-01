//
//  ViewControllerTable.m
//  PlaceReminder
//
//  Created by Marco Corazzini on 23/08/23.
//

#import "ViewControllerTable.h"
#import "ViewControllerDettagli.h"

@interface ViewControllerTable ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabella;

@end

@implementation ViewControllerTable
//ViewController per visualizzare la loista dei placemark
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabella.dataSource = self;
    self.tabella.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tabella reloadData];
}
//setto la dimensione della tabella
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.lista size];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //setto la cella nell'indice corrente
    UITableViewCell* cella = [tableView dequeueReusableCellWithIdentifier:@"identificatoreCella"        forIndexPath:indexPath];
    NSArray<MagicPlacemark*>* array = [self.lista getLista];
    MagicPlacemark* oggetto = [array objectAtIndex:indexPath.row];
    cella.textLabel.text = oggetto.nome;
    cella.detailTextLabel.text = [NSString stringWithFormat:@"%@",oggetto.data];
    return cella;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //passo i dati al viewController per visualizzare i dettagli di ogni placemark
    if ([segue.identifier isEqualToString:@"segueDettagli"]) {
        if([segue.destinationViewController isKindOfClass:[ViewControllerDettagli class]]){
            NSUInteger indexPath = [self.tabella indexPathForCell:sender].row;
            ViewControllerDettagli* view=(ViewControllerDettagli*)segue.destinationViewController;
            view.lista=self.lista;
            view.index=indexPath;
        }        
    }
}
@end
