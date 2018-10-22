FROM daskdev/dask-notebook

RUN conda install \
    conda-forge::dask-ml \
    conda-forge::tpot \
    py-xgboost \
    fastparquet \
    gcsfs

RUN pip install --no-cache-dir --no-deps git+https://github.com/dask/dask-xgboost


ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]
ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
