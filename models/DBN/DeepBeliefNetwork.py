from models.DBN.RestrictBoltzMachine import RBM
import torch


class DBN(object):
    def __init__(self, layers, params):
        """
        :param layers:      [] 用于确定每一层的node数量  [visible,h1,h2,h3......]
        :param params:      {} 用于确定epoch，batch
        """
        self.rbms = []
        self.layers = layers
        self.params = params
        if torch.cuda.is_available():
            self.device = torch.device('cuda')
        else:
            self.device = torch.device('cpu')
        for i in range(len(layers) - 1):
            self.rbms.append(RBM(layers[i], layers[i + 1], "h" + str(i), params))

    def train(self, train_data):
        train_data = torch.DoubleTensor(train_data).to(self.device)
        for rbm in self.rbms:
            rbm.train(train_data)
            train_data = rbm.rbm_v_to_h(train_data)
            print(train_data)
        return train_data

    def dbn_up(self, data):
        """
        输入数据到dbn，在隐藏层输出特征
        :param data: narray[[...],[...]...]
        :return:
        """
        data = torch.DoubleTensor(data).to(self.device)
        for rbm in self.rbms:
            data = rbm.rbm_v_to_h(data)
        return data.numpy()
