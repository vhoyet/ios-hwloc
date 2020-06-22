//
//  lstopo.h
//  ios-hwloc
//
//  Created by vhoyet on 10/06/2020.
//  Copyright © 2020 vhoyet. All rights reserved.
//

#ifndef lstopo_h
#define lstopo_h

#include <stdio.h>
#include "../../../../hwloc/traversal.c"
#include "../../../../hwloc/topology.c"
#include "../../../../hwloc/topology-xml.c"
#include "../../../../hwloc/topology-darwin.c"
#include "../../../../hwloc/topology-synthetic.c"
#include "../../../../hwloc/topology-noos.c"
#include "../../../../hwloc/topology-xml-nolibxml.c"
#include "../../../../hwloc/topology-x86.c"
#include "../../../../hwloc/base64.c"
#include "../../../../hwloc/distances.c"
#include "../../../../hwloc/bind.c"
#include "../../../../hwloc/bitmap.c"
#include "../../../../hwloc/shmem.c"
#include "../../../../hwloc/misc.c"
#include "../../../../hwloc/pci-common.c"
#include "../../../../hwloc/components.c"
#include "../../../../utils/lstopo/lstopo.c"
#include "../../../../utils/lstopo/lstopo-draw.c"
#include "../../../../utils/lstopo/lstopo-ios-draw.c"
#include "../../../../utils/lstopo/lstopo-fig.c"
#include "../../../../utils/lstopo/lstopo-svg.c"
#include "../../../../utils/lstopo/lstopo-text.c"
#include "../../../../utils/lstopo/lstopo-xml.c"



void iosbox(int r, int g, int b, int x, int y, int width, int height, int gp_index, char * _Nonnull info);
void iostext(char * _Nonnull text, int gp_index, int x, int y, int fontsize);
void iosline(unsigned x1, unsigned y1, unsigned x2, unsigned y2);
void ios_prepare_scale(int width, int height);
void _iosbox(int r, int g, int b, int x, int y, int width, int height, int gp_index, char * _Nonnull info);
void _iostext(char * _Nonnull text, int gp_index, int x, int y, int fontsize);
void _iosline(unsigned x1, unsigned y1, unsigned x2, unsigned y2);
void _prepare(int width, int hieght);
void _lstopo(int mode, const char * file);

#endif /* lstopo_h */
