//
//  ProductViewController.m
//  adobe-branch-example
//
//  Created by Aaron Lopez on 9/25/18.
//  Copyright © 2018 Branch Metrics. All rights reserved.
//

#import "ProductViewController.h"
#import "Product.h"
#import <ACPCore_iOS/ACPCore_iOS.h>
#import <AdobeBranchExtension/AdobeBranchExtension.h>

@interface ProductViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel     *productTitle;
@property (weak, nonatomic) IBOutlet UIButton    *shareButton;
@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.productImage.image = [UIImage imageNamed:self.product.imageName];
    self.productImage.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.productImage.layer.borderWidth = 2.0f;
    self.productImage.layer.cornerRadius = 5.0f;
    self.productImage.layer.masksToBounds = YES;
    self.productTitle.text = self.product.name;
    [ACPCore trackAction:@"VIEW" data:@{
        @"name":        self.product.name,
        @"revenue":     @"200.0",
        @"currency":    @"USD"
    }];
}

- (IBAction)shareButton:(id)sender {
    NSError* error = nil;
    ACPExtensionEvent* shareSheetEvent =
        [ACPExtensionEvent extensionEventWithName:ABEBranchEventNameShowShareSheet
            type:ABEBranchEventType
            source:ABEBranchEventSource
            data:@{
                ABEBranchLinkTitleKey:          self.product.name,
                ABEBranchLinkSummaryKey:        self.product.summary,
                ABEBranchLinkImageURLKey:       self.product.imageURL,
                ABEBranchLinkCanonicalURLKey:   self.product.URL,
                ABEBranchLinkCampaignKey:       @"Sharing",
                ABEBranchLinkShareTextKey:      @"Check out this Branch swag!",
                ABEBranchLinkTagsKey:           @[ @"Swag", @"Branch"],
                ABEBranchLinkUserInfoKey:       @{ @"imageName": self.product.imageName }
            }
            error:&error];
    if ([ACPCore dispatchEvent:shareSheetEvent error:&error]) {
        NSLog(@"Can't dispatch event: %@.", error);
    }
}

@end
