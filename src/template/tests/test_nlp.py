import numpy as np
from transformers import BertConfig
from tokenizers import Tokenizer
from tokenizers.models import BPE
import datasets
from sentence_transformers import util
from accelerate import Accelerator
import spacy


def test_transformers_config():
    cfg = BertConfig(hidden_size=128, num_hidden_layers=2)
    assert cfg.hidden_size == 128


def test_tokenizers_basic():
    tokenizer = Tokenizer(BPE())
    assert tokenizer is not None


def test_datasets_from_dict():
    data = datasets.Dataset.from_dict({"text": ["hello", "world"], "label": [0, 1]})
    assert len(data) == 2


def test_sentence_transformers_utils():
    a = np.array([[1.0, 0.0]])
    b = np.array([[0.0, 1.0]])
    sim = util.cos_sim(a, b)
    assert sim.shape == (1, 1)


def test_accelerate_basic():
    acc = Accelerator()
    assert acc.device.type == "cpu"


def test_spacy_blank_pipeline():
    nlp = spacy.blank("en")
    doc = nlp("Hello world")
    assert len(doc) == 2
