#import <Cephei/HBPreferences.h>

static NSDictionary *prefixes = @{
    @"furry": @[@"OwO ", @"H-hewwo?? ", @"Huohhhh. ", @"Haiiii! ", @"UwU ", @"OWO ", @"HIIII! ", @"<3 "],
    @"pirate": @[@"Arr, matey! ", @"Arrr! ", @"Ahoy. ", @"Yo ho ho! "]
};

static NSDictionary *suffixes = @{
    @"furry": @[@" :3", @" UwU", @" ʕʘ‿ʘʔ", @" >_>", @" ^_^", @"..", @" Huoh.", @" ^-^", @" ;_;", @" ;-;", @" xD", @" x3", @" :D", @" :P", @" ;3", @" XDDD", @", fwendo", @" ㅇㅅㅇ", @" (人◕ω◕)", @"（＾ｖ＾）", @" Sigh.", @" >_<"]
};

static NSDictionary *replacement = @{
    @"furry": @{
        @"r": @"w",
        @"l": @"w",
        @"R": @"W",
        @"no": @"nu",
        @"has": @"haz",
        @"have": @"haz",
        @"you": @"uu",
    },
    @"leet": @{
        @"cks": @"x",
        @"ck": @"x",
        @"er": @"or",
        @"and": @"&",
        @"anned": @"&",
        @"porn": @"pr0n",
        @"lol": @"lulz",
        @"the ": @"teh ",
        @"a": @"4",
        @"o": @"0",
        @"e": @"3",
        @"b": @"8",
        @"s": @"5",
        @"z": @"2",
        @"l": @"1",
        @"t": @"7",
    },
    @"pirate": @{
        @"this": @"'tis",
        @"g ": @"' ",
        @"you": @"ye",
    }
};

static NSString *mode = nil;

NSString *owoify (NSString *text, bool replacementOnly) {
    NSString *temp = [text copy];
    
    if (replacement[mode]) {
        for (NSString *key in replacement[mode]) {
            temp = [temp stringByReplacingOccurrencesOfString:key withString:replacement[mode][key]];
        }
    }

    if (!replacementOnly) {
        if (prefixes[mode]) {
            temp = [prefixes[mode][arc4random() % [prefixes[mode] count]] stringByAppendingString:temp];
        }

        if (suffixes[mode]) {
            temp = [temp stringByAppendingString:suffixes[mode][arc4random() % [suffixes[mode] count]]];
        }
    }

    return temp;
}

%group OwONotifications

%hook NCNotificationContentView

-(void)setPrimaryText:(NSString *)orig {
    if (!orig) {
        %orig(orig);
        return;
    }
    
    %orig(owoify(orig, true));
}

-(void)setSecondaryText:(NSString *)orig {
    if (!orig) {
        %orig(orig);
        return;
    }
    
    %orig(owoify(orig, false));
}

%end

%end

%ctor {
    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.owo"];

    if ([([file objectForKey:@"Enabled"] ?: @(YES)) boolValue]) {
        mode = [file objectForKey:@"Style"] ?: @"furry";

        if ([([file objectForKey:@"EnabledNotifications"] ?: @(YES)) boolValue]) {
            %init(OwONotifications);
        }
    }
}