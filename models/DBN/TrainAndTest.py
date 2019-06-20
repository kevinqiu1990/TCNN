from ParsingSource import *
from models.DBN.DeepBeliefNetwork import *


def train_and_test_dbn_plus(path_train_source, path_train_hand_craft, path_test_source, path_test_hand_craft,
                            package_heads, dict_params):
    """

    :param path_train_source:   训练项目的根目录路径
    :param path_train_hand_craft:   训练项目的手工标注文件路径
    :param path_test_source:         测试项目的根目录路径
    :param path_test_hand_craft:    测试项目的手工标注文件路径
    :param dict_params               dp_cnn的参数
    :param package_heads            文件包名的开头
    :return:
    """
    path_train_source = path_train_source.strip()
    project_name = path_train_source.split('/')[2]
    path_data = 'Files/dump_data/' + project_name + '/dbn'
    generate_dir_recursive(path_data)
    path_train_and_test_set = path_data + '/train_and_test_set'
    if os.path.exists(path_train_and_test_set) and not dict_params['regenerate']:
        obj = load_data(path_train_and_test_set)
        [_train_ast, _train_hand_craft, _train_label, _test_ast, _test_hand_craft, _test_label] = obj
    else:
        _train_file_names, _test_file_names = extract_hand_craft_file_name(path_train_hand_craft, path_test_hand_craft)
        _dict_token_train = parse_source(path_train_source, _train_file_names, package_heads)
        _dict_token_test = parse_source(path_test_source, _test_file_names, package_heads)

        _list_dict, _vector_len, _vocabulary_size = transform_token_to_number([_dict_token_train, _dict_token_test])
        _dict_encoding_train = _list_dict[0]
        _dict_encoding_test = _list_dict[1]
        _train_ast, _train_hand_craft, _train_label = extract_data(path_train_hand_craft, _dict_encoding_train)
        _test_ast, _test_hand_craft, _test_label = extract_data(path_test_hand_craft, _dict_encoding_test)
        obj = [_train_ast, _train_hand_craft, _train_label, _test_ast, _test_hand_craft, _test_label]
        dump_data(path_train_and_test_set, obj)

    # 再次处理不平衡问题
    _train_ast, _train_hand_craft, _train_label = imbalance_process(_train_ast, _train_hand_craft, _train_label,
                                                                    dict_params['imbalance'])

    from sklearn.preprocessing import minmax_scale
    _train_ast = minmax_scale(_train_ast)
    _layers = list()
    _layers.append(_train_ast.shape[1])
    for i in range(dict_params['hidden_layer_num']):
        _layers.append(dict_params['output_size'])

    dbn = DBN(layers=_layers, params=dict_params)
    dbn.train(_train_ast)
    c_train_x = dbn.dbn_up(_train_ast)
    c_test_x = dbn.dbn_up(_test_ast)
    _train_label = _train_label.reshape([len(_train_label)])
    _test_label = _test_label.reshape([len(_test_label)])
    c_train_x = np.concatenate((c_train_x, _train_hand_craft), axis=1)
    c_test_x = np.concatenate((c_test_x, _test_hand_craft), axis=1)
    from sklearn.linear_model import LogisticRegression
    cls = LogisticRegression()
    cls.fit(c_train_x, _train_label)

    _y_predict = cls.predict(c_test_x)
    from sklearn.metrics import matthews_corrcoef, roc_auc_score, f1_score
    f1 = f1_score(y_true=_test_label, y_pred=_y_predict)
    print("f1_score:" + str(f1))
    print("MCC:" + str(matthews_corrcoef(y_true=_test_label, y_pred=_y_predict)))
    print("AUC:" + str(roc_auc_score(y_true=_test_label, y_score=_y_predict)))

    print('current f1:' + str(f1))


if __name__ == '__main__':
    _dict_params = dbn_params_default.copy()
    from imblearn.over_sampling import SMOTE, ADASYN

    _dict_params['imbalance'] = ADASYN()
    train_and_test_dbn_plus('../../data/projects/camel-1.4/src/',
                            '../../data/csvs/camel-1.4.csv',
                            '../../data/projects/camel-1.6/src/',
                            '../../data/csvs/camel-1.6.csv',
                            ['org'], _dict_params)
