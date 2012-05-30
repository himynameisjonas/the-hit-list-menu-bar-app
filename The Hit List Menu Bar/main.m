//
//  main.m
//  The Hit List Menu Bar
//
//  Created by Jonas Forsberg on 2012-05-30.
//  Copyright (c) 2012 Mynewsdesk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
