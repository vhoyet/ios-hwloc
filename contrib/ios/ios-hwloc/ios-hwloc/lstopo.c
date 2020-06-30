//
//  lstopo.c
//  ios-hwloc
//
//  Created by vhoyet on 10/06/2020.
//  Copyright © 2020 vhoyet. All rights reserved.
//

#include "lstopo.h"

void iosbox(int r, int g, int b, int x, int y, int width, int height, int gp_index, char *info) {
    _iosbox(r, g, b, x, y, width, height, gp_index, info);
}

void iostext(char *text, int gp_index, int x, int y, int fontsize) {
    _iostext(text, gp_index, x, y, fontsize);
}

void iosline(unsigned x1, unsigned y1, unsigned x2, unsigned y2) {
    _iosline(x1, y1, x2, y2);
}

void ios_prepare_scale(int width, int height) {
    _prepare(width, height);
}

void _lstopo(int mode, const char * file) {
    char *argv[4];
    argv[0] = "lstopo";
    if(mode == 1) {
        lstopo(1, argv);
    } else if(mode == 2) {
        argv[1] = "-i";
        argv[2] = (char *)file;
        lstopo(3, argv);
    } else if(mode == 3) {
        argv[1] = "--of";
        argv[2] = "console";
        argv[3] = (char *)file;
        lstopo(4, argv);
    }  else if(mode == 4) {
       argv[1] = "--of";
       argv[2] = "xml";
       argv[3] = (char *)file;
       lstopo(4, argv);
    } else if(mode == 5) {
       argv[1] = "-i";
       argv[2] = (char *)file;
       lstopo(3, argv);
    }
    
}
