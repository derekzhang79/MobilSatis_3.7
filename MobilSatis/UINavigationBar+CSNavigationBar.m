//
//  UINavigationBar+CSNavigationBar.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 22.10.2012.
//
//

#import "UINavigationBar+CSNavigationBar.h"

@implementation UINavigationBar (CSNavigationBar)

- (void)setNavigationBarSize {
    
    if ([self tag] == 10) {
      /*  CGRect tempframe = self.navigationController.navigationBar.frame;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            //tempframe.size.height = 50;
        }else{
            
        }
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, tempframe.size.width, 50);
       */
    }
}

@end
