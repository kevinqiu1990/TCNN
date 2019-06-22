from sklearn.metrics import matthews_corrcoef, roc_auc_score, f1_score, accuracy_score
from sklearn.linear_model import LogisticRegression
import numpy as np


def DBN_test(model_name, train_x, test_x, train_label, test_label, train_hand_craft, test_hand_craft, acc, auc, f1, mcc):
    print(model_name + '------------ ')
    if model_name.startswith('DP'):
        print('做的DP')
        train_x = np.concatenate((train_x, train_hand_craft), axis=1)
        test_x = np.concatenate((test_x, test_hand_craft), axis=1)

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

