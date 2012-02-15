//
//  QRCodeScanViewController.m
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QRCodeScanViewController.h"

@implementation QRCodeScanViewController

@synthesize resultImage;
@synthesize qrLabel;
@synthesize resultText;

#pragma mark - View Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"QR 코드";
        self.navigationItem.title = @"QR코드 찍기";
        self.tabBarItem.image = [UIImage imageNamed:@"ES_all_tabicon_qrcode"];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    [self setResultImage:nil];
    [self setQrLabel:nil];
    [self setResultText:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
}

- (void)dealloc {
    [resultText release];
    [qrLabel release];
    [resultImage release];
    [super dealloc];
}


#pragma mark - Button Methods

// 스캔 버튼을 누르면 다시 QR 코드를 찍을 수 있도록 안내
- (IBAction) scanButtonTapped
{
	// ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
	
	ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
	
	UIImageView *overlayImageView = [[UIImageView alloc] 
									 initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
	[overlayImageView setFrame:CGRectMake(30, 100, 260, 200)];
	UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 960)];
    [customView addSubview:overlayImageView];
	
	
	reader.cameraOverlayView = customView;
	[customView release];
	[overlayImageView release];
	
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
				   config: ZBAR_CFG_ENABLE
					   to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
							animated: YES];	
}

#pragma mark - ZBar SDK Deleagte Methods

// 사진을 찍을 수 있도록 하는 메소드
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
	[info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
	
    // EXAMPLE: do something useful with the barcode data
    resultText = [symbol.data mutableCopy];
    
    
    StackMobQuery *q1 = [StackMobQuery query];
    [q1 field:@"shops_id" mustEqualValue:resultText];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[StackMob stackmob] get:@"shops" withQuery:q1 andCallback:^(BOOL success, id result){
        if(success){
            NSArray *resultArr = (NSArray *) result;
            if([resultArr count] == 1) {
                NSDictionary *dic = [resultArr objectAtIndex:0];
                NSString *shop_id = [dic objectForKey:@"shops_id"];
                NSInteger countInt = [[dic objectForKey:@"count"] intValue];
                countInt = countInt + 5;
                NSString *count = [NSString stringWithFormat:@"%d",countInt];
                NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:count, @"count", nil];
                self.qrLabel.text = [dic objectForKey:@"shop_name"];
                
                [[StackMob stackmob] put:@"shops" withId:shop_id andArguments:args andCallback:^(BOOL success, id result) {
                    if (success) {
                    } else {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"사용자 정보 저장 오류" message:@"사용자 정보를 아이폰에 업데이트 하지 못하였습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    }
                }];
                
                
                if([UserObject userFileIsIn]) {
                    
                    StackMobQuery *q2 = [StackMobQuery query];
                    [q2 field:@"nickname" mustEqualValue:[[UserObject sharedUserData] nickName]];
                    
                    [[StackMob stackmob] get:@"user" withQuery:q2 andCallback:^(BOOL success, id result){
                        if(success){
                            NSArray *resultArr = (NSArray *) result;
                            
                            NSDictionary *dic = [resultArr objectAtIndex:0];
                            NSString *eMail = [dic objectForKey:@"email"];
                            NSInteger countInt = [[dic objectForKey:@"count"] intValue];
                            countInt = countInt + 5;
                            NSString *count = [NSString stringWithFormat:@"%d",countInt];
                            NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:count, @"count", nil];
                            
                            [[StackMob stackmob] put:@"user" withId:eMail andArguments:args andCallback:^(BOOL success, id result) {
                                if (success) {
                                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;                    
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QR 코드 등록 완료" message:[NSString stringWithFormat:@"%@을 방문해 주셔서 감사합니다.", self.qrLabel.text] delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                                    [alert show];
                                    [alert release];
                                } 
                                else {
                                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"사용자 정보 저장 오류" message:@"사용자 정보를 아이폰에 업데이트 하지 못하였습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                                    [alert show];
                                    [alert release];
                                }
                            }];                       
                            
                        }
                        else {                
                        }
                        
                    }];
                }
                else {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"네트워크 오류" message:@"네트워크 장애로 데이터를 불러오지 못했습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                    [alert show];
                    [alert release];                    
                }
            }
            else {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QR 코드 오류" message:@"착한 가게에 등록된 가맹점의 QR코드가 아닙니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
                
            
            
        }
        else {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;                
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"네트워크 오류" message:@"네트워크 장애로 데이터를 불러오지 못했습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    
    
    
    // EXAMPLE: do something useful with the barcode image
    resultImage.image =
	[info objectForKey: UIImagePickerControllerOriginalImage];
    [self.resultImage setHidden:NO];
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}


@end
