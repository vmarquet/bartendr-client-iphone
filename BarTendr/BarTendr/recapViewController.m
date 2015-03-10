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
@synthesize tableView3;
@synthesize data3;
@synthesize labelTable;
@synthesize prixTotal;
@synthesize modifyButton;
@synthesize payButton;

float prix;
int SelectedIndex;
bool modiFlag;

- (void)viewDidLoad {
    [super viewDidLoad];
    labelTable.text = [NSString stringWithFormat:@"N°%d",numberTable];
    data3 = commande.liste_article;
    modiFlag = NO;
    
    [commande calculTotalCommande:commande];
    NSString *strPrix = [NSString stringWithFormat:@"Total : %.2f €",commande.total];
    prixTotal.text = strPrix;
    
    //Affichage des article de la commane en console + calcul du prix total de la commande
    [commande calculTotalCommande:commande];
    NSLog(@"%.2f", commande.total);
    
    if([data3 count] == 0){
        modifyButton.hidden = YES;
        payButton.hidden = YES;
    }
    if([data3 count] != 0){
        modifyButton.hidden = NO;
        payButton.hidden = NO;
    }
    
    [payButton addTarget:self action:@selector(payPressed:)
                forControlEvents:UIControlEventTouchUpInside];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath3 {
    
    static NSString *CellIdentifier3 = @"RecapCell";
    RecapCell *cell3 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
    
    if(cell3 == nil){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RecapCell" owner:self options:nil];
        cell3 = [nib objectAtIndex:0];
    }
    
    if(modiFlag == NO) {
        cell3.suppression.hidden = YES;
        [modifyButton setTitle:@"Modifier" forState:UIControlStateNormal];
    }
    else {
        cell3.suppression.hidden = NO;
       [modifyButton setTitle:@"OK" forState:UIControlStateNormal];
    }
    
    Article * obj;
    obj = [[Article alloc] init];
    
    obj = [data3 objectAtIndex:indexPath3.row];
    cell3.nomBoisson.text = obj.nom_boisson;
    cell3.prixBoisson.text = [NSString stringWithFormat:@"%.2f €",obj.prix];
    
    if ((![obj.urlImage isEqual:[NSNull null]])) {
        cell3.imageBoisson.image = obj.imgBoisson;
    }
    SelectedIndex = indexPath3.row;
    
    [cell3.suppression addTarget:self action:@selector(buttonPressed2:)
             forControlEvents:UIControlEventTouchUpInside];
    
    return cell3;
    
}

//Bouton "modifier" pressé
- (IBAction)modifyPressed:(id)sender {

    if(modiFlag == NO) {
        modiFlag = YES;
    } else {
        modiFlag = NO;
    }
    [tableView3 reloadData];
}

//Bouton "supprimer" lors de la modif pressé
-(void) buttonPressed2:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView3];
    NSIndexPath *indexLocal = [self.tableView3 indexPathForRowAtPoint:buttonPosition];
    SelectedIndex = indexLocal.row;
    [data3 objectAtIndex:SelectedIndex];
    [data3 removeObjectAtIndex:SelectedIndex];
    [self.tableView3 reloadData];
    [commande calculTotalCommande:commande];
    prixTotal.text = [NSString stringWithFormat:@"Total : %.2f €",commande.total];;
    
    if([data3 count] == 0){
        modifyButton.hidden = YES;
        payButton.hidden = YES;
    }
    else {
        modifyButton.hidden = NO;
        payButton.hidden = NO;
    }
}

//Bouton "payer" pressé
-(IBAction)payPressed:(id)sender {
    totalString = [NSString stringWithFormat:@"%.2f",commande.total];
    numCommande = @"ABC";
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
