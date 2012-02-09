//
// ShopDetailInfoViewController.m
// EthicalShop
//
// Created by Woojin Joe on 1/31/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopDetailInfoViewController.h"
#import "DetailMapViewController.h"
#import "StackMob.h"

@implementation ShopDetailInfoViewController

@synthesize shop_name;
@synthesize photoLink;
@synthesize shops_id;
@synthesize shop_type;
@synthesize numImage;
@synthesize photoImage;
@synthesize resultArray;
@synthesize shopPicArray;

@synthesize nameLabel;
@synthesize mainPhoto;
@synthesize address;
@synthesize number;

@synthesize basicInfoTab;
@synthesize MenuInfoTab;
@synthesize DiscountInfoTab;
@synthesize shopPicInfoTab;
@synthesize pointImg;
@synthesize shopCategoryImage;

@synthesize spinner1;

@synthesize openTime;
@synthesize closedDate;
@synthesize budget;
@synthesize basicView;
@synthesize menuView;
@synthesize discountView;
@synthesize shopPicView;
@synthesize shopPicScrollView;
@synthesize menuInfoTextView;
@synthesize discountTextVIew;

const CGFloat SCROLLOBJHEIGTH	= 160.0;
const CGFloat SCROLLOBJWIDTH	= 280.0;

#pragma mark - View Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization       
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.shop_name;
    nameLabel.text = self.shop_name;    
    shopPicArray = [[NSMutableArray alloc] init];
    switch (self.shop_type) {
        case 1:
            self.shopCategoryImage.image = [UIImage imageNamed:@"ES_shopTable_icon_funnjoy"];
            break;
        case 2:
            self.shopCategoryImage.image = [UIImage imageNamed:@"ES_shopTable_icon_food"];
            break;
        case 3:
            self.shopCategoryImage.image = [UIImage imageNamed:@"ES_shopTable_icon_etc"];
            break;
        case 4:
            self.shopCategoryImage.image = [UIImage imageNamed:@"ES_shopTable_icon_shopping"];
            break;
        case 5:
            self.shopCategoryImage.image = [UIImage imageNamed:@"ES_shopTable_icon_etc"];
            break;                
        default:
            break;
    }
    
    // Do any additional setup after loading the view from its nib.
    StackMobQuery *q = [StackMobQuery query];
    [q field:@"shop_info_id" mustEqualValue:shops_id];
    
    [spinner1 startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[StackMob stackmob] get:@"shop_info" withQuery:q andCallback:^(BOOL success, id result){
        if(success) {
            self.resultArray = (NSArray *)result;
            NSDictionary *dic = [resultArray objectAtIndex:0];
            self.address.text = [dic objectForKey:@"address"];
            self.number.text = [dic objectForKey:@"phone_number"];
            self.openTime.text = [dic objectForKey:@"opentime"];
            self.closedDate.text = [dic objectForKey:@"closeday"];
            self.budget.text = [dic objectForKey:@"budget"];
            self.numImage = [[dic objectForKey:@"shoppicnum"] intValue];
            
            for (int i = 1; i <= self.numImage; i++) {
                NSString *imageKey = [NSString stringWithFormat:@"shoppic%d", i];                
                NSMutableURLRequest *requestWithBodyParams = 
                [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [dic objectForKey:imageKey]]];
                NSData *imageData = [NSURLConnection sendSynchronousRequest:requestWithBodyParams returningResponse:nil error:nil];
                UIImage *image = [UIImage imageWithData:imageData];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                // setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
                CGRect rect = imageView.frame;
                rect.size.height = SCROLLOBJHEIGTH;
                rect.size.width = SCROLLOBJWIDTH;
                imageView.frame = rect;
                imageView.tag = i+1;	// tag our images for later use when we place them in serial fashion
                [shopPicScrollView addSubview:imageView];
                [imageView release];
            }
            
            discountTextVIew.text = [[dic objectForKey:@"discount"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            [spinner1 stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        else {
            [spinner1 stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"네트워크 오류" message:@"네트워크 장애로 데이터를 불러오지 못했습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(photoImage==nil) {
            NSURL *url = [[NSURL alloc] initWithString:photoLink];
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                mainPhoto.image = image;
            });
            [url release];
            [data release];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                mainPhoto.image = photoImage;
            });
        }
    });
}

- (void)viewDidUnload
{
    self.shop_name=nil;
    self.photoLink=nil;
    self.shops_id=nil;
    self.photoImage=nil;
    [self setResultArray:nil];
    [self setShopPicArray:nil];
    self.nameLabel=nil;
    self.mainPhoto=nil;
    self.address=nil;
    self.number=nil;
    [self setBasicInfoTab:nil];
    [self setMenuInfoTab:nil];
    [self setDiscountInfoTab:nil];
    [self setShopPicInfoTab:nil];
    [self setPointImg:nil];
    [self setShopCategoryImage:nil];
    [self setShopPicScrollView:nil];
    [self setSpinner1:nil];
    [self setOpenTime:nil];
    [self setClosedDate:nil];
    [self setBudget:nil];
    [self setBasicView:nil];
    [self setMenuView:nil];   
    [self setDiscountView:nil];
    [self setShopPicView:nil];    
    [self setShopPicScrollView:nil];
    [self setMenuInfoTextView:nil];
    [self setDiscountTextVIew:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [shop_name release];
    [photoLink release];
    [shops_id release];
    [photoImage release];
    [resultArray release];
    [shopPicArray release];
    
    [nameLabel release];
    [mainPhoto release];
    [address release];
    [number release];
    
    [basicInfoTab release];
    [MenuInfoTab release];
    [DiscountInfoTab release];
    [shopPicInfoTab release];    
    [pointImg release];
    [shopCategoryImage release];
    
    [spinner1 release];
    
    [openTime release];
    [closedDate release];
    [budget release];    
    [basicView release];
    [menuView release];
    [discountView release];
    [shopPicView release];
    [shopPicScrollView release];
    [menuInfoTextView release];    
    [discountTextVIew release];
}

#pragma mark - Button Methods

- (IBAction)pressedBasicBt:(id)sender 
{
    [self.view bringSubviewToFront:basicInfoTab];
    [self.view bringSubviewToFront:basicView];
    [self.view bringSubviewToFront:pointImg];
}

- (IBAction)pressedMenuBt:(id)sender 
{
    [self.view bringSubviewToFront:MenuInfoTab];
    [self.view bringSubviewToFront:menuView];
    [self.view bringSubviewToFront:pointImg];
}

- (IBAction)pressedDiscountBt:(id)sender 
{
    [self.view bringSubviewToFront:DiscountInfoTab];
    [self.view bringSubviewToFront:discountView];
    [self.view bringSubviewToFront:pointImg];
}

- (IBAction)pressedShopPicBt:(id)sender 
{
    [self.view bringSubviewToFront:shopPicInfoTab];
    [self.view bringSubviewToFront:shopPicView];    
    [self.view bringSubviewToFront:pointImg];
    [self layoutScrollImages];	// now place the photos in serial layout within the scrollview
}

- (IBAction)pressedMap
{
    DetailMapViewController *detailMapViewController = [[DetailMapViewController alloc] initWithNibName:@"DetailMapViewController" bundle:nil];
    detailMapViewController.location = [resultArray objectAtIndex:0];
    [self.navigationController pushViewController:detailMapViewController animated:YES];
    [detailMapViewController release];
}

-(IBAction)pressedCalling
{
    NSString *message = @"전화하시겠습니까?";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"전화걸기"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"아니오"
                                          otherButtonTitles:@"예", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1) {
        NSDictionary *dic = [resultArray objectAtIndex:0];
        NSString *phoneNum = [[NSString alloc] initWithFormat:@"tel://%@",[dic objectForKey:@"phone_number"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
        [phoneNum release];
    }
}

- (void)layoutScrollImages
{
    UIImageView *view = nil;
    NSArray *subviews = [shopPicScrollView subviews];
    
    // reposition all image subviews in a horizontal serial fashion
    CGFloat curXLoc = 0;
    for (view in subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.tag > 0){
            CGRect frame = view.frame;
            frame.origin = CGPointMake(curXLoc, 0);
            view.frame = frame;			
            curXLoc += (SCROLLOBJWIDTH);
        }
    }
    
    // set the content size so it can be scrollable
    [shopPicScrollView setContentSize:CGSizeMake((self.numImage * SCROLLOBJWIDTH), [shopPicScrollView bounds].size.height)];
}

@end