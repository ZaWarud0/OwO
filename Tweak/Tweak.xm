static NSDictionary *prefixes = @{
    @"furry": @[@"OwO ", @"H-hewwo?? ", @"Huohhhh. ", @"Haiiii! ", @"UwU ", @"OWO ", @"HIIII! ", @"<3 "]
};

static NSDictionary *suffixes = @{
    @"furry": @[@" :3", @" UwU", @" ʕʘ‿ʘʔ", @" >_>", @" ^_^", @"..", @" Huoh.", @" ^-^", @" ;_;", @" ;-;", @" xD", @" x3", @" :D", @" :P", @" ;3", @" XDDD", @", fwendo", @" ㅇㅅㅇ", @" (人◕ω◕)", @"（＾ｖ＾）", @" Sigh."]
};

static NSDictionary *replacement = @{
    @"furry": @{
        @"r": @"w",
        @"l": @"w",
        @"R": @"W",
        @"no": @"nu",
        @"has": @"haz",
        @"have": @"haz",
        @"you": @"uu"
    }
};

static NSString *mode = @"furry";

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

%hook NCNotificationContentView

-(void)setSecondaryText:(NSString *)orig {
    if (!orig) {
        %orig(orig);
        return;
    }
    
    %orig(owoify(orig, false));
}

%end
