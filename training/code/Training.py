#import tflearn
#import re
import numpy as np
import os
from os.path import isfile, join
import sys

from dataset_loader import DatasetLoader
from constants import *
import tflearn.activations as activations

import tflearn
import tensorflow as tf
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report


from tflearn.layers.core import input_data, dropout, fully_connected, flatten
from tflearn.layers.conv import conv_2d, max_pool_2d, avg_pool_2d
from tflearn.layers.merge_ops import merge
from tflearn.layers.normalization import local_response_normalization
from tflearn.layers.estimator import regression
from tflearn.activations import relu
from tflearn.data_utils import shuffle, to_categorical
from tflearn.layers.conv import avg_pool_2d, conv_2d, max_pool_2d
from tflearn.layers.core import dropout, flatten, fully_connected, input_data
from tflearn.layers.merge_ops import merge
from tflearn.layers.normalization import local_response_normalization
from tflearn.layers.normalization import batch_normalization

class EmotionRecognition:

	def __init__(self):
		self.dataset = DatasetLoader()

	def build_network(self):
		padding = 'SAME'
		print(' ')
		print('----------------- Building CNN -----------------')
		print(' ')
		self.network = tflearn.input_data(shape = [None, SIZE_FACE, SIZE_FACE, 1])

		conv_1 = tflearn.relu(conv_2d(self.network, 96, 3, strides=1, bias=True, padding=padding, activation=None, name='Conv_1'))
		maxpool_1 = tflearn.max_pool_2d(conv_1, 3, strides=2, padding=padding, name='MaxPool_1')
		maxpool_1 = tflearn.batch_normalization(maxpool_1)

		conv_2 = tflearn.relu(conv_2d(maxpool_1, 108, 2, strides=1, padding=padding, name='Conv_2'))
		maxpool_2 = tflearn.max_pool_2d(conv_2, 2, strides=1, padding=padding, name='MaxPool_2')
		maxpool_2 = tflearn.batch_normalization(maxpool_2)

		conv_3 = tflearn.relu(conv_2d(maxpool_2, 208, 2, strides=1, padding=padding, name='Conv_3'))
		conv_4 = tflearn.relu(conv_2d(conv_3, 64, 2, strides=1, padding=padding, name='Conv_4'))
		maxpool_3 = tflearn.max_pool_2d(conv_4, 2, strides=1, padding=padding, name='MaxPool_3')
		maxpool_3 = tflearn.batch_normalization(maxpool_3)

		net = tflearn.flatten(maxpool_3, name='Net')
		net = tflearn.dropout(net, 0.1)
		
		final_1 = tflearn.fully_connected(net, 512,activation = 'relu')
		final_1 = tflearn.dropout(final_1, 0.5)

		final_2 = tflearn.fully_connected(final_1, 256,activation = 'relu')
		final_2 = tflearn.dropout(final_2, 0.5)

		Loss = tflearn.fully_connected(final_2,7,activation='softmax', name='Total_loss')

		self.network = tflearn.regression(Loss, optimizer='Adam',loss='categorical_crossentropy',learning_rate=0.0001)
		self.model = tflearn.DNN(self.network, tensorboard_verbose=0, tensorboard_dir=os.getcwd()+'/checkpoint',checkpoint_path = './data/' + '/emotion_recognition',max_checkpoints = None)
		#self.model = tflearn.DNN(self.network)
		self.load_model()

	def load_saved_dataset(self):
		self.dataset.load_from_save()
		print(' ')
		print('----------------- Dataset found and loaded -----------------')
		print(' ')

	def start_training(self):
		self.load_saved_dataset()
		self.build_network()
		if self.dataset is None:
			self.load_saved_dataset()
		# Training
		print(' ')
		print('----------------- Training network -----------------')
		print(' ')
		#self.model.fit(self.dataset.images, self.dataset.labels, validation_set = (self.dataset.images_test, self.dataset._labels_test),
		#	n_epoch = 3,batch_size = 100,shuffle = True,show_metric = True,snapshot_epoch = True,run_id = 'emotion_recognition')
		print('hello world')
		self.model.fit(self.dataset.images, self.dataset.labels, n_epoch = 140, validation_set = (self.dataset.images_test, self.dataset._labels_test), show_metric = True, batch_size = 100, run_id = 'emotion_recognition')
		
		self.model.predict(self.dataset.images_test)
		predictions = self.model.predict(self.dataset.images_test)
		matrix = confusion_matrix(self.dataset._labels_test.argmax(axis=1), predictions.argmax(axis=1))
		print(matrix)
		print(classification_report(self.dataset._labels_test.argmax(axis=1),	predictions.argmax(axis=1), target_names=EMOTIONS))
        
        
        #evali=self.model.evaluate(self.dataset.images_test, self.dataset._labels_test)
        #print("Accuracy of the model is :", evali)
        #lables = model.predict_label(self.dataset.images_test)
        #print("The predicted labels are :",lables[f])
        #prediction = model.predict(testImages)
        #print("The predicted probabilities are :", prediction[f])  
        
        
        

	def load_model(self):
		if isfile("CNN_Trained_model.meta"):
			self.model.load("CNN_Trained_model")
			
			print(' ')
			print('----------------- Model loaded -----------------')
			print(' ')
		else:
			print(' ')
			print('----------------- Can not load the model -----------------')
			print(' ')

	def save_model(self):
		self.model.save(join(SAVE_DIRECTORY, SAVE_MODEL_FILENAME))
		print(' ')
		print('------------------ Model trained and saved ----------------------')
		print(' ')
		
	def predict(self, image):
		if image is None:
			return None
		image = image.reshape([-1, SIZE_FACE, SIZE_FACE, 1])
		return self.model.predict(image)

if __name__ == "__main__":
	network = EmotionRecognition()
	network.start_training()
	network.save_model()
