# -*- coding: cp936 -*-

import os,sys, re
import shutil
import reader
import autolua

if __name__=="__main__":
    reader = XReader(sys.argv)
    reader.set_handler(Autolua())
    reader.set_filter(
        [".lua"], 
        #ignore file
        ["manifest.lua", "tmp.lua", "init.lua"],
        #ignore path
        ["core"]
    )
    reader.find()

