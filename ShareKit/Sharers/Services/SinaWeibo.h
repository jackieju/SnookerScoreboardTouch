//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHK.h"
#import "SHKOAuthSharer.h"

@interface SinaWeibo : SHKOAuthSharer {
    NSString *username;
    NSString *password;
}
@property (retain) SHKFormController *pendingForm;
- (void)promptAuthorization;
- (void)authorizationFormValidate:(SHKFormController *)form;
- (void)authorizationFormSave:(SHKFormController *)form;
@end
