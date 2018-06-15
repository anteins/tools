# -*- coding: cp936 -*-

import os,sys, re
import shutil
import reader
from logic import autolua

if __name__=="__main__":
    xrer = reader.xreader(sys.argv)
    xrer.set_filter(
        [".lua"], 
        #ignore file
        ["manifest.lua", "tmp.lua", "Init.lua"],
        #ignore path
        ["core"]
    )
    xrer.start(autolua.Autolua())

