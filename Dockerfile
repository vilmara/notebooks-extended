FROM rapidsai/rapidsai:cuda9.2-runtime-ubuntu16.04

SHELL ["/bin/bash", "-c"]
RUN source activate rapids && conda install -y \
        matplotlib \
        scikit-learn \
        seaborn \
        python-louvain \
        jinja2 \
        && pip install graphistry mockito

RUN source activate rapids && conda install -c \
        nvidia/label/cuda10.0 -c rapidsai/label/cuda10.0 -c numba -c conda-forge -c defaults cugraph
        
# ToDo: let user supply kaggle creds
RUN source activate rapids && pip install kaggle

ADD data /data
RUN mkdir -p /rapids/notebooks/extended
# symlinked so users can browse the data directory inside JupyterLab
RUN ln -s /data /rapids/notebooks/extended

ADD cpu_comparisons /rapids/notebooks/extended/cpu_comparisons
ADD tutorials /rapids/notebooks/extended/tutorials
ADD cugraph_benchmark /rapids/notebooks/extended/cugraph_benchmark

WORKDIR /rapids/notebooks/extended
CMD source activate rapids && sh /rapids/notebooks/utils/start-jupyter.sh
