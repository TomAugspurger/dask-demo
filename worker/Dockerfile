FROM daskdev/dask

RUN conda install \
    conda-forge::dask-ml \
    conda-forge::tpot \
    py-xgboost

RUN pip install --no-cache-dir --no-deps git+https://github.com/dask/dask-xgboost


ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]