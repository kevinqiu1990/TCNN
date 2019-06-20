import tool.javalang as jl
import os
import tool.javalang.tree as jlt
import numpy as np
import pandas as pd

types = [jlt.FormalParameter, jlt.BasicType, jlt.PackageDeclaration, jlt.InterfaceDeclaration, jlt.CatchClauseParameter,
         jlt.ClassDeclaration, jlt.MemberReference, jlt.SuperMemberReference, jlt.ConstructorDeclaration, jlt.ReferenceType,
         jlt.MethodDeclaration, jlt.VariableDeclarator, jlt.IfStatement, jlt.WhileStatement, jlt.DoStatement,
         jlt.ForStatement, jlt.AssertStatement, jlt.BreakStatement, jlt.ContinueStatement, jlt.ReturnStatement,
         jlt.ThrowStatement, jlt.SynchronizedStatement, jlt.TryStatement,jlt.SwitchStatement, jlt.BlockStatement,
         jlt.StatementExpression, jlt.TryResource, jlt.CatchClause, jlt.CatchClauseParameter, jlt.SwitchStatementCase,
         jlt.ForControl, jlt.EnhancedForControl]

types_CPDP = [jlt.FormalParameter, jlt.BasicType, jlt.PackageDeclaration, jlt.InterfaceDeclaration, jlt.CatchClauseParameter,
         jlt.ClassDeclaration, jlt.MethodInvocation, jlt.SuperMethodInvocation, jlt.MemberReference, jlt.SuperMemberReference,
         jlt.ConstructorDeclaration, jlt.ReferenceType, jlt.MethodDeclaration, jlt.VariableDeclarator, jlt.IfStatement,
         jlt.WhileStatement, jlt.DoStatement, jlt.ForStatement, jlt.AssertStatement, jlt.BreakStatement,
         jlt.ContinueStatement, jlt.ReturnStatement, jlt.ThrowStatement, jlt.SynchronizedStatement, jlt.TryStatement,
         jlt.SwitchStatement, jlt.BlockStatement, jlt.StatementExpression, jlt.TryResource, jlt.CatchClause,
         jlt.CatchClauseParameter, jlt.SwitchStatementCase, jlt.ForControl, jlt.EnhancedForControl, jlt.ClassCreator]

features = ['wmc', 'dit', 'noc', 'cbo', 'rfc', 'lcom', 'ca', 'ce', 'npm', 'lcom3', 'loc', 'dam', 'moa', 'mfa', 'cam',
            'ic', 'cbm', 'amc', 'max_cc', 'avg_cc']


def append_suffix(df):
    for i in range(len(df['file_name'])):
        df.loc[i, 'file_name'] = df.loc[i, 'file_name'] + ".java"
    return df


def extract_handcraft_instances(path):
    handcraft_instances = pd.read_csv(path)
    handcraft_instances = append_suffix(handcraft_instances)
    handcraft_instances = np.array(handcraft_instances['file_name'])
    handcraft_instances = handcraft_instances.tolist()

    return handcraft_instances


def ast_parse(source_file_path):
    with open(source_file_path, 'rb') as file_obj:
        content = file_obj.read()
        result = []
        tree = []
        try:
            tree = jl.parse.parse(content)
        except jl.parser.JavaSyntaxError as e:
            print('JavaSyntaxError:')
            print(source_file_path)
            print(e.description)
            print(e.at)
        for path, node in tree:
            if isinstance(node, jlt.MethodInvocation) or isinstance(node, jlt.SuperMethodInvocation):
                result.append(str(node.member) + "()")
                continue
            if isinstance(node, jlt.ClassCreator):
                result.append(str(node.type.name))
                continue
            if type(node) in types:
                result.append(str(node))
        return result


def ast_parse_CPDP(source_file_path):
    with open(source_file_path, 'rb') as file_obj:
        content = file_obj.read()
        result = []
        tree = []
        try:
            tree = jl.parse.parse(content)
        except jl.parser.JavaSyntaxError as e:
            print('JavaSyntaxError:')
            print(source_file_path)
            print(e.description)
            print(e.at)
        for path, node in tree:
            if type(node) in types_CPDP:
                result.append(str(node))
                print(str(node))
                print('-----------')
        return result


def parse_source(project_root_path, handcraft_file_names, package_heads):
    result = {}
    count = 0
    existed_file_names = []
    for dir_path, dir_names, file_names in os.walk(project_root_path):

        # 如果文件夹下没有文件，直接跳过该文件夹
        if len(file_names) == 0:
            continue

        index = -1
        for _head in package_heads:
            index = int(dir_path.find(_head))
            if index >= 0:
                break
        if index < 0:
            continue

        package_name = dir_path[index:]
        package_name = package_name.replace(os.sep, '.')

        for file in file_names:
            if file.endswith('java'):
                if str(package_name + "." + str(file)) not in handcraft_file_names:
                    continue
                existed_file_names.append(str(package_name + "." + str(file)))
                result[package_name + "." + str(file)] = ast_parse_CPDP(str(os.path.join(dir_path, file)))
                count += 1

    for handcraft_file_name in handcraft_file_names:
        handcraft_file_name.replace('.java', '')
        if handcraft_file_name not in existed_file_names:
            print('This file is not in csv list:' + handcraft_file_name)

    print("data size : " + str(count))
    return result


def padding_vector(vector, size):
    if len(vector) == size:
        return vector
    padding = np.zeros((1, size - len(vector)))
    padding = list(np.squeeze(padding))
    vector += map(int, padding)
    return vector


def padding_all(dict_token, size):
    result = {}
    for key, vector in dict_token.items():
        pv = padding_vector(vector, size)
        result[key] = pv
    return result


def max_length(d):
    max_len = 0
    for value in d.values():
        if max_len < len(value):
            max_len = len(value)
    return max_len


def transform_token_to_number(list_dict_token):
    frequence = {}
    for _dict_token in list_dict_token:
        for _token_vector in _dict_token.values():
            for _token in _token_vector:
                if frequence.__contains__(_token):
                    frequence[_token] = frequence[_token] + 1
                else:
                    frequence[_token] = 1

    vocabulary = {}  # 用来学习每个token的数字表示的映射表    token:number
    result = []
    count = 0
    max_len = 0
    for dict_token in list_dict_token:
        _dict_encode = {}
        for file_name, token_vector in dict_token.items():
            vector = []
            for v in token_vector:
                if frequence[v] < 3:
                    continue

                if vocabulary.__contains__(v):
                    vector.append(vocabulary.get(v))
                else:
                    count = count + 1
                    vector.append(count)
                    vocabulary[v] = count
            if len(vector) > max_len:
                max_len = len(vector)
            _dict_encode[file_name] = vector
        result.append(_dict_encode)

    for i in range(len(result)):
        result[i] = padding_all(result[i], max_len)
    return result, max_len, len(vocabulary)


def extract_data(path_handcraft_file, dict_encoding_vector):

    def extract_label(df, file_name):
        row = df[df.file_name == file_name]['bug']
        row = np.array(row).tolist()
        if row[0] > 1:
            row[0] = 1
        return row

    def extract_feature(df, file_name):
        row = df[df.file_name == file_name][features]
        row = np.array(row).tolist()
        row = np.squeeze(row)
        row = list(row)
        return row

    ast_x_data = []
    hand_x_data = []
    label_data = []
    raw_handcraft = pd.read_csv(path_handcraft_file)
    raw_handcraft = append_suffix(raw_handcraft)
    for key, value in dict_encoding_vector.items():
        ast_x_data.append(value)
        hand_x_data.append(extract_feature(raw_handcraft, key))
        label_data.append(extract_label(raw_handcraft, key))
    ast_x_data = np.array(ast_x_data)
    hand_x_data = np.array(hand_x_data)
    label_data = np.array(label_data)

    return ast_x_data, hand_x_data, label_data
