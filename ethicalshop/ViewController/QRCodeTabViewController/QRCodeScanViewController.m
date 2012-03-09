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
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
	
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
    
    //If QR code is invalid, return
    if([resultText length] != 15){
        [reader dismissModalViewControllerAnimated: YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QR code 오류" message:@"해당 QR code는 유효하지 않습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        [alert release];
        self.qrLabel.text = @"";
        return;
    }
    
    NSInteger shop_num = [[resultText substringWithRange:NSMakeRange(13, 2)] intValue];
    NSString *shop_id;
    
    if(shop_num>=10)
        shop_id = [resultText substringWithRange:NSMakeRange(13, 2)];
    else
        shop_id = [resultText substringWithRange:NSMakeRange(14, 1)];
    
    
    StackMobQuery *q1 = [StackMobQuery query];
    [q1 field:@"shops_id" mustEqualValue:shop_id];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[StackMob stackmob] get:@"shops" withQuery:q1 andCallback:^(BOOL success, id result){
        NSArray *resultArr = (NSArray *) result;
        if(success && [resultArr count]>0){
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
                        } else {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"사용자 정보 저장 오류" message:@"사용자 정보를 아이폰에 업데이트 하지 못하였습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                            [alert show];
                            [alert release];
                        }
                    }];
                }
                
            }];
        }
        else{
            [reader dismissModalViewControllerAnimated: YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QR code 오류" message:@"해당 QR code는 유효하지 않습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
            self.qrLabel.text = @"";
            return;
        }
            
    }];
    

    
    // EXAMPLE: do something useful with the barcode image
    resultImage.image =
	[info objectForKey: UIImagePickerControllerOriginalImage];
	
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}


@end
