//
//  Article.h
//  BarTendr
//
//  Created by Patouz on 23/01/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Categorie.h"

@interface Article : NSObject {
    
    unsigned int id_boisson;
    NSString * nom_boisson;
    NSString * boisson_description;
    float prix;
    unsigned int volume_boisson;
    NSString * urlImage;
    Categorie * categorie;
    
}

@property (nonatomic) unsigned int id_boisson;
@property (nonatomic, retain) NSString * nom_boisson;
@property (nonatomic, retain) NSString * boisson_description;
@property (nonatomic) float prix;
@property (nonatomic) unsigned int volume_boisson;
@property (nonatomic, retain) Categorie * categorie;
@property (nonatomic, retain) NSString * urlImage;



@end
