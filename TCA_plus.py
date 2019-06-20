# encoding=utf-8

import numpy as np
import scipy.io
import scipy.linalg
import sklearn.metrics
import sklearn.neighbors

from sklearn import preprocessing
from scipy.spatial.distance import cdist


def kernel(ker, X, X2, gamma):
    if not ker or ker == 'primal':
        return X
    elif ker == 'linear':
        if not X2:
            K = np.dot(X.T, X)
        else:
            K = np.dot(X.T, X2)
    elif ker == 'rbf':
        n1sq = np.sum(X ** 2, axis=0)
        n1 = X.shape[1]
        if not X2:
            D = (np.ones((n1, 1)) * n1sq).T + np.ones((n1, 1)) * n1sq - 2 * np.dot(X.T, X)
        else:
            n2sq = np.sum(X2 ** 2, axis=0)
            n2 = X2.shape[1]
            D = (np.ones((n2, 1)) * n1sq).T + np.ones((n1, 1)) * n2sq - 2 * np.dot(X.T, X)
        K = np.exp(-gamma * D)
    elif ker == 'sam':
        if not X2:
            D = np.dot(X.T, X)
        else:
            D = np.dot(X.T, X2)
        K = np.exp(-gamma * np.arccos(D) ** 2)
    return K


class TCA_plus:
    def __init__(self, kernel_type='primal', dim=30, lamb=1, gamma=1):
        """
        Init func
        :param kernel_type: kernel, values: 'primal' | 'linear' | 'rbf' | 'sam'
        :param dim: dimension after transfer
        :param lamb: lambda value in equation
        :param gamma: kernel bandwidth for rbf kernel
        """
        self.kernel_type = kernel_type
        self.dim = dim
        self.lamb = lamb
        self.gamma = gamma

    def fit(self, Xs, Xt):
        """
        Transform Xs and Xt
        :param Xs: ns * n_feature, source feature
        :param Xt: nt * n_feature, target feature
        :return: Xs_new and Xt_new after TCA
        """
        X = np.hstack((Xs.T, Xt.T))
        X /= np.linalg.norm(X, axis=0)
        m, n = X.shape
        ns, nt = len(Xs), len(Xt)
        e = np.vstack((1 / ns * np.ones((ns, 1)), -1 / nt * np.ones((nt, 1))))
        M = e * e.T
        M = M / np.linalg.norm(M, 'fro')
        H = np.eye(n) - 1 / n * np.ones((n, n))
        K = kernel(self.kernel_type, X, None, gamma=self.gamma)
        n_eye = m if self.kernel_type == 'primal' else n
        a, b = np.linalg.multi_dot([K, M, K.T]) + self.lamb * np.eye(n_eye), np.linalg.multi_dot([K, H, K.T])
        w, V = scipy.linalg.eig(a, b)
        ind = np.argsort(w)
        A = V[:, ind[:self.dim]]
        Z = np.dot(A.T, K)
        Z /= np.linalg.norm(Z, axis=0)
        Xs_new, Xt_new = Z[:, :ns].T, Z[:, ns:].T
        return Xs_new, Xt_new

    def fit_predict(self, Xs, Ys, Xt, Yt):
        """
        Transform Xs and Xt, then make predictions on target using 1NN
        :param Xs: ns * n_feature, source feature
        :param Ys: ns * 1, source label
        :param Xt: nt * n_feature, target feature
        :param Yt: nt * 1, target label
        :return: Accuracy and predicted_labels on the target domain
        """
        Xs_new, Xt_new = self.fit(Xs, Xt)
        clf = sklearn.neighbors.KNeighborsClassifier(n_neighbors=1)
        clf.fit(Xs_new, Ys.ravel())
        y_pred = clf.predict(Xt_new)
        return y_pred

    @staticmethod
    def N1_normalize(x):
        min_max_scaler = preprocessing.MinMaxScaler()
        x = min_max_scaler.fit_transform(x)
        return x

    @staticmethod
    def N2_normalize(x):
        x = (x - np.mean(x, axis=0)) / np.std(x, axis=0)
        return x

    @staticmethod
    def N3_normalize(Xs, Xt):
        Xs = (Xs - np.mean(Xs, axis=0)) / np.std(Xs, axis=0)
        Xt = (Xt - np.mean(Xs, axis=0)) / np.std(Xs, axis=0)
        return Xs, Xt

    @staticmethod
    def N4_normalize(Xs, Xt):
        Xs = (Xs - np.mean(Xt, axis=0)) / np.std(Xt, axis=0)
        Xt = (Xt - np.mean(Xt, axis=0)) / np.std(Xt, axis=0)
        return Xs, Xt

    def get_normalization_result(self, Xs, Xt, method_type='NoN'):
        new_Xs, new_Xt = None, None
        if method_type == 'NoN':
            print('No normalization')
            new_Xs = Xs
            new_Xt = Xt
        elif method_type == 'N1':
            print('N1 normalization')
            new_Xs = self.N1_normalize(Xs)
            new_Xt = self.N1_normalize(Xt)
        elif method_type == 'N2':
            print('N2 normalization')
            new_Xs = self.N2_normalize(Xs)
            new_Xt = self.N2_normalize(Xt)
        elif method_type == 'N3':
            print('N3 normalization')
            new_Xs, new_Xt = self.N3_normalize(Xs, Xt)
        elif method_type == 'N4':
            print('N4 normalization')
            new_Xs, new_Xt = self.N4_normalize(Xs, Xt)
        return new_Xs, new_Xt

    @staticmethod
    def get_characteristic_vector(x):
        DIST = cdist(x, x, metric='euclidean')
        numInstances = np.array(x).shape[0]
        dist_mean = np.mean(DIST)
        dist_median = np.median(DIST)
        dist_min = np.min(DIST)
        dist_max = np.max(DIST)
        dist_std = np.std(DIST)
        return dist_mean, dist_median, dist_min, dist_max, dist_std, numInstances

    @staticmethod
    def get_nominal_values(cs, ct):
        value = None
        if ct < cs * 0.4:
            value = 'MUCH LESS'
        elif cs * 0.4 <= ct < cs * 0.7:
            value = 'LESS'
        elif cs * 0.7 <= ct < cs * 0.9:
            value = 'SLIGHTLY LESS'
        elif cs * 0.9 <= ct < cs * 1.1:
            value = 'SAME'
        elif cs * 1.1 <= ct < cs * 1.3:
            value = 'SLIGHTLY MORE'
        elif cs * 1.3 <= ct < cs * 1.6:
            value = 'MORE'
        elif cs * 1.6 <= ct:
            value = 'MUCH MORE'
        # print(value)
        return value

    def select_normalization_method(self, DCV_s, DCV_t):
        s_mean, s_median, s_min, s_max, s_std, s_numInstances = DCV_s
        t_mean, t_median, t_min, t_max, t_std, t_numInstances = DCV_t

        similarity_mean = self.get_nominal_values(s_mean, t_mean)
        similarity_median = self.get_nominal_values(s_median, t_median)
        similarity_min = self.get_nominal_values(s_min, t_min)
        similarity_max = self.get_nominal_values(s_max, t_max)
        similarity_std = self.get_nominal_values(s_std, t_std)
        similarity_numInstances = self.get_nominal_values(s_numInstances, t_numInstances)

        # rule 1
        if similarity_mean == 'SAME' and similarity_std == 'SAME':
            normalization_option = 'NoN'

        # rule 2
        elif (similarity_numInstances == 'MUCH MORE' or similarity_numInstances == 'MUCH LESS') and \
                (similarity_min == 'MUCH MORE' or similarity_min == 'MUCH LESS') and \
                (similarity_max == 'MUCH MORE' or similarity_max == 'MUCH LESS'):
            normalization_option = 'N1'

        # rule 3
        elif (similarity_std == 'MUCH MORE' and (similarity_numInstances == 'SLIGHTLY LESS' or
                                similarity_numInstances == 'LESS' or similarity_numInstances == 'MUCH LESS')) or \
                (similarity_std == 'MUCH LESS' and (similarity_numInstances == 'SLIGHTLY MORE' or
                                similarity_numInstances == 'MORE' or similarity_numInstances == 'MUCH MORE')):
            normalization_option = 'N3'

        # rule 4
        elif (similarity_std == 'MUCH MORE' and similarity_numInstances == 'MUCH MORE') or \
                (similarity_std == 'MUCH LESS' and similarity_numInstances == 'MUCH LESS'):
            normalization_option = 'N4'

        # rule 5
        else:
            normalization_option = 'N2'
        print('######', normalization_option)
        return normalization_option
