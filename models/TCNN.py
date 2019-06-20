import torch.nn as nn
import torch


class TCNN(nn.Module):
    def __init__(self, params):
        super(TCNN, self).__init__()
        self.embedding = nn.Embedding(params['DICT_SIZE'], params['EMBED_DIM'])
        self.conv = nn.Conv1d(in_channels=params['TOKEN_SIZE'],
                              out_channels=params['N_FILTER'],
                              kernel_size=params['FILTER_SIZE'],
                              stride=params['STRIDE'],
                              padding=params['PADDING']  # suggested padding = (kernel_size-stride)/2
                              )
        self.relu_conv = nn.ReLU()
        self.pool = nn.MaxPool1d(kernel_size=params['POOL_SIZE'])  # pool_size

        # new dim is (EMBED_DIM - FILTER_SIZE + 2 * padding) / stride + 1
        new_dim = (params['EMBED_DIM'] - params['FILTER_SIZE'] + 2 * params['PADDING']) / params['STRIDE'] + 1
        new_dim = new_dim / params['POOL_SIZE']
        new_dim = int(new_dim)

        self.fc = nn.Linear(params['N_FILTER'] * new_dim, params['N_HIDDEN_NODE'])
        # self.relu_fc = nn.ReLU()
        self.out = nn.Linear(params['N_HIDDEN_NODE'], 1)
        self.sigmoid = nn.Sigmoid()

    def forward(self, x, x_src, x_tar):
        x = x.long()
        x_src = x_src.long()
        x_tar = x_tar.long()

        x = self.embedding(x)
        x_src = self.embedding(x_src)
        x_tar = self.embedding(x_tar)

        x = self.conv(x)
        x_src = self.conv(x_src)
        x_tar = self.conv(x_tar)

        x = self.relu_conv(x)
        x_src = self.relu_conv(x_src)
        x_tar = self.relu_conv(x_tar)

        x = self.pool(x)
        x_src = self.pool(x_src)
        x_tar = self.pool(x_tar)

        x = x.contiguous()
        x_src = x_src.contiguous()
        x_tar = x_tar.contiguous()

        x = x.view(x.size(0), -1)
        x_src = x_src.view(x_src.size(0), -1)
        x_tar = x_tar.view(x_tar.size(0), -1)

        x = self.fc(x)
        x_src = self.fc(x_src)
        x_tar = self.fc(x_tar)

        x_batch_mmd = x
        x_src_mmd = x_src
        x_tar_mmd = x_tar

        x = self.out(x)
        y_score = self.sigmoid(x)
        y_pred = torch.round(y_score)
        return y_score, y_pred, x_batch_mmd, x_src_mmd, x_tar_mmd
