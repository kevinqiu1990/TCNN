# encoding=utf-8

import numpy as np
from scipy.spatial.distance import cdist
from sklearn.naive_bayes import GaussianNB


def find_k_nearest_index(X, k):
    n, m = np.array(X).shape
    temp_index = []
    for i in range(m):
        temp_index.append(np.argsort(X[:, i])[:k])
    return np.array(temp_index).transpose()


class NNFilter:
    def __init__(self):
        pass

    @staticmethod
    def filter(k, Xs, Xt, Ys):
        target_size = Xt.shape[0]

        distance = cdist(Xs, Xt, metric='euclidean')
        index = find_k_nearest_index(distance, k=10)

        all_nearest_index = []
        filtered_Xs = []
        filtered_Ys = []
        for i in range(k):
            for j in range(target_size):
                if index[i, j] not in all_nearest_index:
                    all_nearest_index.append(index[i, j])
                    filtered_Xs.append(Xs[index[i, j], :])
                    filtered_Ys.append(Ys[index[i, j]])

        return filtered_Xs, filtered_Ys

    @staticmethod
    def fit_predict(Xs, Ys, Xt, Yt):
        clf = GaussianNB()
        clf.fit(Xs, Ys)
        y_pred = clf.predict(Xt)
        return y_pred
