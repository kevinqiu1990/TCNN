from CNN_Test import *
from tool.imblearn.over_sampling import RandomOverSampler
import time
from Tools import *
from ParsingSource import *

now_time = str(int(time.time()))
dump_path = '../data/balanced_dump_data_' + now_time
os.mkdir(dump_path)

root_path_source = '../data/projects/'
root_path_csv = '../data/csvs/'
package_heads = ['org', 'gnu', 'bsh', 'javax', 'com']

IMBALANCE_PROCESSOR = RandomOverSampler() # RandomOverSampler(), RandomUnderSampler(), None, 'cost'

# Analyze source and target projects
path_train_and_test = []
with open('../data/pairs-CPDP.txt', 'r') as file_obj:
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

    # Generate Token
    print(path[0] + "===" + path[1])
    train_project_name = path_train_source.split('/')[3]
    test_project_name = path_test_source.split('/')[3]

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
    path_train_and_test_dump = dump_path + '/' + train_project_name + '_to_' + test_project_name
    obj = [train_ast, train_hand_craft, train_label, test_ast, test_hand_craft, test_label, vector_len, vocabulary_size]
    dump_data(path_train_and_test_dump, obj)

    # Saved to csv file
    train_project_name = train_project_name.replace('-', '_')
    train_project_name = train_project_name.replace('.', '_')
    test_project_name = test_project_name.replace('-', '_')
    test_project_name = test_project_name.replace('.', '_')

    path_train_csv = dump_path + '/' + train_project_name + '_to_' + test_project_name + '_of_' + train_project_name + '.csv'
    path_test_csv = dump_path + '/' + train_project_name + '_to_' + test_project_name + '_of_' + test_project_name + '.csv'

    # All labels are 1 and converted to 1,0 to -1
    train_label = np.where(train_label > 0, 1, -1)
    test_label = np.where(test_label > 0, 1, -1)
    # Merge features and labels
    train_hand_craft_data = np.hstack((train_hand_craft,train_label))
    test_hand_craft_data = np.hstack((test_hand_craft, test_label))

    df = pd.DataFrame(data=train_hand_craft_data)
    df.to_csv(path_train_csv, header=None, index=None)
    df = pd.DataFrame(data=test_hand_craft_data)
    df.to_csv(path_test_csv, header=None, index=None)
