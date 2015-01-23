//
//  listeBoissonViewController.m
//  BarTendr
//
//  Created by ESIEA on 28/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import "listeBoissonViewController.h"
#import "Globals.h"
#import "Categorie.h"

@interface listeBoissonViewController ()
@property UIAlertView *alert;
@property NSMutableData * donnes;
@property NSArray * dictionnaire;

@end

@implementation listeBoissonViewController
@synthesize data2;
@synthesize labelTitre;
@synthesize boissonType;
@synthesize labelTable;
@synthesize SelectedIndex;
@synthesize idCategorie;

int indexSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SelectedIndex = -1;
    labelTable.text = numberTable;
    labelTitre.text = boissonType;
    NSLog(@"boissonType = %@", boissonType);
    NSLog(@"%u", idCategorie);
    
    // Affichage d'un petit Pop-Up d'attente, a finaliser ...
    _alert = [[UIAlertView alloc] initWithTitle:@"Téléchargement en cours.\nVeuillez patienter..."message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alert show];
    
    NSInteger rowPressed = idCategorie;
    
    // Description de l'URL, j'ai mis l'url de Fabrigli pour avoir une liste de categories ^^, on la changera apres :)
    NSString * url = [NSString stringWithFormat:@"http://v-marquet.bitbucket.org/bartendr/categories/%d.json", rowPressed];
    
    NSURL *urll = [NSURL URLWithString:url];
    
    //Création de la requete web à l'aide de NSURLRequest
    NSURLRequest * requete = [NSURLRequest requestWithURL:urll];
    
    // Connexion
    NSURLConnection * connexion = [[NSURLConnection alloc] initWithRequest:requete delegate:self];
    if(connexion !=nil){
        NSLog(@"OK, Connected");
    }
    else{
        NSLog(@"FAIL TO CONNECT");
    }
    
    // Initialisation de la TableView
    data2 = [[NSMutableArray alloc]initWithObjects:nil];
    
    /*
    // Initialisation de la TableView
    data2 = [[NSMutableArray alloc]initWithObjects:@"Heineken", @"Kronenbourg", @"Grimbergen", @"Leffe Blonde", @"Leffe Ruby", @"Kilkenny", @"Guiness", nil];
     */
}

#pragma mark NSURLConnectionDelegate
// On verifie que la connexion n'a pas FAIL, sinon affichage dans le terminal du message d'erreur obtenu
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Erreur ===>  %@  <====== Fin Erreur", error);
    
}
// Verification pour voir si on a reçu une réponse
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _donnes = [[NSMutableData alloc] init];
}
// On regarde si on reçoit des données ^^
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)dat {
    if(_donnes!= nil){
        [_donnes appendData:dat];
    }
}
// On test pour voir si on a bien fini de recevoir les données //
// Ensuite on traite les données reçu afin d'avoir un "vrai" json et on l'affiche dans le terminal
- (void) connectionDidFinishLoading : (NSURLConnection *) connection {
    
    if(_donnes){
        NSError * erreur = nil;
        _dictionnaire = [NSJSONSerialization JSONObjectWithData:_donnes options:NSJSONReadingMutableContainers error:&erreur];
        // on verifie que cela ne génère pas d'erreur
        if(erreur!=nil){
            NSLog(@"Erreur lors de la création du JSON!");
        }
        // On test pour voir si notre dictionnaire est bien un JSON
        if([NSJSONSerialization isValidJSONObject:_dictionnaire]){
            // On va donc pouvoir "Déserialiser" le JSON, et donc recupérer les infos nécéssaire au remplissage de nos TableView :)
            // Pour le moment je l'affiche dans le terminal (test)
            
            NSLog(@"Mon JSON : \n %@", _dictionnaire);
            
            // PARSING JSON
            
            if ([_dictionnaire isKindOfClass:[NSArray class]]){
                //Parcours du Json
                for (NSDictionary *dictionary in _dictionnaire) {
                    Categorie * categorie = [[Categorie alloc] init];
                    categorie.id_categorie = [[dictionary objectForKey:@"id"]integerValue];
                    categorie.nom_categorie = [dictionary objectForKey:@"name"];
                    [data2 addObject:categorie.nom_categorie];
                }
                //Affichage de la liste des donnees pour la liste des categories ^^afficher dans le terminal
                [self.tableView2 reloadData];
                NSLog(@"Ma Liste de données : %@", data2);
                [_alert dismissWithClickedButtonIndex:0 animated:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)section2 {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section2 {
    return [data2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"expendingCell";
    ExpendingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ExpendingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    indexSelected = indexPath.row;
    
    cell.titleCell.text = [data2 objectAtIndex:indexPath.row];
    cell.descLabelCell.text = @"Ceci est un test de description de boisson, ça doit être assez long pour être significatif !";
    //listen for clicks
    [cell.addButton addTarget:self action:@selector(buttonPressed)
     forControlEvents:UIControlEventTouchUpInside];

    return cell;
    
}

-(void)buttonPressed {
    NSLog(@"Button %d Pressed!", indexSelected);
}

-(CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(SelectedIndex == indexPath.row){
        return 180;
    }
    else {
        return 54;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Row at Index > %d: %@", indexPath.row, data2[indexPath.row]);
    
    if(SelectedIndex == indexPath.row){
        SelectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    if(SelectedIndex != -1){
        SelectedIndex = indexPath.row;
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:SelectedIndex inSection:0];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    SelectedIndex = indexPath.row;
    NSLog(@"SelectedIndex = %d", SelectedIndex);
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



@end
