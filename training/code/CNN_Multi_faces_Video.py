# -*- coding:utf-8 -*-

import cv2
from constants import *
from Training import EmotionRecognition
import numpy as np
from PIL import Image, ImageDraw, ImageFont
import time

global face
cascade_classifier = cv2.CascadeClassifier(CASC_PATH)

# Load Model
network = EmotionRecognition()
network.build_network()


def face_predict(face, gray):
	gray = gray[face[1]:(face[1] + face[2]), face[0]:(face[0] + face[3])]
	try:
		gray = cv2.resize(gray, (SIZE_FACE, SIZE_FACE), interpolation=cv2.INTER_CUBIC) / 255.
	except Exception:
		print("[+] Problem during resize")
		return None
			
	# print(gray)
	result = network.predict(gray)
	# print(result)
	return result


if __name__ == '__main__':

	mode = 'cam'
	if mode == 'cam':  # camera
		video_capture = cv2.VideoCapture(0)
	else:  # video
		video_capture = cv2.VideoCapture(mode)
    
	video_capture.set(cv2.CAP_PROP_FRAME_WIDTH, 1000)
	video_capture.set(cv2.CAP_PROP_FRAME_HEIGHT, 550)

	while True:
		#Capture frame-by-frame
		ret, image = video_capture.read()

		if len(image.shape) > 2 and image.shape[2] == 3:
			gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
		else:
			gray = cv2.imencode(image, cv2.IMREAD_GRAYSCALE)

		faces = cascade_classifier.detectMultiScale(gray, scaleFactor=1.1,minNeighbors=5)

		for face in faces:
			(x, y, w, h) = face
			cv2.rectangle(image, (x,y), (x+w,y+h), (0,1,0), 2)
			result = face_predict(face, gray)
			text = EMOTIONS[np.argmax(result[0])]
			cv2.putText(image, text, (x, y), cv2.FONT_HERSHEY_PLAIN, 1, (255, 0, 0), 2)
		
		cv2.imshow('Video', image)
		if cv2.waitKey(1) & 0xFF == ord('q'):
			break

	cv2.waitKey(0)
	cv2.destroyAllWindows()