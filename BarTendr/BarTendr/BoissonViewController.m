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
@property NSString * stringNext;
@property UIAlertView *alert;
@end

@implementation boissonViewController
@synthesize data;
@synthesize boissonLabel;
@synthesize labelTable;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    labelTable.text = numberTable;
    
    // Affichage d'un petit Pop-Up d'attente, a finaliser ...
    _alert = [[UIAlertView alloc] initWithTitle:@"Downloading content\nPlease Wait..."message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alert show];
    
    // Description de l'URL, j'ai mis l'url de Fabrigli pour avoir une liste de categories ^^, on la changera apres :)
    NSURL * url = [NSURL URLWithString:@"http://v-marquet.bitbucket.org/bartendr/menu.json"];
    
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
    data = [[NSMutableArray alloc]initWithObjects: @"LOL",@"Bières", @"Vins", @"Vodka",nil];
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
            
            NSLog(@"%@", _dictionnaire);
            
            // PARSING JSON
            
               if ([_dictionnaire isKindOfClass:[NSArray class]]){
                    //Parcours du Json
                    for (NSDictionary *dictionary in _dictionnaire) {
                        
                        Categorie * categorie = [[Categorie alloc] init];
                        categorie.id_categorie = [[dictionary objectForKey:@"id"]integerValue];
                        NSLog(@"id = %ld",categorie.id_categorie);
                        categorie.nom_categorie = [dictionary objectForKey:@"name"];
                        NSLog(@"name = %@", categorie.nom_categorie);
                        [data addObject:categorie.nom_categorie];
                        NSLog(@"%@", data);
                }
                //Affichage de la liste des donnees pour la liste des categories ^^afficher dans le terminal
                   
                NSLog(@"%@", data);
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
    
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleCell.text = [data objectAtIndex:indexPath.row];
    return cell;
    
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toto"]){
        //UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        listeBoissonViewController *controller = [segue destinationViewController];
        controller.boissonType = _stringNext;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSLog(@"Row Selected > %ld: %@", (long)indexPath.item, data[indexPath.item]);
    _stringNext = data[indexPath.item];
    
    [self performSegueWithIdentifier:@"toto" sender:self.view];
    //boissonLabel.text = data[indexPath.item];
}



@end
