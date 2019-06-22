import datetime
import itertools
import torch
import models.DBN as DBN

from sklearn.preprocessing import minmax_scale
from tool.imblearn.over_sampling import RandomOverSampler
from ParsingSource import *
from DBN_Test import *
from Tools import *

# -------Auxiliary method--------start
def init_record_data():
    record_data = {'Training Set': [], 'Test Set': [], 'Model': [], 'Output Size': [], 'Number of Hidden Layer': [],
                   'Number of Epoch': [], 'Batch Size': [], 'Learning Rate': [], 'Loop Size': [], 'accuracy_mean': [], 'accuracy_std': [], 'AUC_mean': [],
                   'AUC_std': [], 'F-measure_mean': [], 'F-measure_std': [], 'MCC_mean': [], 'MCC_std': []}
    return record_data


def insert_param(training, test, model_name, nn_params, loop_size, data):
    data['Training Set'].append(training)
    data['Test Set'].append(test)
    data['Model'].append(model_name)

    data['Output Size'].append(nn_params['OUTPUT_SIZE'])
    data['Number of Hidden Layer'].append(nn_params['HIDDEN_LAYER_NUM'])
    data['Number of Epoch'].append(nn_params['N_EPOCH'])
    data['Batch Size'].append(nn_params['BATCH_SIZE'])
    data['Learning Rate'].append(nn_params['LEARNING_RATE'])

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
    df = pd.DataFrame(data=data,
                      columns=['Training Set', 'Test Set', 'Model', 'Output Size', 'Number of Hidden Layer', 'Number of Epoch',
                               'Batch Size', 'Learning Rate', 'Loop Size', 'accuracy_mean', 'accuracy_std', 'AUC_mean', 'AUC_std',
                               'F-measure_mean', 'F-measure_std', 'MCC_mean', 'MCC_std'])

    save_path = 'result/' + file_name + '.csv'
    if os.path.exists(save_path):
        df.to_csv(save_path, mode='a', header=False, index=False)
    else:
        df.to_csv(save_path, mode='w', index=False)


def calculate_save_data(model_name, path0, path1, dbn_params, LOOP_SIZE, acc, auc, f1, mcc):
    # Calculate the mean and standard deviation
    acc, auc, f1, mcc = np.array(acc), np.array(auc), np.array(f1), np.array(mcc)
    acc_m, acc_s, auc_m, auc_s, f1_m, f1_s, mcc_m, mcc_s = acc.mean(), acc.std(), auc.mean(), auc.std(), f1.mean(), f1.std(), mcc.mean(), mcc.std()

    # Save the results in a file
    record_data = init_record_data()
    insert_result(acc_m, acc_s, auc_m, auc_s, f1_m, f1_s, mcc_m, mcc_s, data=record_data)
    insert_param(training=path0, test=path1, model_name=model_name, nn_params=dbn_params, loop_size=LOOP_SIZE, data=record_data)
    save_data(result_file_name, path0, path1, record_data)


# -------Auxiliary method--------end

# Initial super-parameter of network
init_dbn_params = {'OUTPUT_SIZE': 100, 'HIDDEN_LAYER_NUM': 10, 'N_EPOCH': 50, 'BATCH_SIZE': 64, 'LEARNING_RATE': 1e-5}

# Adjustable parameter
result_file_name = 'DBN Result'
LOOP_SIZE = 1  # 20

# DBN parameter
opt_batchsize = [64]
opt_node = [100]
opt_n_filter = [10]
opt_epoch = [50] #50
opt_learning_rate = [1e-5]

# Fixed parameter
IMBALANCE_PROCESSOR = RandomOverSampler()  # RandomOverSampler(), RandomUnderSampler(), None, 'cost'
HANDCRAFT_DIM = 20
DEVICE = torch.device('cpu')
root_path_source = 'data/projects/'
root_path_csv = 'data/csvs/'
package_heads = ['org', 'gnu', 'bsh', 'javax', 'com']

# Start time
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

    # ------------------ DBN training begins ------------------
    DBN_acc, DBN_auc, DBN_f1, DBN_mcc = [], [], [], []
    DPDBN_acc, DPDBN_auc, DPDBN_f1, DPDBN_mcc = [], [], [], []
    for loop_step in range(LOOP_SIZE):
        dump_data_path = 'data/balanced_dump_data_1549189395/'

        # Get file
        path_train_source = root_path_source + path[0]
        path_train_handcraft = root_path_csv + path[0] + '.csv'
        path_test_source = root_path_source + path[1]
        path_test_handcraft = root_path_csv + path[1] + '.csv'

        # Regenerate token or get from dump_data
        print(path[0] + "===" + path[1])
        train_project_name = path_train_source.split('/')[2]
        test_project_name = path_test_source.split('/')[2]
        path_train_and_test_set = dump_data_path + train_project_name + '_to_' + test_project_name

        obj = load_data(path_train_and_test_set)
        [train_ast, train_hand_craft, train_label, test_ast, test_hand_craft, test_label, vector_len, vocabulary_size] = obj

        # ZScore
        train_hand_craft = (train_hand_craft - np.mean(train_hand_craft, axis=0)) / np.std(train_hand_craft, axis=0)
        test_hand_craft = (test_hand_craft - np.mean(test_hand_craft, axis=0)) / np.std(test_hand_craft, axis=0)

        # DBN_module-based method
        for params_i in itertools.product(opt_node, opt_n_filter, opt_epoch, opt_learning_rate, opt_batchsize):
            # Parameter init
            dbn_params = init_dbn_params.copy()

            # Select nn parameters
            dbn_params['OUTPUT_SIZE'] = params_i[0]
            dbn_params['HIDDEN_LAYER_NUM'] = params_i[1]
            dbn_params['N_EPOCH'] = params_i[2]
            dbn_params['LEARNING_RATE'] = params_i[3]
            dbn_params['BATCH_SIZE'] = params_i[4]

            # minmax
            ast = np.vstack((train_ast, test_ast))
            ast = minmax_scale(ast)

            minmax_train_ast = ast[:train_ast.shape[0], :]
            minmax_test_ast = ast[train_ast.shape[0]:, :]

            # Data from numpy to tensor
            minmax_train_ast = torch.Tensor(minmax_train_ast).to(DEVICE)
            minmax_test_ast = torch.Tensor(minmax_test_ast).to(DEVICE)


            layers = list()
            layers.append(train_ast.shape[1])
            for i in range(dbn_params['HIDDEN_LAYER_NUM']):
                layers.append(dbn_params['OUTPUT_SIZE'])

            dbn = DBN.DBN(layers=layers, params=dbn_params)
            dbn.train(minmax_train_ast)
            c_train_x = dbn.dbn_up(minmax_train_ast)
            c_test_x = dbn.dbn_up(minmax_test_ast)
            train_label = train_label.reshape([len(train_label)])
            test_label = test_label.reshape([len(test_label)])

            # DBN
            model_name = 'DBN'
            DBN_acc, DBN_auc, DBN_f1, DBN_mcc = DBN_test(model_name, c_train_x, c_test_x, train_label, test_label,
                                                         train_hand_craft, test_hand_craft, DBN_acc, DBN_auc, DBN_f1, DBN_mcc)

            # DPDBN
            model_name = 'DPDBN'
            DPDBN_acc, DPDBN_auc, DPDBN_f1, DPDBN_mcc = DBN_test(model_name, c_train_x, c_test_x, train_label, test_label, train_hand_craft,
                                                                 test_hand_craft, DPDBN_acc, DPDBN_auc, DPDBN_f1, DPDBN_mcc)

    # The result is calculated and stored in the file
    calculate_save_data('DBN', path[0], path[1], dbn_params, LOOP_SIZE, DBN_acc, DBN_auc, DBN_f1, DBN_mcc)
    calculate_save_data('DPDBN', path[0], path[1], dbn_params, LOOP_SIZE, DPDBN_acc, DPDBN_auc, DPDBN_f1, DPDBN_mcc)
    # ------------------ Training End ------------------

# End Time
end_time = datetime.datetime.now()
print(end_time - start_time)
