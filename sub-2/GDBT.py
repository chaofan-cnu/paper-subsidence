#导入数值计算库
import numpy as np
#导入科学计算库
import pandas as pd
#导入交叉验证库
#from sklearn import cross_validation
from sklearn.model_selection import train_test_split
#导入梯度提升决策树算法库
from sklearn.ensemble import GradientBoostingRegressor

#改变当前工作路径
import os
os.chdir('D:\\data\\ml\\GDBT')

#获取当前工作路径
os.getcwd()

#读取地面沉降数据并创建名为ls的数据表
ls=pd.DataFrame(pd.read_excel('subsidence.xlsx'))

#查看数据表内容
ls.head()

#查看数据表列标
ls.columns

#设置特征值X，分别为地下水、可压缩层厚度、动载荷（数据场势值）和静载荷（IBI）
X = np.array(ls[['x1', 'x2', 'x3', 'x4']])

#设置目标值Y
Y = np.array(ls['y'])

#查看数据集的维度
X.shape,Y.shape

#采用随机的方式将数据表分割为训练集和测试集，其中70%的训练集数据用来训练模型，30%的测试集数据用来检验模型准确率
X_train,X_test,y_train,y_test = train_test_split(X, Y, test_size=0.3, random_state=0)

#查看训练集的维度
X_train.shape
y_train.shape

#查看测试集的维度
X_test.shape
y_test.shape

#建立模型
regr = GradientBoostingRegressor(max_depth=100, random_state=0)

#对模型进行训练
regr = regr.fit(X_train, y_train)

#对模型进行测试
regr.score(X_test, y_test)

#打印系数
print(regr.feature_importances_)
