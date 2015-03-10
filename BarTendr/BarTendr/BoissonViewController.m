//
//  boissonViewController.m
//  BarTendr
//
//  Created by ESIEA on 21/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import "boissonViewController.h"
#import "listeBoissonViewController.h"
#import "Globals.h"
#import "Categorie.h"

@interface boissonViewController ()

@property NSMutableData * donnes;
@property NSArray * dictionnaire;
@property NSString * nomCat;
@property unsigned int idCat;
@property UIAlertView *alert;
@property(nonatomic) NSInteger cancelButtonIndex;
@end

@implementation boissonViewController
@synthesize data;
@synthesize boissonLabel;
@synthesize labelTable;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Affichage d'un petit Pop-Up d'attente, a finaliser ...
    _alert = [[UIAlertView alloc] initWithTitle:@"Téléchargement en cours.\nVeuillez patienter..."message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alert show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    NSString * message_table = [NSString stringWithFormat:@"N°%d", numberTable];
    labelTable.text = message_table;
    
    // Description de l'URL, j'ai mis l'url de Fabrigli pour avoir une liste de categories ^^, on la changera apres :)
    NSURL * url = [NSURL URLWithString:@"http://176.182.204.12/categories.json"];
    // Adresse NICO : http://176.182.204.12/categories.json
    // Adresse RASP : http://192.168.42.1:3000/categories.json
    
    
    //Création de la requete web à l'aide de NSURLRequest
    NSURLRequest * requete = [NSURLRequest requestWithURL:url];
    
    // Connexion
    NSURLConnection * connexion = [[NSURLConnection alloc] initWithRequest:requete delegate:self];
    if(connexion !=nil){
        NSLog(@"OK, Connected");
    }
    else{
        NSLog(@"FAIL TO CONNECT");
    }
    
    // Initialisation de la TableView
    data = [[NSMutableArray alloc]initWithObjects:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"He press OK");
        [self viewWillAppear:true];
    }
}

#pragma mark NSURLConnectionDelegate
// On verifie que la connexion n'a pas FAIL, sinon affichage dans le terminal du message d'erreur obtenu
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Erreur ===>  %@  <====== Fin Erreur", error);
    
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    
    _alert = [[UIAlertView alloc] initWithTitle:nil message:@"Une erreur de connexion s'est produite.\n\nVeuillez vous déplacer dans une zone avec une meilleure réception et réessayer. Appuyez sur le bouton pour vous reconnecter." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [_alert show];
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
            
            // PARSING JSON
            
            if ([_dictionnaire isKindOfClass:[NSArray class]]){
                //Parcours du Json
                for (NSDictionary *dictionary in _dictionnaire) {
                    Categorie * categorie = [[Categorie alloc] init];
                    categorie.id_categorie = [[dictionary objectForKey:@"id"]integerValue];
                    categorie.nom_categorie = [dictionary objectForKey:@"name"];
                    categorie.url_img_categorie = [dictionary objectForKey:@"picture_url"];
                    
                    if (![categorie.url_img_categorie isEqual:[NSNull null]]) {
                        NSString * url_dl = [NSString stringWithFormat:@"http://176.182.204.12%@",categorie.url_img_categorie];
                        categorie.imgCat = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: url_dl]]];
                    }
                    [data addObject:categorie];
                    NSLog(@"Catégorie: %@ url :%@", categorie.nom_categorie, categorie.url_img_categorie);
                }
                //Affichage de la liste des donnees pour la liste des categories ^^afficher dans le terminal
                [self.tableView reloadData];
                [_alert dismissWithClickedButtonIndex:0 animated:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Categorie * my_categorie = [data objectAtIndex:indexPath.row];
    
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // AFFECTATION DES CHAMPS NOM ET IMAGE DES CELLULES CATEGORIES
    cell.titleCell.text = my_categorie.nom_categorie;
    
    // Récupération Image Categorie, si pas d'URL = image par defaut logo.png
    if (![my_categorie.url_img_categorie isEqual:[NSNull null]]) {
        cell.imageCell.image = my_categorie.imgCat;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Categorie * my_categorie = data[indexPath.item];
    
    _nomCat = my_categorie.nom_categorie;
    _idCat = my_categorie.id_categorie;
    
    [self performSegueWithIdentifier:@"categorieToBoisson" sender:self.view];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"categorieToBoisson"]){
        listeBoissonViewController *controller = [segue destinationViewController];
        controller.boissonType = _nomCat;
        controller.idCategorie = _idCat;
    }
}

@end
