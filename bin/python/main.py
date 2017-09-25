# -*- coding: cp936 -*-

import os,sys, re
import shutil
import reader as reader
import autolua as autolua

if __name__=="__main__":
    xrer = reader.xreader(sys.argv)
    xrer.set_handler(autolua.Autolua())
    xrer.set_filter(
        [".lua"], 
        #ignore file
        ["manifest.lua", "tmp.lua", "init.lua"],
        #ignore path
        ["core"]
    )
    xrer.find()

