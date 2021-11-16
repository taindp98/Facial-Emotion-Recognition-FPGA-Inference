import cv2
from constants import *
from Training import EmotionRecognition
import numpy as np
from PIL import Image, ImageDraw, ImageFont
import tflearn
import tensorflow as tf

# Load Model
network = EmotionRecognition()
network.build_network()

# Convolution_1
conv_1_var=tflearn.get_layer_variables_by_name("Conv2d_1")
print("Convolution_1 layer weights:")
print(network.model.get_weights(conv_1_var[0]))
print("Convolution_1 layer Bias:")
print(network.model.get_weights(conv_1_var[1]))

# Convolution_2a
conv_2a_var=tflearn.get_layer_variables_by_name("Conv_2a_FX1")
print("Convolution_2a layer weights:")
print(network.model.get_weights(conv_2a_var[0]))
print("Convolution_2a layer Bias:")
print(network.model.get_weights(conv_2a_var[1]))

# Convolution_2b
conv_2b_var=tflearn.get_layer_variables_by_name("Conv_2b_FX1")
print("Convolution_2b layer weights:")
print(network.model.get_weights(conv_2b_var[0]))
print("Convolution_2b layer Bias:")
print(network.model.get_weights(conv_2b_var[1]))

# Convolution_3a
conv_3a_var=tflearn.get_layer_variables_by_name("Conv_3a_FX2")
print("Convolution_3a layer weights:")
print(network.model.get_weights(conv_3a_var[0]))
print("Convolution_3a layer Bias:")
print(network.model.get_weights(conv_3a_var[1]))

# Convolution_3b
conv_3b_var=tflearn.get_layer_variables_by_name("Conv_3b_FX2")
print("Convolution_3b layer weights:")
print(network.model.get_weights(conv_3b_var[0]))
print("Convolution_3b layer Bias:")
print(network.model.get_weights(conv_3b_var[1]))

# Convolution_3c
conv_3c_var=tflearn.get_layer_variables_by_name("Conv_3c_FX2")
print("Convolution_3c layer weights:")
print(network.model.get_weights(conv_3c_var[0]))
print("Convolution_3c layer Bias:")
print(network.model.get_weights(conv_3c_var[1]))

# Fully_connected_layer
loss_var=tflearn.get_layer_variables_by_name("loss")
print("Fully_connected_layer weights:")
print(network.model.get_weights(loss_var[0]))
print("Fully_connected_layer_layer Bias:")
print(network.model.get_weights(loss_var[1]))

