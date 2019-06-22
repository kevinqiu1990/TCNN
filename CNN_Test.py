from sklearn.metrics import matthews_corrcoef, roc_auc_score, f1_score, accuracy_score
from sklearn.linear_model import LogisticRegression
import numpy as np
from torch import Tensor


def CNN_test(model_name, model, train_ast, test_ast, train_label, test_label, train_hand_craft, test_hand_craft, acc, auc, f1, mcc):

    _, _, train_x = model(train_ast)
    _, _, test_x = model(test_ast)

    if type(train_x) is Tensor:
        train_x = train_x.data.cpu().numpy()
        test_x = test_x.data.cpu().numpy()
    if type(train_label) is Tensor:
        train_label = train_label.data.cpu().numpy()
        test_label = test_label.data.cpu().numpy()
    if type(train_hand_craft) is Tensor:
        train_hand_craft = train_hand_craft.data.cpu().numpy()
        test_hand_craft = test_hand_craft.data.cpu().numpy()

    print(model_name + '------------ ')
    if model_name.startswith('DP'):
        print('Perform DP')
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