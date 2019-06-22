from sklearn.metrics import matthews_corrcoef, roc_auc_score, f1_score, accuracy_score
from sklearn.linear_model import LogisticRegression
from torch import Tensor

import numpy as np
import TCA


def TCNN_test(model_name, model, train_ast, test_ast, train_label, test_label, train_hand_craft, test_hand_craft, acc, auc, f1, mcc):
    _, _, train_x, _, _ = model(train_ast, train_ast, train_ast)
    _, _, test_x, _, _ = model(test_ast, train_ast, train_ast)

    import sys
    print(sys.getsizeof(train_x))
    print(sys.getsizeof(test_x))

    if type(train_x) is Tensor:
        train_x = train_x.data.cpu().numpy()
        test_x = test_x.data.cpu().numpy()
    if type(train_label) is Tensor:
        train_label = train_label.data.cpu().numpy()
        test_label = test_label.data.cpu().numpy()
    if type(train_hand_craft) is Tensor:
        train_hand_craft = train_hand_craft.data.cpu().numpy()
        test_hand_craft = test_hand_craft.data.cpu().numpy()

    if model_name.startswith('DP'):
        print('Perform TCA')
        tca = TCA.TCA(kernel_type='linear', dim=10, lamb=1, gamma=1)
        tca_train_hand_craft, tca_test_hand_craft = tca.fit(train_hand_craft, test_hand_craft)

        print('Perform 做的DP')
        train_x = np.concatenate((train_x, tca_train_hand_craft), axis=1)
        test_x = np.concatenate((test_x, tca_test_hand_craft), axis=1)

    # Z-score
    train_x = (train_x - np.mean(train_x, axis=0)) / np.std(train_x, axis=0)
    test_x = (test_x - np.mean(test_x, axis=0)) / np.std(test_x, axis=0)

    # Perform Prediction
    cls = LogisticRegression()
    cls.fit(train_x, train_label)
    y_pred = cls.predict(test_x)

    # Save Result
    acc.append(accuracy_score(y_true=test_label, y_pred=y_pred))
    auc.append(roc_auc_score(y_true=test_label, y_score=y_pred))
    f1.append(f1_score(y_true=test_label, y_pred=y_pred))
    mcc.append(matthews_corrcoef(y_true=test_label, y_pred=y_pred))

    return acc, auc, f1, mcc