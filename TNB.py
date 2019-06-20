# encoding=utf-8

import numpy as np
from sklearn.naive_bayes import GaussianNB


class TNB:
    def __init__(self):
        pass

    @staticmethod
    def cal_data_gravitation(Xs, Xt):
        gra_mat = np.zeros((Xs.shape[0], 1))
        max_j = np.max(Xt, 0)
        min_j = np.min(Xt, 0)

        for i in range(Xs.shape[0]):
            for j in range(Xs.shape[1]):
                if min_j[j] <= Xs[i, j] <= max_j[j]:
                    gra_mat[i, :] = gra_mat[i, :] + 1

        gravitation = np.square((gra_mat / (Xs.shape[1] - gra_mat + 1)))
        gravitation = (gravitation / sum(gravitation)).flatten()
        return gravitation

    def fit_predict(self, Xs, Ys, Xt, Yt):
        """
        Transform Xs and Xt, then make predictions on target using 1NN
        :param Xs: ns * n_feature, source feature
        :param Ys: ns * 1, source label
        :param Xt: nt * n_feature, target feature
        :param Yt: nt * 1, target label
        :return: Accuracy and predicted_labels on the target domain
        """
        weights = self.cal_data_gravitation(Xs, Xt)
        clf = GaussianNB()
        clf.fit(Xs, Ys, sample_weight=weights)
        y_pred = clf.predict(Xt)
        return y_pred
