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
#import <UIKit/UIKit.h>

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
    
    // Affichage d'un petit Pop-Up d'attente, a finaliser ...
    _alert = [[UIAlertView alloc] initWithTitle:@"Téléchargement en cours.\nVeuillez patienter..."message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alert show];
    [_alert setTag:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    SelectedIndex = -1;
    labelTable.text = [NSString stringWithFormat:@"N°%d",numberTable];
    labelTitre.text = boissonType;
    NSLog(@"boissonType = %@", boissonType);
    NSLog(@"%u", idCategorie);
    
    NSInteger rowPressed = idCategorie;
    
    // Description de l'URL, j'ai mis l'url de Fabrigli pour avoir une liste de categories ^^, on la changera apres :)
    NSString * url = [NSString stringWithFormat:@"http://176.182.204.12/categories/%d.json", rowPressed];
    
    // Adresse final :http://176.182.204.12/categories/%d.json
    // Adresse Rasp : http://192.168.42.1:3000/categories/%d.json
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex ==0){
        NSLog(@"He Pressed OK");
        [super viewWillAppear:TRUE];
    }
}

#pragma mark NSURLConnectionDelegate
// On verifie que la connexion n'a pas FAIL, sinon affichage dans le terminal du message d'erreur obtenu
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Erreur ===>  %@  <====== Fin Erreur", error);
    
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    
    _alert = [[UIAlertView alloc] initWithTitle:nil message:@"Une erreur de connexion s'est produite.\n\nVeuillez vous déplacer dans une zone avec une meilleure réception et réessayer. Appuyez sur le bouton pour vous reconnecter." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
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
            NSLog(@"%@", _dictionnaire);
            
            if ([_dictionnaire isKindOfClass:[NSArray class]]){
                //Parcours du Json
                for (NSDictionary *dictionary in _dictionnaire) {
                    article = [[Article alloc] init];
                    article.id_boisson = [[dictionary objectForKey:@"id"]integerValue];
                    article.nom_boisson = [dictionary objectForKey:@"name"];
                    article.boisson_description = [dictionary objectForKey:@"description"];
                    article.volume_boisson = [[dictionary objectForKey:@"size"]integerValue];
                    article.prix = [[dictionary objectForKey:@"price"]floatValue];
                    article.urlImage = [dictionary objectForKey:@"picture_url"];
                    
                    // AJOUT DE L'IMAGE SI ON A EU L'URL DE L'IMAGE ! Et par defaut Bières.png si pas d'url
                    if (![article.urlImage isEqual:[NSNull null]]) {
                        NSString * url_dl = [NSString stringWithFormat:@"http://176.182.204.12%@",article.urlImage];
                        article.imgBoisson = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: url_dl]]];
                    }
                    
                    [data2 addObject:article];
                    NSLog(@"boisson : %@, url : %@", article.nom_boisson, article.urlImage);
                }
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
        cell.commentTextField.hidden = NO;
        cell.labelCom.hidden = NO;
    }
    
    cell.titleCell.text = my_article.nom_boisson;
    cell.descLabelCell.text = my_article.boisson_description;
    if(SelectedIndex == indexPath.row){
        cell.descLabelCell.hidden = NO;
        cell.descCell.hidden = NO;
        cell.addButton.hidden = NO;
        cell.commentTextField.hidden = NO;
        cell.labelCom.hidden = NO;
    }else{
        cell.descLabelCell.hidden = YES;
        cell.descCell.hidden = YES;
        cell.addButton.hidden = YES;
        cell.commentTextField.hidden = YES;
        cell.labelCom.hidden = YES;
    }
    
    
    NSString * prix = [NSString stringWithFormat:@"%.2f €",my_article.prix];
    cell.priceLabelCell.text = prix;
    
    // AJOUT DE L'IMAGE SI ON A EU L'URL DE L'IMAGE A completer ! Et par defaut Bières.png si pas d'url
    if (![my_article.urlImage isEqual:[NSNull null]]) {
        cell.imageCell.image = my_article.imgBoisson;
    }
    //listen for clicks
    [cell.addButton addTarget:self action:@selector(buttonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

//Action lors d'un clic sur le bouton d'ajout
-(void)buttonPressed:(id)sender {
    
    // on crée un article pour récupérer les données à la case selectionné.
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView2];
    NSIndexPath *indexLocal = [self.tableView2 indexPathForRowAtPoint:buttonPosition];
    indexSelected = indexLocal.row;
    
    Article * art = [data2 objectAtIndex:indexSelected];
    
    // Affichage du "TOAST" d'ajout à la commande avec message en fonction de la boisson choisie
    NSString * alertMessage = [NSString stringWithFormat:@"%@ a bien été ajouté au panier.", art.nom_boisson];
    UIAlertView * alertAddBoisson;
    alertAddBoisson = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    NSLog(@"%@",cell.commentTextField.text);
    [commande.liste_article addObject:art];
    
    [alertAddBoisson show];
    [alertAddBoisson dismissWithClickedButtonIndex:0 animated:YES];
}

//Définition de la taille de la cellule à la ligne = indexPath
-(CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"expendingCell";
    ExpendingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //cellule sur laquelle on a cliqué ou non ?
    if(SelectedIndex == indexPath.row){
        return 180;
    }else {
        cell.descLabelCell.hidden = YES;
        cell.descCell.hidden = YES;
        cell.addButton.hidden = YES;
        cell.commentTextField.hidden = YES;
        cell.labelCom.hidden = YES;
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
        cell.commentTextField.hidden = YES;
        cell.labelCom.hidden = YES;
        
        SelectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    //Il existe déjà une autre cellule ouverte
    if(SelectedIndex != -1){
        SelectedIndex = indexPath.row;
        ExpendingCell *previousCell = (ExpendingCell*)[tableView cellForRowAtIndexPath:prevPath];
        previousCell.descLabelCell.hidden = YES;
        previousCell.descCell.hidden = YES;
        previousCell.addButton.hidden = YES;
        previousCell.commentTextField.hidden = YES;
        previousCell.labelCom.hidden = YES;

        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //Sauvegarde des indices
    SelectedIndex = indexPath.row;
    prevIndex = SelectedIndex;
    prevPath = indexPath;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



@end
