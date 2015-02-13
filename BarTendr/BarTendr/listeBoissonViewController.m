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
#import "Article.h"

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
int prevIndex = -1;
NSIndexPath *prevPath;
Article * article;

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
                    article = [[Article alloc] init];
                    article.id_boisson = [[dictionary objectForKey:@"id"]integerValue];
                    article.nom_boisson = [dictionary objectForKey:@"name"];
                    article.boisson_description = [dictionary objectForKey:@"description"];
                    article.volume_boisson = [dictionary objectForKey:@"size"];
                    article.prix = [[dictionary objectForKey:@"price"]integerValue];
                    [data2 addObject:article];
                    // Affichage du details de chaque boisson
                    NSLog(@"Mes données article : id= %d, nom= %@, volume= %@, prix= %.2f €, description= %@"
                          , article.id_boisson, article.nom_boisson,article.volume_boisson, article.prix,article.boisson_description);
                }
                //Affichage de la liste des donnees pour la liste des categories ^^afficher dans le terminal
                [self.tableView2 reloadData];
                [_alert dismissWithClickedButtonIndex:0 animated:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Définition du nombre de section de la tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)section2 {
    return 1;
}

//Définition du nombre de lignes de la tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section2 {
    return [data2 count];
}

//Définition d'une cellule à la ligne = indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //déclaration du type de cellule
    static NSString *CellIdentifier = @"expendingCell";
    ExpendingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ExpendingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //Paramétrage des données de la cellule (label ...)
    indexSelected = indexPath.row;
    Article * my_article = [data2 objectAtIndex:indexPath.row];
    
    if(prevIndex == indexPath.row){
        cell.descLabelCell.hidden = NO;
        cell.descCell.hidden = NO;
        cell.addButton.hidden = NO;
    }
    
    cell.titleCell.text = my_article.nom_boisson;
    cell.descLabelCell.text = my_article.boisson_description;
    if(SelectedIndex == indexPath.row){
        cell.descLabelCell.hidden = NO;
        cell.descCell.hidden = NO;
        cell.addButton.hidden = NO;
    }else{
        cell.descLabelCell.hidden = YES;
        cell.descCell.hidden = YES;
        cell.addButton.hidden = YES;
    }
    
    /*if(indexPath.row == prevIndex && prevIndex != SelectedIndex){
        
        cell.descLabelCell.hidden = YES;
        cell.descCell.hidden = YES;
        cell.addButton.hidden = YES;
    }*/

    
    NSString * prix = [NSString stringWithFormat:@"%.2f €",my_article.prix];
    cell.priceLabelCell.text = prix;
    
    //listen for clicks
    [cell.addButton addTarget:self action:@selector(buttonPressed)
     forControlEvents:UIControlEventTouchUpInside];

    return cell;
    
}

//Action lors d'un clic sur le bouton d'ajout
-(void)buttonPressed {
    NSLog(@"Button %d Pressed!", indexSelected);
    Article * art = [data2 objectAtIndex:indexSelected];
    NSLog(@"Article %@ ajouté au panier !", art.nom_boisson);
    
    // /!\ A compléter quand la structure des JSON sera terminée /!\
    
    //Ajout des données à l'objet Article courant pour l'ajouter à la liste
    Article * article ;
    Article * articleComp;
    bool flag = false;
    article = [[Article alloc] init];
    articleComp = [[Article alloc] init];
    
    article.quantite = 1;
    article.id_boisson = indexSelected;
    article.nom_boisson = art.nom_boisson;
    article.prix = art.prix;

    
    //NSLog(@"\nRECAP:\n");
    for(int i = 0; i < commande.liste_article.count; i++){
        articleComp = [commande.liste_article objectAtIndex:i];
        if(art.id_boisson == articleComp.id_boisson) {
            article.quantite = articleComp.quantite + 1;
            [commande.liste_article replaceObjectAtIndex:i withObject:article];
            flag = true;
            break;
        }
        //NSLog(@"%@", article.nom_boisson);
    }
    
    //NSLog(@"\n%@ x%d, index %d", article.nom_boisson, article.quantite, article.id_boisson);
    
    if(flag == false){
        [commande.liste_article addObject:article];
    }
    //Affichage de la commande en entier en console
    NSLog(@"\nRECAP:\n");
    for(int i = 0; i < commande.liste_article.count; i++){
        article = [commande.liste_article objectAtIndex:i];
        NSLog(@"%@ x %d", article.nom_boisson, article.quantite);
    }
    
}

//Définition de la taille de la cellule à la ligne = indexPath
-(CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"expendingCell";
    ExpendingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //cellule sur laquelle on a cliqué ou non ?
    if(SelectedIndex == indexPath.row){
        //cell.descLabelCell.hidden = NO;
        //cell.descCell.hidden = NO;
        //cell.addButton.hidden = NO;
        return 180;
    }else {
        cell.descLabelCell.hidden = YES;
        cell.descCell.hidden = YES;
        cell.addButton.hidden = YES;
        return 54;
    }
}

//Cellule sur laquelle on a cliqué
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"expendingCell";
    ExpendingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Deuxième clic sur la meme cellule -> fermeture
    if(SelectedIndex == indexPath.row){
        cell.descLabelCell.hidden = YES;
        cell.descCell.hidden = YES;
        cell.addButton.hidden = YES;
        
        SelectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    //Il existe déjà une autre cellule ouverte
    if(SelectedIndex != -1){
        SelectedIndex = indexPath.row;
        //NSIndexPath *prevPath = [NSIndexPath indexPathForRow:SelectedIndex inSection:0];
        ExpendingCell *previousCell = (ExpendingCell*)[tableView cellForRowAtIndexPath:prevPath];
        previousCell.descLabelCell.hidden = YES;
        previousCell.descCell.hidden = YES;
        previousCell.addButton.hidden = YES;
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //Sauvegarde des indices
    SelectedIndex = indexPath.row;
    prevIndex = SelectedIndex;
    prevPath = indexPath;
    
    NSLog(@"SelectedIndex = %d", SelectedIndex);
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



@end
