from __future__ import print_function
import torch
import torch.nn.functional as F


class RBM(object):
    def __init__(self, input_size, output_size, name, params):
        super().__init__()
        self.device = torch.device('cpu')

        self.w = torch.randn(input_size, output_size, dtype=torch.double).to(self.device)
        self.vb = torch.zeros(input_size, dtype=torch.double).to(self.device)
        self.hb = torch.zeros(output_size, dtype=torch.double).to(self.device)
        self.name = name
        self.input_size = input_size
        self.output_size = output_size
        self.params = params

    @staticmethod
    def probability_h_to_v(hidden, weights, v_bias):
        """
        :param hidden: Hidden layer type=torch.tensor ,[batch_size * output_size]
        :param weights: Weights type=torch.tensor,[input_size * output_size]
        :param v_bias: Bias  type=torch.tensor ,[input_size]
        :return:  Probability type=torch.tensor [batch_size * input_size]
        """
        return torch.sigmoid(hidden @ weights.t() + v_bias)

    @staticmethod
    def probability_v_to_h(visible, weights, h_bias):
        """
        :param visible: Visible layer type=torch.tensor,[batch_size * input_size]
        :param weights: Weights type=torch.tensor,[input_size*output_size]
        :param h_bias: Bias type=torch.tensor，[output_size]
        :return: Probability type=torch.tensor [batch_size * output_size]
        """
        return torch.sigmoid(visible @ weights + h_bias)

    @staticmethod
    def sample_from_probability(probability):
        """
        Enter a vector with a visible or hidden layer probability of 1 vector and an output unit of 0 or 1.
        :param probability:    [0.1,0.2,0.4,0.3......]
        :return:                [0,0,1,1,.....]
        """
        return F.relu(torch.sign(probability - torch.rand_like(probability)))

    @staticmethod
    def given_v_sample_h(visible, weights, h_bias):
        """
        Given the value of the visible layer, find the value of the hidden layer by probability
        :param visible:
        :param weights
        :param h_bias
        :return:
        """
        return RBM.sample_from_probability(RBM.probability_v_to_h(visible, weights, h_bias))

    @staticmethod
    def given_h_sample_v(hidden, weights, v_bias):
        """
        Given the value of the hidden layer, find the value of the visible layer by probability
        :param hidden:
        :param weights
        :param v_bias
        :return:
        """
        return RBM.sample_from_probability(RBM.probability_h_to_v(hidden, weights, v_bias))

    @staticmethod
    def split_batch(data_size, batch_size):
        start_indexes = []
        end_indexes = []

        if data_size < batch_size:
            start_indexes.append(0)
            end_indexes.append(data_size)
        else:
            end_index = 0
            for i, j in zip(range(0, data_size, batch_size), range(batch_size, data_size, batch_size)):
                start_indexes.append(i)
                end_indexes.append(j)
                end_index = j
            if end_index < data_size:
                start_indexes.append(end_index)
                end_indexes.append(data_size)
        return start_indexes, end_indexes

    def train(self, data):
        """
        :param data: type=torch.tensor        [n_data * input_size]
        :return:
        """
        start_indexes, end_indexes = self.split_batch(len(data), self.params["BATCH_SIZE"])
        for i in range(self.params['N_EPOCH']):
            print('epoch:', i, 'in', self.name)
            for start, end in zip(start_indexes, end_indexes):
                batch = data[start:end]
                _ts_v0 = batch
                _ts_probability_h0 = RBM.probability_v_to_h(_ts_v0, self.w, self.hb)
                _ts_h0 = RBM.sample_from_probability(_ts_probability_h0)
                _ts_probability_v1 = RBM.probability_h_to_v(_ts_h0, self.w, self.vb)
                _ts_v1 = RBM.sample_from_probability(_ts_probability_v1)
                _ts_probability_h1 = RBM.probability_v_to_h(_ts_v1, self.w, self.hb)
                self.w += self.params['LEARNING_RATE'] * \
                          (_ts_v0.t() @ _ts_probability_h0 - _ts_v1.t() @ _ts_probability_h1) \
                          / (end - start)
                self.vb += self.params['LEARNING_RATE'] * (_ts_v0 - _ts_v1).mean(0)
                self.hb += self.params['LEARNING_RATE'] * (_ts_probability_h0 - _ts_probability_h1).mean(0)

    def rbm_v_to_h(self, data):
        """
        :param data: torch.tensor  [batch_size * input_size]
        :return: torch.tensor([[...],[...]...])
        """
        return torch.sigmoid(data @ self.w + self.hb)
