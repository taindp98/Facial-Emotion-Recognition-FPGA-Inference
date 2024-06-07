## Implementation of a Facial Expression Recognition System Using an FPGA-Based Convolutional Neural Network

This study was published in Research in Intelligent and Computing in Engineering: Select Proceedings of RICE 2021.

Emotion detection has become one of the most significant aspects to consider in any project related to Affective Computing. There are several researches in emotion recognition, where a Convolutional Neural Network is considered an efficient algorithm that achieves state-of-the-art performance in image recognition. Plenty of methods have applied the CNN model and conducted it in software. However, traditional software-based computation is not fast enough to meet the demand of real-time image processing. So, we'd like to propose an efficient method for expression recognition using FPGA-based. This model is used for classifying seven elementary types of human emotions: angry, fear, disgust, happy, sad, and neutral by extracting features through those layers respectively. We also tested the functions of this model on FPGA simulation and achieved over 65% accuracy using the FER2013 dataset.

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
We also tested the functions of this model on FPGA simulation and achieved over 65% of accuracy using FER-2013 dataset. There are three kinds of hardware resource on FPGA: adaptive logic modules (ALMs), digital signal processing (DPSs) and RAM blocks. In this work, we used Quartus Prime version 17.1 to synthesized RTL design for DE-10 standard board. The comparison result has been received and display in the following Table VI. Fig. 11 shows the simulation result of our systems.

| No. | Comparison object     | Reference design | Anonymous | Our design |
|-----|-----------------------|----------------------|----------------|------------|
| 1   | Accuracy              | 60.3%                | 59.8%          | 65%        |
| 2   | DSPs                  | 152                  | 108            |            |
| 3   | Clock frequency       | 200MHz               | 200MHz         |            |
| 4   | Signal appears output | After 2.404s         | After 2.079s   |            |


## Citation
```
@article{Phuc2021FacialER,
  title={Facial Expressions Recognition System Using FPGA-Based Convolutional Neural Network},
  author={Tai Nguyen Duong Phuc and Nam Nguyen Nhut and Nguyen Trinh and Linh Tran},
  journal={Research in Intelligent and Computing in Engineering},
  year={2021}
}
```
