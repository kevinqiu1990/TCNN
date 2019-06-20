# TCNN

Transfer Convolutional Neural Network for Cross-Project Defect Prediction.

TCNN aims to mine the transferable semantic (deep-learning (DL)-generated) features for CPDP tasks. Specifically, our approach first parses the source file into integer vectors as the network inputs. Next, to obtain the TCNN model, a matching layer is added into convolutional neural network where the hidden representations of the source and target project-specific data are embedded into a reproducing kernel Hilbert space for distribution matching. By simultaneously minimizing classification error and distribution divergence between projects, the constructed TCNN could extract the transferable DL-generated features. Finally, without losing the information contained in handcrafted features, we combine them with transferable DL-generated features to form the joint features for CPDP performing.



Build running environment
=================
**1. Anaconda python 3.6 version (https://www.anaconda.com)
**2. Pytorch 0.4.1 (https://pytorch.org)

Demo
=================
After environment building, please run following file:

**1. runTra.py is used to perform traditional methods.
**2. runCNN.m is used for CNN/DPDBN performing.
**3. runDBN.m is used for DBN/DPDBN performing.
**4. unTCNN.m is used for TCNN/DPTCNN performing.

Contacts
=================
If any issues, please feel free to contact the author.

**Author Name**: Kevin Qiu
**Author Email**: qiushaojian@outlook.com