//
// ShopCellInfo.h
// EthicalShop
//
// Created by 명철 성 on 2/3/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface ShopCellInfo : NSObject
{
    NSString *shops_id; //가게번호
    UIImage *photoImage; //실제 이미지
    NSString *shop_name; //가게이름
    NSString *photoLink; //이미지 주소
    NSString *summary; //한줄 설명
    NSInteger shop_type; //가게 분류
}

@property (nonatomic, retain) NSString *shops_id;
@property (nonatomic, retain) UIImage *photoImage;
@property (nonatomic, retain) NSString *shop_name;
@property (nonatomic, retain) NSString *photoLink;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic) NSInteger shop_type;


@end