import cv2
from constants import *
from Training import EmotionRecognition
import numpy as np
from PIL import Image, ImageDraw, ImageFont
import tflearn
import tensorflow as tf
from dataset_loader import DatasetLoader

# Load Model
network = EmotionRecognition()
network.build_network()
network.dataset = DatasetLoader()
network.load_saved_dataset()

print(' ')
print('----------------- Please be patient! Computer is calculating the accuracy-----------------')
print(' ')

scores = network.model.evaluate(network.dataset._images_privateTest, network.dataset._labels_privateTest)

print('----------------- Accuracy of trained model: %0.2f%%' % (scores[0]*100))
print(' ')
print('----------------- Thank you very much for your patience!-----------------')