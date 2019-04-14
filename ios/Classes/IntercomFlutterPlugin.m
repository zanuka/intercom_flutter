#import "IntercomFlutterPlugin.h"
#import "Intercom.h"

@implementation IntercomFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    IntercomFlutterPlugin* instance = [[IntercomFlutterPlugin alloc] init];
    FlutterMethodChannel* channel =
    [FlutterMethodChannel methodChannelWithName:@"maido.io/intercom"
                                binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void) handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    if([@"initialize" isEqualToString:call.method]) {
        NSString *iosApiKey = call.arguments[@"iosApiKey"];
        NSString *appId = call.arguments[@"appId"];
        [Intercom setApiKey:iosApiKey forAppId:appId];
        result(@"Initialized Intercom");
    }
    else if([@"registerUnidentifiedUser" isEqualToString:call.method]) {
        [Intercom registerUnidentifiedUser];
        result(@"Registered unidentified user");
    }
    else if([@"setUserHash" isEqualToString:call.method]) {
        NSString *userHash = call.arguments[@"userHash"];
        [Intercom setUserHash:userHash];
        result(@"User hash added");
    }
    else if([@"registerIdentifiedUserWithUserId" isEqualToString:call.method]) {
        NSString *userId = call.arguments[@"userId"];
        NSString *email = call.arguments[@"email"];
        if(userId != (id)[NSNull null] || email != (id)[NSNull null]) {
            if(userId == (id)[NSNull null]) {
                [Intercom registerUserWithEmail:email];
            } else if(email == (id)[NSNull null]) {
                [Intercom registerUserWithUserId:userId];
            } else {
                [Intercom registerUserWithUserId:userId email:email];
            }
            result(@"Registered user");
        }
    }
    else if([@"setLauncherVisibility" isEqualToString:call.method]) {
        NSString *visibility = call.arguments[@"visibility"];
        [Intercom setLauncherVisible:[@"VISIBLE" isEqualToString:visibility]];
        result(@"Setting launcher visibility");
    }
    else if([@"setInAppMessagesVisibility" isEqualToString:call.method]) {
        NSString *visibility = call.arguments[@"visibility"];
        [Intercom setInAppMessagesVisible:[@"VISIBLE" isEqualToString:visibility]];
        result(@"Setting in app messages visibility");
    }
    else if([@"unreadConversationCount" isEqualToString:call.method]) {
        NSUInteger count = [Intercom unreadConversationCount];
        result(@(count));
    }
    else if([@"displayMessenger" isEqualToString:call.method]) {
        [Intercom presentMessenger];
        result(@"Presented messenger");
    }
    else if([@"displayHelpCenter" isEqualToString:call.method]) {
        [Intercom presentHelpCenter];
        result(@"Presented help center");
    }
    else if([@"updateUser" isEqualToString:call.method]) {
        ICMUserAttributes *attributes = [ICMUserAttributes new];
        NSString *email = call.arguments[@"email"];
        if(email != (id)[NSNull null]) {
            attributes.email = email;
        }
        NSString *name = call.arguments[@"name"];
        if(name != (id)[NSNull null]) {
            attributes.name = name;
        }
        NSString *phone = call.arguments[@"phone"];
        if(phone != (id)[NSNull null]) {
            attributes.phone = phone;
        }
        NSString *userId = call.arguments[@"userId"];
        if(userId != (id)[NSNull null]) {
            attributes.userId = userId;
        }
        NSString *companyName = call.arguments[@"company"];
        NSString *companyId = call.arguments[@"companyId"];
        if(companyName != (id)[NSNull null] && companyId != (id)[NSNull null]) {
            ICMCompany *company = [ICMCompany new];
            company.name = companyName;
            company.companyId = companyId;
            attributes.companies = @[company];
        }
        NSDictionary *customAttributes = call.arguments[@"customAttributes"];
        if(customAttributes != (id)[NSNull null]) {
            attributes.customAttributes = customAttributes;
        }
        [Intercom updateUser:attributes];
        result(@"Updated user");
    }
    else if([@"logout" isEqualToString:call.method]) {
        [Intercom logout];
        result(@"Logged out");
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}
@end
