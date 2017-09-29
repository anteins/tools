# -*- coding: cp936 -*-

import os,sys, re
import shutil

class Block():
	match = []
	mergeinfo = []
	block = []
	deepth = 0
	aaa = "aaa"

	def __init__(self, lmatch, merge, block):
		self.match = lmatch
		self.mergeinfo = merge
		self.block = block
		self.deepth = len(block)
		pass

	def getblock(self):
		return self.block

	def getmatch(self):
		return self.match

	def getmerge(self):
		return self.mergeinfo

	def printinfo(self):
		for line in self.block:
			print line

	def getdeepth(self):
		return self.deepth

	def contains(self, char):
		for line in self.block:
			if char in line:
				return True

		return False





