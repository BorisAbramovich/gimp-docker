#!/usr/bin/env python

'''
mm extern eaw.py
Use extern binary to use edge avoiding wavelets on the image.

Author:
Michael Munzert (mail mm-log com)

Version:
2010-04-05 Inital release.

this script is modelled after the trace plugin
(lloyd konneker, lkk, bootch at nc.rr.com)

License:

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

The GNU Public License is available at
http://www.gnu.org/copyleft/gpl.html

'''

from gimpfu import *
import subprocess
import os, sys

def plugin_main(image, drawable, alpha, nrbands, mode, band, visible):
  pdb.gimp_image_undo_group_start(image)
  # Copy so the save operations doesn't affect the original
  if visible == 0:
    # Save in temporary.  Note: empty user entered file name
    temp = pdb.gimp_image_get_active_drawable(image)
    pdb.gimp_edit_named_copy(temp, "EAWTemp")
  else:
    # Get the current visible
    temp = pdb.gimp_layer_new_from_visible(image, image, "EAW")
    image.add_layer(temp, 0)
    pdb.gimp_edit_named_copy(temp, "EAWTemp")

  tempimage = pdb.gimp_edit_named_paste_as_new("EAWTemp")
  pdb.gimp_buffer_delete("EAWTemp")
  if not tempimage:
    raise RuntimeError
  pdb.gimp_image_undo_disable(tempimage)

  tempdrawable = pdb.gimp_image_get_active_layer(tempimage)

  # Use temp file names from gimp, it reflects the user's choices in gimp.rc
  tempfilename = pdb.gimp_temp_name("tif")

  # !!! Note no run-mode first parameter, and user entered filename is empty string
  pdb.gimp_progress_set_text ("Saving a copy")
  pdb.gimp_file_save(tempimage, tempdrawable, tempfilename, "")
  #pdb.file_tiff_save2(tempimage, tempdrawable, tempfilename, tempfilename, 0, 1)

  # Command line
  if alpha < 0.01:
    stralpha = "0"
  else:
    stralpha = str(alpha)

  if nrbands < 0.01:
    strnrbands = "0"
  else:
    strnrbands = str(nrbands)

  if mode < 0.01:
    strmode = "0"
  else:
    strmode = str(mode)

  if band < 0.01:
    strband = "0"
  else:
    strband = str(band)


  path = sys.path[0]
  command = path + "/eaw " + "\"" + tempfilename + "\" " + stralpha + " " + strnrbands + " "
  command = command + strband + " " + strmode + " \"" + tempfilename + "\" "

  # Invoke eaw.
  pdb.gimp_progress_set_text ("run eaw...")
  pdb.gimp_progress_pulse()
  child = subprocess.Popen(command, shell=True)
  child.communicate()

  # put it as a new layer in the opened image
  try:
    newlayer = pdb.gimp_file_load_layer(tempimage, tempfilename)
  except:
    RuntimeError
  tempimage.add_layer(newlayer,-1)
  pdb.gimp_edit_named_copy(newlayer, "ImgVisible")

  if visible == 0:
    sel = pdb.gimp_edit_named_paste(drawable, "ImgVisible", 0)
  else:
    sel = pdb.gimp_edit_named_paste(temp, "ImgVisible", 0)
  pdb.gimp_buffer_delete("ImgVisible")
  pdb.gimp_floating_sel_anchor(sel)

  # cleanup
  os.remove(tempfilename)  # delete the temporary file
  gimp.delete(tempimage)   # delete the temporary image

  # Note the new image is dirty in Gimp and the user will be asked to save before closing.
  pdb.gimp_image_undo_group_end(image)
  gimp.displays_flush()


register(
        "python_fu_mm_extern_eaw",
        "Edge avoiding wavelets.",
        "Edge avoiding wavelets.",
        "Michael Munzert (mail mm-log com)",
        "Copyright 2010 Michael Munzert",
        "2010",
        "<Image>/Filters/MM-Filters/_EAW...", # menuitem with accelerator key
        "*", # image types
        [ (PF_SPINNER, "alpha", "Strength:", 1.0, (0.0, 2, 0.1)),
          (PF_SPINNER, "nrbands", "Nr of levels:", 10, (1, 20, 1)),
          (PF_OPTION, "mode",   "Mode:", 0, ["Linear amplification","Local contrast","Output level"]),
          (PF_SPINNER, "band", "Output level:", 5, (1, 20, 1)),
          (PF_RADIO, "visible", "Layer:", 1, (("new from visible", 1),("current layer",0)))
        ],
        [],
        plugin_main,
        # menu="<Image>/Filters", # really the menupath less menuitem.
        # Enables plugin regardless of image open, passes less params
        # domain=("gimp20-python", gimp.locale_directory))
        )

main()


