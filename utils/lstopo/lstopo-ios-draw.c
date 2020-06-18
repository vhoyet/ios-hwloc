/*
 * Copyright © 2019 Inria.  All rights reserved.
 * See COPYING in top-level directory.
 */

#include "private/autogen/config.h"
#include "hwloc.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

#include "lstopo.h"

#define SVG_TEXT_WIDTH(length, fontsize) (((length) * (fontsize))/2)
#define SVG_FONTSIZE_SCALE(size) (((size) * 11) / 9)

static void
native_ios_box(struct lstopo_output *loutput, const struct lstopo_color *lcolor, unsigned depth __hwloc_attribute_unused, unsigned x, unsigned width, unsigned y, unsigned height, hwloc_obj_t obj, unsigned box_id)
{
  int gp_index = -1;
  int r = lcolor->r, g = lcolor->g, b = lcolor->b;
  char * info = malloc(1096);
  char * sep = " ";
    //printf("colors : %d %d %d\n", r, g, b);
  if(obj){
      gp_index = obj->gp_index;
      hwloc_obj_attr_snprintf(info, 1096, obj, sep, 1);
  }

  iosbox(r, g, b, x, y, width, height, gp_index, info);
}


static void
native_ios_line(struct lstopo_output *loutput, const struct lstopo_color *lcolor, unsigned depth __hwloc_attribute_unused, unsigned x1, unsigned y1, unsigned x2, unsigned y2, hwloc_obj_t obj, unsigned line_id)
{
  iosline(x1, y1, x2, y2);
}

static void
native_ios_textsize(struct lstopo_output *loutput __hwloc_attribute_unused, const char *text __hwloc_attribute_unused, unsigned textlength, unsigned fontsize, unsigned *width)
{
  fontsize = SVG_FONTSIZE_SCALE(fontsize);
  *width = SVG_TEXT_WIDTH(textlength, fontsize);
}


static void
native_ios_text(struct lstopo_output *loutput, const struct lstopo_color *lcolor, int size, unsigned depth __hwloc_attribute_unused, unsigned x, unsigned y, const char *text, hwloc_obj_t obj, unsigned text_id)
{
  int gp_index = -1;
  if(obj)
      gp_index = obj->gp_index;
  iostext((char *)text, gp_index, x, y, loutput->fontsize);
}

static struct draw_methods native_ios_draw_methods = {
  NULL,
  native_ios_box,
  native_ios_line,
  native_ios_text,
  native_ios_textsize,
};

int output_ios_draw(struct lstopo_output * loutput, const char *filename)
{
  loutput->methods = &native_ios_draw_methods;
  /* recurse once for preparing sizes and positions */
  loutput->drawing = LSTOPO_DRAWING_PREPARE;
  
  output_draw(loutput);
  loutput->drawing = LSTOPO_DRAWING_DRAW;

  /* ready */
  lstopo_prepare_custom_styles(loutput);
  ios_prepare_scale(loutput->width, loutput->height);
  
  output_draw(loutput);

  return 0;
}

