from os.path import join
import numpy as np
from constants import *
import cv2

class DatasetLoader(object):

	def __init__(self):
		pass

	def load_from_save(self):
		self._images      = np.load(join(SAVE_DIRECTORY, SAVE_DATASET_IMAGES_FILENAME))
		self._labels      = np.load(join(SAVE_DIRECTORY, SAVE_DATASET_LABELS_FILENAME))
		
		self._images_test = np.load(join(SAVE_DIRECTORY, SAVE_DATASET_IMAGES_TEST_FILENAME))
		self._labels_test = np.load(join(SAVE_DIRECTORY, SAVE_DATASET_LABELS_TEST_FILENAME))
		
		self._images_privateTest = np.load(join(SAVE_DIRECTORY,SAVE_DATASET_IMAGES_privateTest_FILENAME))
		self._labels_privateTest = np.load(join(SAVE_DIRECTORY, SAVE_DATASET_LABELS_privateTest_FILENAME))

		self._images      = self._images.reshape([-1, SIZE_FACE, SIZE_FACE, 1])
		self._images_test = self._images_test.reshape([-1, SIZE_FACE, SIZE_FACE, 1])
		self._images_privateTest = self._images_privateTest.reshape([-1, SIZE_FACE, SIZE_FACE, 1])
		
		self._labels      = self._labels.reshape([-1, len(EMOTIONS)])
		self._labels_test = self._labels_test.reshape([-1, len(EMOTIONS)])
		self._labels_privateTest = self._labels_privateTest.reshape([-1, len(EMOTIONS)])

#for training
	@property
	def images(self):
		return self._images
	
	@property
	def labels(self):
		return self._labels

#For validation
	@property
	def images_test(self):
		return self._images_test

	@property
	def labels_test(self):
		return self._labels_test
		
#For verification
	@property
	def labels_privateTest(self):
		return self._labels_privateTest

	@property
	def images_privateTest(self):
		return self._images_privateTest