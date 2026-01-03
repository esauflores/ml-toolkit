import numpy as np
import xgboost as xgb
import lightgbm as lgb
import catboost as cb
from sklearn.linear_model import LogisticRegression


def test_numpy_basic():
    x = np.array([1.0, 2.0, 3.0])
    y = x.mean()
    assert y == 2.0


def test_sklearn_estimator():
    model = LogisticRegression()
    assert model is not None


def test_xgboost_dmatrix():
    X = np.array([[1.0, 2.0], [3.0, 4.0]])
    y = np.array([0, 1])
    dmat = xgb.DMatrix(X, label=y)
    assert dmat.num_row() == 2


def test_lightgbm_dataset():
    X = np.array([[1.0, 2.0], [3.0, 4.0]])
    y = np.array([0, 1])
    data = lgb.Dataset(X, label=y)
    data.construct()
    assert data.num_data() == 2


def test_catboost_model_init():
    model = cb.CatBoostClassifier(iterations=1, verbose=False)
    params = model.get_params()
    assert params["iterations"] == 1

