//
//  File.swift
//  
//
//  Created by Gustavo Vergara on 29/09/23.
//

import Foundation

enum GetStoreMenuStubs {
    static var storeAJSONString: String {
        """
        {
            "store_id": "0",
            "store_name": "Loja A",
            "products": [
                {
                    "id": "espresso",
                    "name": "Espresso",
                    "description": "Café feito com agua quente sob pressão.",
                    "photo": "https://globalassets.starbucks.com/digitalassets/products/bev/SBX20190617_Espresso_Single.jpg?impolicy=1by1_wide_topcrop_630",
                    "skus": [
                        {
                            "id": "espresso-d",
                            "price": 8,
                            "attributes": {
                                "tamanho": "Duplo 120ml"
                            }
                        },
                        {
                            "id": "espresso-s",
                            "price": 6,
                            "attributes": {
                                "tamanho": "Curto 60ml"
                            }
                        }
                    ],
                    "all_attributes" : [
                        {
                            "key": "tamanho",
                            "name": "Tamanho"
                        }
                    ]
                }
            ]
        }
        """
    }
}
