from models import RBM
import torch


class DBN(object):
    def __init__(self, layers, params):
        self.rbms = []
        self.layers = layers
        self.params = params
        self.device = torch.device('cpu')

        for i in range(len(layers) - 1):
            self.rbms.append(RBM.RBM(layers[i], layers[i + 1], "h" + str(i), params))

    def train(self, train_data):
        train_data = torch.DoubleTensor(train_data.double()).to(self.device)
        for rbm in self.rbms:
            rbm.train(train_data)
            train_data = rbm.rbm_v_to_h(train_data)
            print(train_data)
        return train_data

    def dbn_up(self, data):
        data = torch.DoubleTensor(data.double()).to(self.device)
        for rbm in self.rbms:
            data = rbm.rbm_v_to_h(data)
        return data.numpy()
