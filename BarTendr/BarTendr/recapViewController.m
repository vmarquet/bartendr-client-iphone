//
//  recapViewController.m
//  BarTendr
//
//  Created by ESIEA on 28/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import "recapViewController.h"
#import "Globals.h"

@interface recapViewController ()

@end

@implementation recapViewController
@synthesize data3;
@synthesize labelTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    labelTable.text = numberTable;
    
    // TableView
    //data3 = [[NSMutableArray alloc]initWithObjects: @"Grimbergen x1", @"Leffe Blonde x1", @"Kilkenny x1", @"Guiness x2", nil];
    data3 = commande.liste_article;
    
    
    
    /* TEST ENVOI AU SERVEUR c'est moche je c ....*/
     
     NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
     NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
     NSMutableDictionary *article1 = [[NSMutableDictionary alloc]init];
     NSMutableDictionary *article2 = [[NSMutableDictionary alloc]init];
     [article1 setValue:@1 forKey:@"article_id"];
     [article1 setValue:@"Sans glaçon" forKey:@"comments"];
     
     [article2 setValue:@4 forKey:@"article_id"];
     [article2 setValue:@"Avec glaçon" forKey:@"comments"];
     
     NSMutableArray * liste = [[NSMutableArray alloc]initWithObjects:article1,article2, nil];
     
     [dict setValue:@10 forKey:@"table"];
     [dict setValue:liste forKey:@"item_attributes"];
     [dict2 setValue:dict forKey:@"order"];
     
     NSError *error = nil;
     NSData *json;
     NSURL *url = [NSURL URLWithString:@"http://mabite.fr/orders.json"];
     
     // Dictionary convertable to JSON ?
     if ([NSJSONSerialization isValidJSONObject:dict])
     {
     // Serialize the dictionary
     json = [NSJSONSerialization dataWithJSONObject:dict2 options:NSJSONWritingPrettyPrinted error:&error];
     
     // If no errors, let's view the JSON
     if (json != nil && error == nil)
     {
         NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
         NSLog(@"%@", jsonString);
         NSData *postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
         NSMutableURLRequest *requestData = [[NSMutableURLRequest alloc] init];
     
         NSString *number = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)postData.length];
     
         [requestData setURL:url];
     
         [requestData setHTTPMethod:@"POST"];
         [requestData setValue:number forHTTPHeaderField:@"Content-Length"];
         [requestData setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
         [requestData setValue:@"application/json" forHTTPHeaderField:@"Accept"];
         [requestData setHTTPBody:postData];

         NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:requestData delegate:self];
         if(conn) {
             NSLog(@"Connection Successful");
         } else {
             NSLog(@"Connection could not be made");
         }
        }
     }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Erreur ===>  %@  <====== Fin Erreur", error);
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Fini de transmettre les données");
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
    NSString * strQuantite = [NSString alloc];
    Article * obj;
    obj = [[Article alloc] init];
    
    obj = [data3 objectAtIndex:indexPath3.row];
    cell3.nomBoisson.text = obj.nom_boisson;
    strPrix = [strPrix initWithFormat:@"%.2f€", obj.prix];
    cell3.prixBoisson.text = strPrix;
    strQuantite = [strQuantite initWithFormat:@"x %d", obj.quantite];
    cell3.quantiteBoisson.text = strQuantite;
    NSLog(@"%@ %@", strPrix, strQuantite);
    
    //Affichage de la commande en entier en console
    NSLog(@"\nRECAP:\n");
    for(int i = 0; i < commande.liste_article.count; i++){
        obj = [commande.liste_article objectAtIndex:i];
        NSLog(@"%@ x %d", obj.nom_boisson, obj.quantite);
    }
    
    return cell3;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
