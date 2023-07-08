## Facial Expression Recognition System Using FPGA-Based Convolutional Neural Network

Emotion detection has become one of the most significant aspects to consider in any project related to affective computing.

We aim to classify 7 elementary types of human emotions: angry, fear, disgust, happy, sad and neutral by extracting features through those layers, respectively. 

## Table of contents
- Requirements
- Dataset
- Usage
- Results

## Requirements
```bash
pip install -r requirements.txt
``````
## Dataset

The data consists of 48 x 48 pixel grayscale images of faces. The faces have been automatically registered so that the face is more or less centred and occupies about the same amount of space in each image.

The task is to categorize each face based on the emotion shown in the facial expression into one of seven categories (0=Angry, 1=Disgust, 2=Fear, 3=Happy, 4=Sad, 5=Surprise, 6=Neutral). The training set consists of 28,709 examples and the public test set consists of 3,589 examples.

![image](./data/visual-fer-2013.jpg)

## Usage


## Results
We also tested the functions of this model on FPGA simulation and achieved over 65% of accuracy using FER-2013 dataset.
## Citation
```
@article{Phuc2021FacialER,
  title={Facial Expressions Recognition System Using FPGA-Based Convolutional Neural Network},
  author={Tai Nguyen Duong Phuc and Nam Nguyen Nhut and Nguyen Trinh and Linh Tran},
  journal={Research in Intelligent and Computing in Engineering},
  year={2021}
}
```