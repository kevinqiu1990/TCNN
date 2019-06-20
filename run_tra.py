import datetime
import NNFilter
import TCA
import TNB
import TCA_plus

from sklearn.metrics import matthews_corrcoef, roc_auc_score, f1_score, accuracy_score
from Tools import *
from ParsingSource import *
from sklearn.linear_model import LogisticRegression
from tool.imblearn.over_sampling import RandomOverSampler

# -------Auxiliary method--------start
def init_record_data():
    record_data = {'Training Set': [], 'Test Set': [], 'Model': [], 'Loop Size': [], 'accuracy_mean': [], 'accuracy_std': [], 'AUC_mean': [],
                   'AUC_std': [], 'F-measure_mean': [], 'F-measure_std': [], 'MCC_mean': [], 'MCC_std': []}
    return record_data


def insert_param(training, test, model_name, loop_size, data):
    data['Training Set'].append(training)
    data['Test Set'].append(test)
    data['Model'].append(model_name)
    data['Loop Size'].append(str(loop_size))


def insert_result(acc_m, acc_s, auc_m, auc_s, f1_m, f1_s, mcc_m, mcc_s, data):
    data['accuracy_mean'].append(round(acc_m, 3))
    data['accuracy_std'].append(round(acc_s, 3))
    data['AUC_mean'].append(round(auc_m, 3))
    data['AUC_std'].append(round(auc_s, 3))
    data['F-measure_mean'].append(round(f1_m, 3))
    data['F-measure_std'].append(round(f1_s, 3))
    data['MCC_mean'].append(round(mcc_m, 3))
    data['MCC_std'].append(round(mcc_s, 3))


def save_data(file_name, training, test, data):
    df = pd.DataFrame(data=data, columns=['Training Set', 'Test Set', 'Model', 'Loop Size', 'accuracy_mean', 'accuracy_std', 'AUC_mean', 'AUC_std','F-measure_mean', 'F-measure_std',
                      'MCC_mean', 'MCC_std'])

    save_path = 'result/' + file_name + '.csv'

    if os.path.exists(save_path):
        df.to_csv(save_path, mode='a', header=False, index=False)
    else:
        df.to_csv(save_path, mode='w', index=False)


# -------Auxiliary method--------end

# Different methods
tr_methods = ['LR', 'TCA', 'NNFilter', 'TCA+', 'TNB']

# Some Settings
REGENERATE = False
dump_data_path = 'data/balanced_dump_data_1549189395/'
result_file_name = 'Tra Result'
# result_file_name = 'test'

IMBALANCE_PROCESSOR = RandomOverSampler()  # RandomOverSampler(), RandomUnderSampler(), None, 'cost'
HANDCRAFT_DIM = 20
root_path_source = 'data/projects/'
root_path_csv = 'data/csvs/'
package_heads = ['org', 'gnu', 'bsh', 'javax', 'com']

# Start Time
start_time = datetime.datetime.now()
start_time_str = start_time.strftime('%Y-%m-%d_%H.%M.%S')

# Get a list of source and target projects
path_train_and_test = []
with open('data/pairs-one.txt', 'r') as file_obj:
    for line in file_obj.readlines():
        line = line.strip('\n')
        line = line.strip(' ')
        path_train_and_test.append(line.split(','))

# Loop each pair of combinations
for path in path_train_and_test:

    # File
    path_train_source = root_path_source + path[0]
    path_train_handcraft = root_path_csv + path[0] + '.csv'
    path_test_source = root_path_source + path[1]
    path_test_handcraft = root_path_csv + path[1] + '.csv'

    # Regenerate Token or get from dump_data
    print(path[0] + "===" + path[1])
    train_project_name = path_train_source.split('/')[2]
    test_project_name = path_test_source.split('/')[2]
    path_train_and_test_set = dump_data_path + train_project_name + '_to_' + test_project_name
    # If you don't need to regenerate, get it directly from dump_data
    if os.path.exists(path_train_and_test_set) and not REGENERATE:
        obj = load_data(path_train_and_test_set)
        [train_ast, train_hand_craft, train_label, test_ast, test_hand_craft, test_label, vector_len, vocabulary_size] = obj
    else:
        # Get a list of instances of the training and test sets
        train_file_instances = extract_handcraft_instances(path_train_handcraft)
        test_file_instances = extract_handcraft_instances(path_test_handcraft)

        # Get tokens
        dict_token_train = parse_source(path_train_source, train_file_instances, package_heads)
        dict_token_test = parse_source(path_test_source, test_file_instances, package_heads)

        # Turn tokens into numbers
        list_dict, vector_len, vocabulary_size = transform_token_to_number([dict_token_train, dict_token_test])
        dict_encoding_train = list_dict[0]
        dict_encoding_test = list_dict[1]

        # Take out data that can be used for training
        train_ast, train_hand_craft, train_label = extract_data(path_train_handcraft, dict_encoding_train)
        test_ast, test_hand_craft, test_label = extract_data(path_test_handcraft, dict_encoding_test)

        # Imbalanced processing
        train_ast, train_hand_craft, train_label = imbalance_process(train_ast, train_hand_craft, train_label, IMBALANCE_PROCESSOR)

        # Saved to dump_data
        obj = [train_ast, train_hand_craft, train_label, test_ast, test_hand_craft, test_label, vector_len, vocabulary_size]
        dump_data(path_train_and_test_set, obj)

    # Z-score
    nor_train_hand_craft = (train_hand_craft - np.mean(train_hand_craft, axis=0)) / np.std(train_hand_craft, axis=0)
    nor_test_hand_craft = (test_hand_craft - np.mean(test_hand_craft, axis=0)) / np.std(test_hand_craft, axis=0)

    for model_name in tr_methods:
        print(model_name)
        c_weights = None
        c_train_x = nor_train_hand_craft
        c_train_y = train_label
        c_test_x = nor_test_hand_craft

        if model_name in ['LR']:
            print('LR Done')
        elif model_name in ['TCA']:
            tca = TCA.TCA(kernel_type='linear', dim=10, lamb=1, gamma=1)
            c_train_x, c_test_x = tca.fit(c_train_x, c_test_x)
            print('TCA Done')
        elif model_name in ['TNB']:
            tnb = TNB.TNB()
            c_weights = tnb.cal_data_gravitation(c_train_x, c_test_x)
            print('TNB Done')
        elif model_name in ['NNFilter']:
            nn_filter = NNFilter.NNFilter()
            c_train_x, c_train_y = nn_filter.filter(10, c_train_x, c_test_x, c_train_y)
            print('NNFilter Done')
        elif model_name in ['TCA+']:
            tca_plus = TCA_plus.TCA_plus(kernel_type='linear', dim=10, lamb=1, gamma=1)
            DCV_s = tca_plus.get_characteristic_vector(train_hand_craft)
            DCV_t = tca_plus.get_characteristic_vector(test_hand_craft)
            normalization_option = tca_plus.select_normalization_method(DCV_s, DCV_t)
            new_Xs, new_Xt = tca_plus.get_normalization_result(train_hand_craft, test_hand_craft,
                                                               method_type=normalization_option)
            c_train_x, c_test_x = tca_plus.fit(new_Xs, new_Xt)
            print('TCA+ Done')

        cls = LogisticRegression();
        cls.fit(c_train_x, c_train_y, sample_weight=c_weights)
        y_pred = cls.predict(c_test_x)

        acc = accuracy_score(y_true=test_label, y_pred=y_pred)
        auc = roc_auc_score(y_true=test_label, y_score=y_pred)
        f1 = f1_score(y_true=test_label, y_pred=y_pred)
        mcc = matthews_corrcoef(y_true=test_label, y_pred=y_pred)

        # Save the results in a file
        record_data = init_record_data()
        insert_result(acc, 0, auc, 0, f1, 0, mcc, 0, data=record_data)
        insert_param(training=path[0], test=path[1], model_name=model_name, loop_size=1, data=record_data)
        save_data(result_file_name, path[0], path[1], record_data)

# End time
end_time = datetime.datetime.now()
print(end_time - start_time)
