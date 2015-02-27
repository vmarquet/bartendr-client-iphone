//
//  recapViewController.m
//  BarTendr
//
//  Created by ESIEA on 28/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import "recapViewController.h"
#import "Globals.h"
#import "Commande.h"

@interface recapViewController ()

@end

@implementation recapViewController
@synthesize data3;
@synthesize labelTable;
@synthesize prixTotal;

float prix;

- (void)viewDidLoad {
    [super viewDidLoad];
    labelTable.text = numberTable;
    data3 = commande.liste_article;
    
    [commande calculTotalCommande:commande];
    NSString *strPrix = [NSString stringWithFormat:@"%.2f €",commande.total];
    prixTotal.text = strPrix;
    
    //Affichage des article de la commane en console + calcul du prix total de la commande
    [commande calculTotalCommande:commande];
    NSLog(@"%.2f", commande.total);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)section3 {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView3 numberOfRowsInSection:(NSInteger)section3 {
    return [data3 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView3 cellForRowAtIndexPath:(NSIndexPath *)indexPath3 {
    
    static NSString *CellIdentifier3 = @"RecapCell";
    RecapCell *cell3 = [tableView3 dequeueReusableCellWithIdentifier:CellIdentifier3];
    
    if(cell3 == nil){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RecapCell" owner:self options:nil];
        cell3 = [nib objectAtIndex:0];
    }
    
    NSString * strPrix = [NSString alloc];
    Article * obj;
    obj = [[Article alloc] init];
    
    obj = [data3 objectAtIndex:indexPath3.row];
    cell3.nomBoisson.text = obj.nom_boisson;
    strPrix = [strPrix initWithFormat:@"%.2f€", obj.prix];
    cell3.prixBoisson.text = strPrix;
    
    return cell3;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (void)tableView:(UITableView *)tableView3 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Article * obj = [[Article alloc] init];
    obj = [data3 objectAtIndex:indexPath.row];
    [data3 removeObjectAtIndex: indexPath.row];
    [self.tableView3 reloadData];
    [commande calculTotalCommande:commande];
    NSLog(@"%.2f", commande.total);
    NSString *strPrix = [NSString stringWithFormat:@"%.2f €",commande.total];
    prixTotal.text = strPrix;
    

}

@end
