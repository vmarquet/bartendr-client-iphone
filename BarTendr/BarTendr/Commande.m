//
//  Commande.m
//  BarTendr
//
//  Created by ESIEA on 23/01/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import "Commande.h"

@implementation Commande

@synthesize total, liste_article, numberTable;


- (float) calculTotalCommande :(Commande *) commande
{
    commande.total = 0;
    for (Article * article in commande.liste_article) {
        commande.total += article.prix;
    }
    return commande.total;
}

@end
