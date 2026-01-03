import torch


def test_torch_tensor_ops():
    x = torch.tensor([[1.0, 2.0], [3.0, 4.0]])
    y = x.mean()
    assert y.item() == 2.5


def test_torch_autograd():
    x = torch.randn(4, 4, requires_grad=True)
    y = (x @ x.T).sum()
    y.backward()
    assert x.grad is not None
    assert x.grad.shape == x.shape


def test_torch_gpu_build():
    assert torch.version.cuda is not None
    assert "cpu" not in torch.__version__
