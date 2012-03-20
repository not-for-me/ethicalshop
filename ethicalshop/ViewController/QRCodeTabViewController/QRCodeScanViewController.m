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
@synthesize locationManager;
@synthesize startPoint;

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
    locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	[locationManager startUpdatingLocation];
    
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
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //상점의 거리를 먼저 확인 함
    StackMobQuery *q = [StackMobQuery query];
    [q field:@"shop_info_id" mustEqualValue:shop_id];
    [[StackMob stackmob] get:@"shop_info" withQuery:q andCallback:^(BOOL success, id result){
        if(success) {
            NSArray *resultArray = (NSArray *)result;
            NSDictionary *dic = (NSDictionary *) [resultArray objectAtIndex:0];            
            NSDictionary *loc = [dic objectForKey:@"location"];
            
            CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:[[loc objectForKey:@"lat"] doubleValue] longitude:[[loc objectForKey:@"lon"] doubleValue]];
            
            CLLocationDistance distance = [startPoint distanceFromLocation:shopLocation];
            [shopLocation release];
            
            // 거리가 일정 범위 내에 들어 옴
            if(distance <= 50.0) {
                StackMobQuery *q = [StackMobQuery query];
                [q setSelectionToFields:[NSArray arrayWithObjects:@"checkin", @"name", @"totalpoint", nil]];
                [[StackMob stackmob] get:[NSString stringWithFormat:@"shop_info/%@", shop_id] withQuery:q andCallback:^(BOOL success, id result){
                    if(success) {
                        NSDictionary *dic = (NSDictionary *) result;
                        self.qrLabel.text = [dic objectForKey:@"name"];                        
                        NSInteger checkin = [[dic objectForKey:@"checkin"] intValue];
                        checkin++;
                        NSInteger totalPoint = [[dic objectForKey:@"totalpoint"] intValue];
                        totalPoint += 20;
                        
                        
                        NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:checkin], @"checkin", [NSNumber numberWithInteger:totalPoint], @"totalpoint",nil];                        
                        [[StackMob stackmob] put:@"shop_info" withId:shop_id andArguments:args andCallback:^(BOOL success, id result) {
                            if (success) {
                                
                                [StackMobCustomSDK checkDailyCheckInUp:shop_id];
                                
                            } 
                            else {
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"사용자 정보 저장 오류" message:@"가맹점 정보를 아이폰에 업데이트 하지 못하였습니다. 한번 더 체크인 해주세요 ^^" delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                                [alert show];
                                [alert release];
                            }
                        }];
                        
                        
                        
                    }
                    else{                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QR code 오류" message:@"해당 QR code는 유효하지 않습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        self.qrLabel.text = @"";
                        return;
                    }
                }];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"체크인 오류" message:@"QR code는 가맹점에서 찍을 때만 유효합니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alert show];
                [alert release];
                self.qrLabel.text = @"";
                return;
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"네트워크 오류" message:@"네트워크 장애로 정상적으로 위치정보를 수집하지 못하였습니다. 다시 한번 체크인 해주세요 ^^." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
            self.qrLabel.text = @"";
            return;
            
        }
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        // EXAMPLE: do something useful with the barcode image
    resultImage.image =
	[info objectForKey: UIImagePickerControllerOriginalImage];
	
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation 
{	
    if (startPoint == nil) {
        self.startPoint = newLocation;
    }
    
    [locationManager stopUpdatingLocation];
}


@end
